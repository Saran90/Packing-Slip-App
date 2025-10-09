import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/api/sales/models/sales_response.dart';

import '../../data/error/failures.dart';
import '../../utils/messages.dart';
import '../api_client.dart';
import '../endpoints.dart';
import '../error_response.dart';

class SalesApi extends ApiClient {
  SalesApi({required baseUrl})
      : super(baseUrl: apiBaseUrl, isAuthenticated: true);

  Future<Either<Failure, SalesResponse?>> getSales() async {
    try {
      var response = await get(salesUrl);
      if (response.isOk) {
        SalesResponse salesResponse = SalesResponse.fromJson(response.body);
        return Right(salesResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else if (response.statusCode == 404) {
        return Left(NoDataFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Sales Call: $exception');
      if (exception is DioException) {
        debugPrint('Sales Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }
}