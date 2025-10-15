import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:packing_slip_app/api/sales/models/get_sales_by_id_response.dart';
import 'package:packing_slip_app/api/sales/models/sales_response.dart';
import 'package:packing_slip_app/api/sales/models/update_sales_response.dart';

import '../../data/error/failures.dart';
import '../../utils/messages.dart';
import '../api_client.dart';
import '../endpoints.dart';
import '../error_response.dart';
import 'models/get_all_products_by_barcode_response.dart';
import 'models/get_product_by_barcode_response.dart';
import 'models/get_product_by_id_response.dart';
import 'models/get_products_response.dart';
import 'models/tax_response.dart';
import 'models/update_sales_request.dart';

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

  Future<Either<Failure, GetSalesByIdResponse?>> getSalesById({
    required int id,
  }) async {
    try {
      var response = await get('$salesByIdUrl?BillId=$id');
      if (response.isOk) {
        GetSalesByIdResponse salesResponse = GetSalesByIdResponse.fromJson(
          response.body,
        );
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
      debugPrint('Sales By Id Call: $exception');
      if (exception is DioException) {
        debugPrint('Sales By Id Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, UpdateSalesResponse?>> updateSales({
    required UpdateSalesRequest request,
  }) async {
    try {
      print('Request: ${request.toJson()}');
      var response = await post(updateSalesUrl, request.toJson());
      if (response.isOk) {
        UpdateSalesResponse salesResponse = UpdateSalesResponse.fromJson(
          response.body,
        );
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
      debugPrint('Update Sales Call: $exception');
      if (exception is DioException) {
        debugPrint('Update Sales Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, GetProductByBarcodeResponse?>> getProductByBarcode(
      String barcode,
      ) async {
    try {
      var response = await get('$getProductByCodeUrl?barCode=$barcode');
      if (response.isOk) {
        GetProductByBarcodeResponse productByBarcodeResponse =
        GetProductByBarcodeResponse.fromJson(response.body);
        return Right(productByBarcodeResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else if (response.statusCode == 404) {
        return Left(NoDataFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Product By Barcode Call: $exception');
      if (exception is DioException) {
        debugPrint('Product By Barcode Call Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, GetAllProductsByBarcodeResponse?>>
  getAllProductsByBarcode(String barcode) async {
    try {
      var response = await get('$getAllProductsByCodeUrl?barCode=$barcode');
      if (response.isOk) {
        GetAllProductsByBarcodeResponse productByBarcodeResponse =
        GetAllProductsByBarcodeResponse.fromJson(response.body);
        return Right(productByBarcodeResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else if (response.statusCode == 404) {
        return Left(NoDataFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Product By Barcode Call: $exception');
      if (exception is DioException) {
        debugPrint('Product By Barcode Call Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, GetProductByIdResponse?>> getProductsById(
      int id,
      ) async {
    try {
      var response = await get('$getProductsByIdUrl?productId=$id');
      if (response.isOk) {
        GetProductByIdResponse productByIdResponse =
        GetProductByIdResponse.fromJson(response.body);
        return Right(productByIdResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else if (response.statusCode == 404) {
        return Left(NoDataFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Product By Id Call: $exception');
      if (exception is DioException) {
        debugPrint('Product By Barcode Call Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, GetProductsResponse?>> getProducts({
    required String name,
  }) async {
    try {
      var response = await get(productsUrl, query: {'name': name});
      if (response.isOk) {
        GetProductsResponse productsResponse = GetProductsResponse.fromJson(
          response.body,
        );
        return Right(productsResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Products Call: $exception');
      if (exception is DioException) {
        debugPrint('Products Call Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }

  Future<Either<Failure, TaxResponse?>> geTaxSlabs() async {
    try {
      var response = await get(taxUrl);
      if (response.isOk) {
        TaxResponse taxResponse = TaxResponse.fromJson(response.body);
        return Right(taxResponse);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure());
      } else {
        ErrorResponse? errorResponse = ErrorResponse.fromJson(response.body);
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
    } catch (exception) {
      debugPrint('Tax Slabs Call: $exception');
      if (exception is DioException) {
        debugPrint('Tax Slabs Call Exception: ${exception.message}');
        ErrorResponse? errorResponse = ErrorResponse.fromJson(
          exception.response?.data,
        );
        return Left(APIFailure<ErrorResponse>(error: errorResponse));
      }
      return Left(ServerFailure(message: exception.toString()));
    }
  }
}
