import 'package:flutter/foundation.dart';
import 'package:foodly/model/activity.dart';
import 'package:foodly/services/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

import '../config/constant.dart';
import '../model/product.dart';
// import '../models/content.dart';
import './user_services.dart';

mixin ActivityService on Model, UserService {
  static List<Activity> _activityList = [];
  List<Activity> get activityList => _activityList;

  static bool _isLoadingActivity = false;
  bool get isLoadingActivity => _isLoadingActivity;

  Future<dynamic> fetchActivities() async {
    var _activityData;

    _isLoadingActivity = true;
    notifyListeners();

    var dio = Dio();
    dio.options
      ..baseUrl = Constant.baseUrl
      ..validateStatus = (int? status) {
        return status! >= 200 && status < 300;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

    List<Activity> _fetchedActivities = [];

    try {
      var responseData = await dio.get(
        "${Constant.activity}/$uid",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE GET MY ACTIVITIES: $responseData");

      _activityData = responseData.data;

      if (responseData.data['data'] != null) {
        for (var activity in responseData.data['data']) {
          if (kDebugMode) {
            print(activity);
          }
          _fetchedActivities.add(Activity.fromJson(activity));
        }
      } else {
        if (kDebugMode) {
          print("FETCH GET MY ACTIVITIES error: ${responseData.data['message']}");
        }
      }
    } catch (e) {
      print(e);
    }

    // Sort fetched activities by created_at in descending order
    _fetchedActivities.sort((a, b) {
      DateTime aDateTime = DateTime.parse(a.createdAt);
      DateTime bDateTime = DateTime.parse(b.createdAt);
      return bDateTime.compareTo(aDateTime); // newest first
    });

    // Keep only the latest 5 activities and prepare to delete older ones
    if (_fetchedActivities.length > 5) {
      List<Activity> activitiesToDelete = _fetchedActivities.sublist(5);
      // Delete each older activity from the database
      for (var activity in activitiesToDelete) {
        await deleteActivity(activity.id, uid);
      }
      // Update the list to keep only the latest 5
      _fetchedActivities = _fetchedActivities.sublist(0, 5);
    }

    _activityList = _fetchedActivities;

    _isLoadingActivity = false;
    notifyListeners();

    return _activityData;
  }


  // Future<dynamic> fetchActivities() async {
  //   var _activityData;
  //
  //   _isLoadingActivity = true;
  //   notifyListeners();
  //
  //   var dio = Dio();
  //   dio.options
  //     ..baseUrl = Constant.baseUrl
  //     // ..connectTimeout = 10000 //5s
  //     // ..receiveTimeout = 10000
  //     ..validateStatus = (int? status) {
  //       return status! > 0;
  //     }
  //     ..headers = {
  //       HttpHeaders.userAgentHeader: 'dio',
  //       HttpHeaders.authorizationHeader: 'Bearer $token',
  //     };
  //
  //   List<Activity> _fetchedActivities = [];
  //
  //   try {
  //     var responseData = await dio.get(
  //       "${Constant.activity}/$uid",
  //       // data: _data,
  //       options: Options(
  //         contentType: Headers.formUrlEncodedContentType,
  //       ),
  //     );
  //
  //     print("RESPONSE GET MY ACTIVITIES: $responseData");
  //
  //     _activityData = responseData.data;
  //
  //     if (responseData.data['data'] != null) {
  //       for (var activity in responseData.data['data']) {
  //         if (kDebugMode) {
  //           print(activity);
  //         }
  //
  //         _fetchedActivities.add(Activity.fromJson(activity));
  //       }
  //     } else {
  //       if (kDebugMode) {
  //         print("FETCH GET MY ACTIVITIES error: ${responseData.data['message']}");
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   _activityList = _fetchedActivities;
  //
  //   _isLoadingActivity = false;
  //   notifyListeners();
  //
  //   return _activityData;
  // }


  static Future<dynamic> getActivities() async {
    var _activityData;

    _isLoadingActivity = true;
    MainModel().notifyListeners();

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
        HttpHeaders.authorizationHeader: 'Bearer ${MainModel().token}',
      };

    List<Activity> _fetchedActivities = [];

    try {
      var responseData = await dio.get(
        "${Constant.activity}/${MainModel().uid}",
        // data: _data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print("RESPONSE GET MY ACTIVITIES: $responseData");

      _activityData = responseData.data;

      if (responseData.data['data'] != null) {
        for (var activity in responseData.data['data']) {
          print(activity);

          _fetchedActivities.add(Activity.fromJson(activity));
        }
      } else {
        print("FETCH GET MY ACTIVITIES error: ${responseData.data['message']}");
      }
    } catch (e) {
      print(e);
    }

    _activityList = _fetchedActivities;

    _isLoadingActivity = false;
    MainModel().notifyListeners();

    return _activityData;
  }

  /// delete
  Future<void> deleteActivity(dynamic activityId,dynamic uid) async {
    _isLoadingActivity = true;
    notifyListeners();

    var dio = Dio();
    dio.options
      ..baseUrl = Constant.baseUrl
      ..validateStatus = (int? status) {
        return status! >= 200 && status < 300;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.authorizationHeader: 'Bearer ${MainModel().token}',
      };

    try  {
      var responseData = await dio.delete(
        "${Constant.activity}/$activityId",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (kDebugMode) {
        print("RESPONSE DELETE ACTIVITY: $responseData");
      }

      if (responseData.statusCode == 200) {
        if (kDebugMode) {
          print("Activity deleted successfully.");
        }
        // Optionally remove the deleted activity from the list
      } else {
        print("DELETE ACTIVITY error: ${responseData.data['message']}");
      }
    } catch (e) {
      print("Error deleting activity: $e");
    }

    _isLoadingActivity = false;
    notifyListeners();
  }





  // Future<PustakaKata> searchPustakaKata(String title) async {
  //   PustakaKata _puscerData;
  //
  //   var dio = Dio();
  //   dio.options
  //     ..baseUrl = Constant.baseUrl
  //     ..connectTimeout = 10000 //5s
  //     ..receiveTimeout = 10000
  //     ..validateStatus = (int status) {
  //       return status > 0;
  //     }
  //     ..queryParameters = {"title": title}
  //     ..headers = {
  //       HttpHeaders.userAgentHeader: 'dio',
  //       HttpHeaders.authorizationHeader: 'Bearer $token',
  //     };
  //
  //   _isLoadingPustakaKata = true;
  //   notifyListeners();
  //
  //   print(uid);
  //
  //   List<PustakaKata> _fetchedPuscet = [];
  //
  //   print("URL: ${Constant.search_pustaka_kata}");
  //
  //   try {
  //     var responseData = await dio.get(
  //       "${Constant.search_pustaka_kata}",
  //       options: Options(
  //         contentType: Headers.formUrlEncodedContentType,
  //       ),
  //     );
  //
  //     print("RESPONSE GET SEARCH PUSTAKA KATA: $responseData");
  //
  //     if (responseData.data['data'] != null) {
  //       for (var puscet in responseData.data['data']) {
  //         print(puscet);
  //         _puscerData = PustakaKata.fromJson(puscet);
  //
  //         print(_puscerData.createdAt);
  //
  //         _fetchedPuscet.add(_puscerData);
  //       }
  //     } else {
  //       print(
  //           "FETCH GET SEARCH PUSTAKA KATA error: ${responseData.data['message']}");
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   _searchPusKatList = _fetchedPuscet;
  //
  //   _isLoadingPustakaKata = false;
  //   notifyListeners();
  //
  //   return _puscerData;
  // }

  void clearActivities() {
    _activityList.clear();
    notifyListeners();
  }

  // void clearSearchPustakaKataList() {
  //   _searchPusKatList.clear();
  //   notifyListeners();
  // }
}
