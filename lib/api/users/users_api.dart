import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:packing_slip_app/api/users/models/add_user_response.dart';
import 'package:packing_slip_app/api/users/models/allot_series_request.dart';
import 'package:packing_slip_app/api/users/models/allot_series_response.dart';
import 'package:packing_slip_app/api/users/models/get_user_response.dart';
import 'package:packing_slip_app/api/users/models/users_response.dart';

import '../../data/error/failures.dart';
import '../api_client.dart';
import '../endpoints.dart';
import '../error_response.dart';
import 'models/add_user_request.dart';

class UsersApi extends ApiClient {
  UsersApi({required baseUrl})
      : super(baseUrl: apiBaseUrl, isAuthenticated: true);

  Future<Either<Failure, AddUserResponse?>> addUser({required AddUserRequest request}) async {
    try {
      var response = await post(addUserUrl, request.toJson());
      if (response.isOk) {
        AddUserResponse addUserResponse = AddUserResponse.fromJson(response.body);
        return Right(addUserResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else if (response.statusCode == 404) {
        return Left(NoDataFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Add User Call: $exception');
      if (exception is DioException) {
        debugPrint('Add User Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, AllotSeriesResponse?>> allotSeries({required AllotSeriesRequest request}) async {
    try {
      var response = await post(allotSeriesUrl, request.toJson());
      if (response.isOk) {
        AllotSeriesResponse allotSeriesResponse = AllotSeriesResponse.fromJson(response.body);
        return Right(allotSeriesResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else if (response.statusCode == 404) {
        return Left(NoDataFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Allot Series Call: $exception');
      if (exception is DioException) {
        debugPrint('Allot Series Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, GetUserResponse?>> getUserById({required int id}) async {
    try {
      var response = await get('$getUserByIdUrl?userId=$id');
      if (response.isOk) {
        GetUserResponse userResponse = GetUserResponse.fromJson(response.body);
        return Right(userResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else if (response.statusCode == 404) {
        return Left(NoDataFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Get User Call: $exception');
      if (exception is DioException) {
        debugPrint('Get User Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, UsersResponse?>> getUsers() async {
    try {
      var response = await get(getUsersUrl);
      if (response.isOk) {
        UsersResponse usersResponse = UsersResponse.fromJson(response.body);
        return Right(usersResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else if (response.statusCode == 404) {
        return Left(NoDataFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Users Call: $exception');
      if (exception is DioException) {
        debugPrint('Users Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }
}
