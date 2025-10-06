import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/error/failures.dart';
import '../../utils/messages.dart';
import '../api_client.dart';
import '../endpoints.dart';
import '../error_response.dart';
import 'models/login_request.dart';
import 'models/login_response.dart';

class AuthApi extends ApiClient {
  AuthApi({required baseUrl}) : super(baseUrl: apiBaseUrl);

  Future<Either<Failure, LoginResponse?>> login(LoginRequest request) async {
    try {
      var response = await post(loginUrl, request.toJson());
      if (response.isOk) {
        LoginResponse loginResponse = LoginResponse.fromJson(response.body);
        return Right(loginResponse);
      } else if (response.statusCode == 401) {
        return Left(ServerFailure(message: loginFailedMessage));
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Login Call: $exception');
      if (exception is DioException) {
        debugPrint('Login Call Exception: ${exception.message}');
        ErrorResponse? errorResponse =
        ErrorResponse.fromJson(exception.response?.data);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }
}