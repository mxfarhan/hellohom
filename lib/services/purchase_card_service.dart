import 'package:flutter/foundation.dart';
import 'package:foodly/model/purchase_card.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

import '../config/constant.dart';
import '../model/product.dart';
// import '../models/content.dart';
import './user_services.dart';

mixin PurchaseCardService on Model, UserService {
  List<PurchaseCard> _purchaseCardList = [];
  List<PurchaseCard> get purchaseCardList => _purchaseCardList;

  PurchaseCard _checkCardCodeResult = PurchaseCard();
  PurchaseCard get checkCardCodeResult => _checkCardCodeResult;

  bool _isLoadingPurchaseCard = false;
  bool get isLoadingPurchaseCard => _isLoadingPurchaseCard;

  Future<dynamic> fetchMyPurchaseCards() async {
    var _purchaseData;

    _isLoadingPurchaseCard = true;
    notifyListeners();

    var dio = Dio();
    dio.options
      ..baseUrl = Constant.baseUrl
      // ..connectTimeout = 10000 //5s
      // ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

    List<PurchaseCard> _fetchedPurchaseCards = [];

    try {
      var responseData = await dio.get(
        "${Constant.purchase_card}/${user.id}",
        // data: _data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("url: ${Constant.purchase_card}/${user.id}");
      print("RESPONSE GET MY PURCHASE CARDS: $responseData");

      _purchaseData = responseData.data;

      if (responseData.data['message'] == 'true') {
        for (var purchase in responseData.data['data']) {
          //
          _fetchedPurchaseCards.add(PurchaseCard.fromJson(purchase));
        }
      } else {
        print(
            "FETCH GET MY PURCHASE CARDS error: ${responseData.data['message']}");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    _purchaseCardList = _fetchedPurchaseCards;

    _isLoadingPurchaseCard = false;
    notifyListeners();

    return _purchaseData;
  }

  Future<Map> purchaseCard(Map data) async {
    var _responseData;
    var dio = Dio();
    //
    dio.options
      ..baseUrl = Constant.baseUrl
      // ..connectTimeout = 10000 //5s
      // ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

    _isLoadingPurchaseCard = true;
    notifyListeners();

    print(data);

    try {
      var responseData = await dio.post(
        Constant.purchase_card,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE PURCHASE CARD: $responseData");

      _responseData = responseData.data;
      notifyListeners();

      if (responseData.data['data'] != null) {
        //
        print("Response success purchase card ${responseData.data}");
      } else {
        //
        print("Response error purchase card ${responseData.data}");
      }
    } catch (e) {
      print("catch $e");
    }

    _isLoadingPurchaseCard = false;
    notifyListeners();

    return _responseData;
  }

  Future<Map> activateCard(Map data) async {
    var _responseData;
    var dio = Dio();
    //
    dio.options
      ..baseUrl = Constant.baseUrl
      // ..connectTimeout = 10000 //5s
      // ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

    _isLoadingPurchaseCard = true;
    notifyListeners();

    print(data);

    try {
      var responseData = await dio.post(
        Constant.activate_card,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE ACTIVATE CARD: $responseData");

      _responseData = responseData.data;
      notifyListeners();

      if (responseData.data['message'] == 'Valid') {
        //
        print("Response success activate card ${responseData.data}");
      } else {
        //
        print("Response error activate card ${responseData.data}");
      }
    } catch (e) {
      print("catch $e");
    }

    _isLoadingPurchaseCard = false;
    notifyListeners();

    return _responseData;
  }

  Future<Map> checkCardCode(String cardCode) async {
    var _responseData;
    var dio = Dio();
    //
    dio.options
      ..baseUrl = Constant.baseUrl
      ..connectTimeout = 10000 //5s
      ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        // HttpHeaders.authorizationHeader:
        //     'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2Jlc3Rhcmkua2l0ZXJlYXRpdmUuaWQvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE2OTA5Njc5MTgsImV4cCI6MTcyMjUwMzkxOCwibmJmIjoxNjkwOTY3OTE4LCJqdGkiOiJHd0J3OUdab281QWdFSHRUIiwic3ViIjoiNDYiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.iMrToavpTBTDDEvxKtNkEZxtkdT0ji8p3c-rIDq24-M'
      };

    _isLoadingPurchaseCard = true;
    notifyListeners();

    print(cardCode);

    try {
      var responseData = await dio.get(
        "${Constant.check_card_code}/$cardCode",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE CHECK CARD CODE: $responseData");

      _responseData = responseData.data;
      notifyListeners();

      if (responseData.data['message']) {
        //
        _checkCardCodeResult = PurchaseCard(
            id: responseData.data['data']['id'],
            createdAt: responseData.data['data']['created_at'],
            updatedAt: responseData.data['data']['updated_at'],
            productsId: responseData.data['data']['products_id'],
            status: responseData.data['data']['status'],
            price: responseData.data['data']['price'],
            usersId: responseData.data['data']['users_id'],
            cardCode: responseData.data['data']['card_code']);
        //
        notifyListeners();

        print("Response success check card code ${responseData.data}");
      } else {
        //
        print("Response error check card code ${responseData.data}");
      }
    } catch (e) {
      print("catch $e");
    }

    _isLoadingPurchaseCard = false;
    notifyListeners();

    return _responseData;
  }

  Future<Map> editPurchaseCard(Map data, int id) async {
    var _responseData;
    var dio = Dio();
    //
    dio.options
      ..baseUrl = Constant.baseUrl
      // ..connectTimeout = 10000 //5s
      // ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      };

    _isLoadingPurchaseCard = true;
    notifyListeners();

    print(data);

    try {
      var responseData = await dio.post(
        "${Constant.purchase_card}/$id",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE EDIT PURCHASE CARD: $responseData");

      _responseData = responseData.data;
      notifyListeners();

      if (responseData.data['data'] != null) {
        //
        print("Response success edit purchase card ${responseData.data}");
      } else {
        //
        print("Response error edit purchase card ${responseData.data}");
      }
    } catch (e) {
      print("catch $e");
    }

    _isLoadingPurchaseCard = false;
    notifyListeners();

    return _responseData;
  }

  void clearMyPurchaseCards() {
    _purchaseCardList.clear();
    notifyListeners();
  }

  void clearCheckCardCodeResult() {
    _checkCardCodeResult = PurchaseCard();
    notifyListeners();
  }
}
