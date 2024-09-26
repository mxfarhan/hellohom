import 'package:flutter/foundation.dart';
import 'package:foodly/model/subscription.dart';
import 'package:foodly/services/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

import '../config/constant.dart';
import '../model/product.dart';
import './user_services.dart';

mixin SubscriptionService on Model, UserService {
  List<Subscription> _subscriptionList = [];
  List<Subscription> get subscriptionList => _subscriptionList;

  bool _isLoadingSubscription = false;
  bool get isLoadingSubscription => _isLoadingSubscription;

  Future<dynamic> fetchSubscriptions(MainModel model) async {
    var _subsData;

    _isLoadingSubscription = true;
    notifyListeners();

    var dio = Dio();
    dio.options
      ..baseUrl = Constant.baseUrl
      ..connectTimeout = 10000 //5s
      ..receiveTimeout = 10000
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

    List<Subscription> _fetchedSubs = [];

    try {
      var responseData = await dio.get(
        "${Constant.subscription}/${user.id}",
        // data: _data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (kDebugMode) {
        print("transaction check${Constant.subscription}/${user.id}");
      }

      if (kDebugMode) {
        print("RESPONSE GET MY SUBSCRIPTION: $responseData");
      }

      _subsData = responseData.data;

      if (responseData.data['message'] == 'true')  {
          // Parse the subscriptions if data is not empty
          for (var subs in responseData.data['data']) {
            if (kDebugMode) {
              print(subs);
            }
            _fetchedSubs.add(Subscription.fromJson(subs));
          }
        }else {
        if (kDebugMode) {
          print(
            "FETCH GET MY SUBSCRIPTION error: ${responseData.data['message']}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('fetch subscription error $e');
      }
    }

    _subscriptionList = _fetchedSubs;

    _isLoadingSubscription = false;
    notifyListeners();

    return _subsData;
  }

  Future<Map> subscriptionPlan(Map data) async {
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

    _isLoadingSubscription = true;
    notifyListeners();

    print(data);

    try {
      var responseData = await dio.post(
        Constant.subscription,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE SUBSCRIPTION PLAN: $responseData");

      _responseData = responseData.data;
      notifyListeners();

      if (responseData.data['data'] != null) {
        //
        if (kDebugMode) {
          print("Response success subs plan ${responseData.data}");
        }
      } else {
        //
        if (kDebugMode) {
          print("Response error subs plan ${responseData.data}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("catch $e");
      }
    }

    _isLoadingSubscription = false;
    notifyListeners();

    return _responseData;
  }

  void clearMySubscriptions() {
    _subscriptionList.clear();
    notifyListeners();
  }
}
