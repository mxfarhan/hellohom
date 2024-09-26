import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

import '../config/constant.dart';
import '../model/product.dart';
import './user_services.dart';

mixin ProductService on Model, UserService {
  List<Product> _productList = [];
  List<Product> get productList => _productList;

  Product _hellohomeCardProduct = Product();
  Product get hellohomeCardProduct => _hellohomeCardProduct;

  bool _isLoadingProduct = false;
  bool get isLoadingProduct => _isLoadingProduct;

  Future<dynamic> fetchSubscriptionPlanProducts() async {
    var _productData;

    _isLoadingProduct = true;
    notifyListeners();

    var dio = Dio();
    dio.options
      ..baseUrl = Constant.baseUrl
      // ..connectTimeout = 10000 //5s
      // ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..queryParameters = {'type': 'subscription'}
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

    List<Product> _fetchedProduct = [];

    try {
      var responseData = await dio.get(
        Constant.productSearch,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE GET SUBSCRIPTION PLAN PRODUCTS: $responseData");

      _productData = responseData;

      if (responseData.statusCode == 200) {
        for (var product in responseData.data['data']) {
          print(product);

          _fetchedProduct.add(Product.fromJson(product));
        }
      } else {
        print(
            "FETCH GET SUBSCRIPTION PLAN PRODUCTS error: ${responseData.data['message']}");
      }
    } catch (e) {
      print(e);
    }

    _productList = _fetchedProduct;

    _isLoadingProduct = false;
    notifyListeners();

    return _productData;
  }

  Future<dynamic> fetchProductCard() async {
    var _productData;

    _isLoadingProduct = true;
    notifyListeners();

    var dio = Dio();
    dio.options
      ..baseUrl = Constant.baseUrl
      ..connectTimeout = 10000 //5s
      ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..queryParameters = {'type': 'card'}
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

    try {
      var responseData = await dio.get(
        Constant.productSearch,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE GET CARD PRODUCT: $responseData");

      _productData = responseData;

      if (responseData.statusCode == 200) {
        _hellohomeCardProduct = Product.fromJson(responseData.data['data'][0]);
        //
      } else {
        print("FETCH GET CARD PRODUCT error: ${responseData.data['message']}");
      }
    } catch (e) {
      print(e);
    }

    _isLoadingProduct = false;
    notifyListeners();

    return _productData;
  }

  void clearProducts() {
    _productList.clear();
    notifyListeners();
  }
}
