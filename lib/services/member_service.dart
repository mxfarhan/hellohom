import 'package:flutter/cupertino.dart';
import 'package:foodly/model/member.dart';
import 'package:foodly/model/purchase_card.dart';
import 'package:foodly/view/auth/signin_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

import '../config/constant.dart';
import '../model/product.dart';
// import '../models/content.dart';
import './user_services.dart';

mixin MemberService on Model, UserService {
  List<Member> _allMembers = [];
  List<Member> get allMembers => _allMembers;

  bool _isLoadingMember = false;
  bool get isLoadingMember => _isLoadingMember;

  Future<dynamic> fetchAllMembers() async {
    var _memberData;

    _isLoadingMember = true;
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

    List<Member> _fetchedMembers = [];

    try {
      var responseData = await dio.get(
        "${Constant.profile}/$uid",
        // data: _data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("url: ${Constant.profile}/$uid");
      print("RESPONSE GET ALL MEMBERS: $responseData");

      _memberData = responseData;

      if (responseData.data['message'] == 'true') {
        for (var member in responseData.data['data']['staff']) {
          //
          _fetchedMembers.add(Member.fromJson(member));
          print("RESPONSE GET ALL MEMBERS Length: ${_fetchedMembers.length}");
        }
      } else {
        print("FETCH GET ALL MEMBERS error: ${responseData.data['message']}");
      }
    } catch (e) {
      print(e);
    }

    _allMembers = _fetchedMembers;

    _isLoadingMember = false;
    notifyListeners();

    return _memberData;
  }

  Future<Map> addOrRemoveMember(dynamic userId) async {
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

    _isLoadingMember = true;
    notifyListeners();

    try {
      var responseData = await dio.delete(
        "${Constant.staffOwner}/$userId",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("${Constant.staffOwner}/$userId");

      print("RESPONSE ADD OR REMOVE MEMBER: $responseData");

      _responseData = responseData.data;

      if (responseData.data['data'] != null) {
        //
        print("Response success add or remove member ${responseData.data}");
      } else {
        //
        print("Response error add or remove member ${responseData.data}");
      }
    } catch (e) {
      print("catch $e");
    }

    _isLoadingMember = false;
    notifyListeners();

    return _responseData;
  }

  Future<Map> deleteUserAccount(dynamic userId) async {
    var _responseData = {};  // Initialize as an empty map
    var dio = Dio();

    dio.options
      ..baseUrl = Constant.baseUrl
      ..validateStatus = (int? status) {
        return status != null && status > 0;  // Ensure status is not null
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token'  // Ensure token is available
      };

    _isLoadingMember = true;
    notifyListeners();

    try {
      var responseData = await dio.delete(
        "${Constant.profile}/$userId",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      debugPrint("Request URL: ${Constant.profile}/$userId");
      print("Response: $responseData");

      _responseData = responseData.data;

      if (responseData.statusCode == 200 && responseData.data['data'] != null) {
        print("User account deleted successfully: ${responseData.data}");

        // After successful deletion, navigate to the login page
        Get.offAll(() => logOut());  // Replace with your login page widget
      } else {
        print("Error deleting user account: ${responseData.data}");
      }
    } catch (e) {
      print("Error in deleteUserAccount: $e");
    } finally {
      _isLoadingMember = false;
      notifyListeners();
    }

    return _responseData;
  }


  Future<Map> addMemberByEmail(Map data) async {
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

    _isLoadingMember = true;
    notifyListeners();

    print(data);

    try {
      var responseData = await dio.post(
        Constant.addMemberByEmail,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE ADD MEMBER BY EMAIL: $responseData");

      _responseData = responseData.data;

      if (responseData.data['message'] == 'true') {
        //
        print("Response success add member by email ${responseData.data}");
      } else {
        //
        print("Response error add member by email ${responseData.data}");
      }
    } catch (e) {
      print("catch $e");
    }

    _isLoadingMember = false;
    notifyListeners();

    return _responseData;
  }

  // void clearProducts() {
  //   _productList.clear();
  //   notifyListeners();
  // }

  void clearAllMembers() {
    _allMembers.clear();
    notifyListeners();
  }
}
