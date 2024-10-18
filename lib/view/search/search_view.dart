import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/model/activity.dart';
import 'package:foodly/services/socket_service.dart';
import 'package:foodly/view/chats/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../model/subscription.dart';
import '../../services/socket_service.dart';
import 'dart:ui';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:scoped_model/scoped_model.dart';
import 'package:foodly/services/main_model.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/date_helpers.dart';
import '../../config/constant.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodly/view/purchase_card_page.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:foodly/config/default_image.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/view/profile/profile_view.dart';
import 'package:get/get.dart';

import '../../services/main_model.dart';

class SearchView extends StatefulWidget {
  final MainModel model;

  SearchView(this.model);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  EasyLoadingStatus? _easyLoadingStatus;
  final NotificationSetUp _noti = NotificationSetUp();

  Timer? _timer;
  var _selectSubscriptionPlan = 0;

  @override
  void initState() {
    super.initState();

    _noti.configurePushNotifications(context);
    _noti.eventListenerCallback(context);
    SocketService.connectAndListenBell(context, widget.model.uid, widget.model);

    loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SocketService.dispose();
    EasyLoading.removeAllCallbacks();
  }


  Future loadData() async {
    EasyLoading.addStatusCallback((status) {
      if (kDebugMode) {
        print('EasyLoading Status $status');
      }
      setState(() {
        _easyLoadingStatus = status;
      });
    });
    //
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var responseData = await widget.model.fetchUser();
      if (responseData.id != null) {
        //

        // SocketService.setUserName(widget.model.user.name!);
        // widget.model.connectAndListen(widget.model);
        //
        var responsePurchaseCard = await widget.model.fetchMyPurchaseCards();
        if (responsePurchaseCard['message'] == 'true') {
          if (widget.model.purchaseCardList.isEmpty &&
              widget.model.role == "USER") {
            //
            _timer?.cancel();
            await EasyLoading.dismiss();
            //
            _showSuccessDialog();
          } else {
            //
            var responsActivity = await widget.model.fetchActivities();
            if (responsActivity['message'] == 'true') {
              //
              _timer?.cancel();
              await EasyLoading.dismiss();
            }
          }
        }
      } else {
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
    } catch (e) {
      //
      print("Exception: $e");
      //
      _timer?.cancel();
      await EasyLoading.dismiss();
    }
  }

  Future<int> calculateInitialDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString('countdown_date');
    String? savedTime = prefs.getString('countdown_time');

    if (savedDate != null && savedTime != null) {
      DateTime savedDateTime = DateTime.parse("$savedDate $savedTime");
      int remainingSeconds = 60 - DateTime.now().difference(savedDateTime).inSeconds;
      return remainingSeconds > 0 ? remainingSeconds : 0;  // Ensure it's not negative
    }
    return 0;  // Default initial duration if no saved data
  }

  Future<void> saveStartTime(String date, String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('countdown_date', date);
    await prefs.setString('countdown_time', time);
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(
                  color: ConstColors.primaryColor,
                ),
                // padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActions(model),
                    Expanded(
                        child:
                            model.isLoadingUser ||
                                    model.isLoadingActivity ||
                                    model.isLoadingPurchaseCard ||
                                    _easyLoadingStatus == EasyLoadingStatus.show
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Color(0xfff6f6f6),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [],
                                    ))
                                : _easyLoadingStatus ==
                                            EasyLoadingStatus.dismiss &&
                                        !model.isLoadingUser &&
                                        !model.isLoadingActivity &&
                                        !model.isLoadingPurchaseCard &&
                                        model.user.roles == "USER" &&
                                        model.purchaseCardList.isEmpty
                                    ? _buildPlaceholderBuyCard(model)
                                    : _easyLoadingStatus ==
                                                EasyLoadingStatus.dismiss &&
                                            !model.isLoadingUser &&
                                            !model.isLoadingActivity &&
                                            !model.isLoadingPurchaseCard &&
                                            model.user.roles == "USER" &&
                                            model.purchaseCardList.isNotEmpty
                                        ? _buildPlaceholderActivateCard(model)
                                        : _easyLoadingStatus ==
                                                        EasyLoadingStatus
                                                            .dismiss &&
                                                    !model.isLoadingUser &&
                                                    !model.isLoadingActivity &&
                                                    !model
                                                        .isLoadingPurchaseCard &&
                                                    model.user.roles ==
                                                        "OWNER" ||
                                                model.user.roles == "STAFF"
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    color: Color(0xfff6f6f6),
                                                    borderRadius: BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20))),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 12,
                                                          right: 12,
                                                          top: 20,
                                                          bottom: 10),
                                                      child: Text(
                                                        "Activité :",
                                                        style: pSemiBold20
                                                            .copyWith(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: model.activityList
                                                                    .isEmpty ||
                                                                model
                                                                    .activityList
                                                                    .where((element) =>
                                                                        DateTime.now()
                                                                            .difference(DateTime.parse(
                                                                                "${element.date} ${element.time}"))
                                                                            .inHours <
                                                                        24)
                                                                    .toList()
                                                                    .isEmpty
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 80,
                                                                    width: 80,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/icons/Web and Technology/alarm.svg',
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      color: ConstColors
                                                                          .text2Color,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          30),
                                                                  Center(
                                                                    child: Text(
                                                                      "Il n'y a pas encore d'activité",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: pSemiBold20.copyWith(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              ConstColors.text2Color),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : GroupedListView<dynamic, String>(
                                                          elements: _getRecentActivities(model.activityList),
                                                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                                                          groupBy: (element) => DateTime.parse(element.createdAt).isToday
                                                              ? "Today"
                                                              : DateFormat("dd MMM yyyy").format(DateTime.parse(element.createdAt)),
                                                          groupSeparatorBuilder: (String groupByValue) => Container(
                                                            margin: EdgeInsets.only(top: 10),
                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                            height: 30,
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      height: 15,
                                                                      width: 2,
                                                                      color: ConstColors.primaryColor,
                                                                    ),
                                                                    SizedBox(width: 10),
                                                                    Text(
                                                                      groupByValue,
                                                                      style: pSemiBold18.copyWith(
                                                                        fontSize: 16,
                                                                        color: ConstColors.text2Color,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(width: 20),
                                                                Expanded(
                                                                  child: Container(
                                                                    height: 1,
                                                                    color: Colors.grey[200],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          itemBuilder: (context, dynamic element) {
                                                            final activity = element;
                                                            return Dismissible(
                                                              key: Key(activity.id.toString()),
                                                              background: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Colors.red.withOpacity(0.75),
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                alignment: AlignmentDirectional.centerStart,
                                                                child:  Align(alignment: Alignment.centerRight,child: Icon(Icons.delete, color: Colors.white)),
                                                              ),
                                                              direction: DismissDirection.endToStart,
                                                              onDismissed: (direction) {
                                                                setState(() {
                                                                  model.activityList.remove(element);
                                                                });
                                                                model.deleteActivity(activity.id,model.uid);
                                                                Get.closeCurrentSnackbar();
                                                                Get.snackbar(
                                                                  "supprimée !",
                                                                  "La notification a été supprimée",
                                                                  snackPosition: SnackPosition.BOTTOM,
                                                                  backgroundColor: ConstColors.primaryColor.withOpacity(0.6),
                                                                  colorText: Colors.black,
                                                                  borderRadius: 10,
                                                                  margin: EdgeInsets.all(14),
                                                                  duration: Duration(seconds: 2),
                                                                );
                                                                // ScaffoldMessenger.of(context).showSnackBar(
                                                                //   SnackBar(
                                                                //     content: Text('Notification deleted'),
                                                                //     duration: Duration(seconds: 2),
                                                                //   ),
                                                                // );

                                                              },

                                                              child: GestureDetector(
                                                                onTap: () {

                                                                  if (DateTime.now().difference(DateTime.parse("${element.date} ${element.time}")).inMinutes < 1 && element.type == "chat") {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatPage(model, element)));
                                                                  } else if (DateTime.now().difference(DateTime.parse("${element.date} ${element.time}")).inMinutes < 1 && element.type == "bell") {
                                                                    _showModalBottomSheet(context, element, model);
                                                                  }else{
                                                                    Get.closeCurrentSnackbar();
                                                                    Get.snackbar(
                                                                      "Cloche expirée!",
                                                                      "cette cloche est plus ancienne que 60 secondes",
                                                                      snackPosition: SnackPosition.BOTTOM,
                                                                      backgroundColor: ConstColors.primaryColor.withOpacity(0.6),
                                                                      colorText: Colors.black,
                                                                      borderRadius: 10,
                                                                      margin: EdgeInsets.all(14),
                                                                      duration: Duration(seconds: 1),
                                                                    );
                                                                  }
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.only(top: 10),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Row(
                                                                          children: [
                                                                            Container(
                                                                              height: 40,
                                                                              width: 40,
                                                                              padding: EdgeInsets.all(10),
                                                                              decoration: BoxDecoration(
                                                                                gradient: LinearGradient(
                                                                                  colors: [
                                                                                    element.type == "bell" ? Colors.red : ConstColors.primaryColor,
                                                                                    element.type == "bell" ? Colors.red.withOpacity(0.7) : ConstColors.primaryColor.withOpacity(0.7),
                                                                                  ],
                                                                                  begin: Alignment.bottomCenter,
                                                                                  end: Alignment.topCenter,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(100),
                                                                              ),
                                                                              child: SvgPicture.asset(
                                                                                element.type == "bell"
                                                                                    ? 'assets/icons/Web and Technology/alarm.svg'
                                                                                    : 'assets/icons/Communication/popup.svg',
                                                                                height: 45,
                                                                                color: ConstColors.whiteFontColor,
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 10),
                                                                            Expanded(
                                                                              child: Text(
                                                                                element.type == "chat" ? "Vous avez un TCHAT" : "Quelqu’un a sonné",
                                                                                style: pSemiBold18.copyWith(fontSize: 16),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      DateTime.now().difference(DateTime.parse("${element.date} ${element.time}")).inMinutes < 1
                                                                          ?
                                                                      Row(
                                                                        children: [
                                                                          CircularCountDownTimer(
                                                                            duration: 60,
                                                                            controller: CountDownController(),
                                                                            initialDuration: (DateTime.now().difference(DateTime.parse("${element.createdAt}"))).inSeconds,
                                                                            //initialDuration: DateTime.now().difference(DateTime.parse("${element.createdAt}")).inSeconds,
                                                                            width: 0,
                                                                            height: 0,
                                                                            ringColor: const Color(0xfff6f6f6),
                                                                            fillColor: const Color(0xfff6f6f6),
                                                                            backgroundColor: const Color(0xfff6f6f6),
                                                                            strokeWidth: 5.0,
                                                                            textStyle: const TextStyle(fontSize: 0.0, color: ConstColors.primaryColor, fontWeight: FontWeight.bold),
                                                                            textFormat: CountdownTextFormat.S,
                                                                            isReverse: false,
                                                                            isReverseAnimation: false,
                                                                            isTimerTextShown: true,
                                                                            autoStart: true,
                                                                            key: Key(element.date),
                                                                            onStart: () {
                                                                              debugPrint('Countdown Started');
                                                                            },
                                                                            onComplete: () async {
                                                                              debugPrint('Countdown Ended');
                                                                              await model.fetchActivities();
                                                                            },
                                                                            onChange: (String timeStamp) {
                                                                              debugPrint('Countdown Changed $timeStamp');
                                                                            },
                                                                            timeFormatterFunction: (defaultFormatterFunction, duration) {
                                                                              if (duration.inSeconds == 0) {
                                                                                return "Start";
                                                                              } else {
                                                                                return Function.apply(defaultFormatterFunction, [duration]);
                                                                              }
                                                                            },
                                                                          ),
                                                                           Text('Répondre',style: pSemiBold18.copyWith(
                                                                              fontSize: 14,
                                                                              color: ConstColors.primaryColoredited))

                                                                        ],
                                                                      )
                                                                          : Text(
                                                                        DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(element.time),
                                                                        ),
                                                                        style: pSemiBold20.copyWith(fontSize: 14, color: ConstColors.primaryColor),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          useStickyGroupSeparators: false,
                                                          floatingHeader: false,
                                                          order: GroupedListOrder.DESC, // Ensure the elements are ordered by group in descending order
                                                        )

                                                    )
                                                  ],
                                                ))
                                            : Container(
                                                width: MediaQuery.of(context).size.width,
                                                decoration: const BoxDecoration(color: Color(0xfff6f6f6), borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                                child: const Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [],
                                                ))),
                  ],
                ))),
      );
    });
  }

  /// this part done by hani linkedIn ==mxfarhan


  List<dynamic> _getRecentActivities(List<dynamic> activities) {
    // Sorting the list for (newest first)
    activities.sort((a, b) => DateTime.parse("${a.date} ${a.time}")
        .compareTo(DateTime.parse("${b.date} ${b.time}")));

    if (activities.length > 6) {
      activities = activities.take(6).toList();
    }

    return activities;
  }

  void _showSuccessDialog() {
    Get.dialog(
      Stack(
        alignment: Alignment.topCenter,
        children: [
          AlertDialog(
            insetPadding: const EdgeInsets.only(left: 40, right: 40),
            titlePadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            content: Container(
              height: 250,
              decoration: const BoxDecoration(
                color: ConstColors.whiteFontColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Acheter la carte HelloHome",
                      style: pSemiBold18.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Vou devez acheter votre carte avnt de pouvoir utiliser HelloHome.",
                    style: pRegular14.copyWith(
                      fontSize: 15,
                      color: ConstColors.text2Color,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PurchaseCardPage(widget.model)));
                    },
                    child: Text(
                      "Commander maintenant",
                      style: pSemiBold18.copyWith(
                        fontSize: 16,
                        color: ConstColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: (Get.width / 2) - 5),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 26,
              child: SvgPicture.asset(
                  'assets/icons/Interface and Sign/lock.svg',
                  height: 20,
                  color: ConstColors.whiteFontColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActions(MainModel model) {
    return Container(
      decoration: BoxDecoration(
        color: ConstColors.primaryColor,
      ),
      height: 120,
      padding: EdgeInsets.only(left: 15, right: 15),
      // padding: EdgeInsets.only(left: 8, right: 5, bottom: 10, top: 46.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "Hello,\n${model.nama}!",
                    style: pSemiBold20.copyWith(
                      fontSize: 24,
                      color: ConstColors.whiteFontColor,
                    ),
                  )),
              const SizedBox(height: 10),
              // Expanded(
              //   child: Row(
              // children: [
              //   SvgPicture.asset(
              //     'assets/icons/Communication/bullhorn.svg',
              //     height: 18,
              //     color: ConstColors.whiteFontColor,
              //   ),
              // const SizedBox(width: 15),
              // Expanded(
              //     child: Text(
              //   model.isLoadingUser ||
              //           model.isLoadingActivity ||
              //           model.isLoadingPurchaseCard ||
              //           _easyLoadingStatus == EasyLoadingStatus.show
              //       ? "..........."
              //       : model.user.roles == "USER" &&
              //               model.purchaseCardList.isEmpty
              //           ? "You need buy a new HelloHome Card"
              //           : model.user.roles == "USER" &&
              //                   model.purchaseCardList.isNotEmpty
              //               ? "Activate your card now, then use all functionality"
              //               : model.user.roles == "OWNER" &&
              //                       model.activityList.isEmpty
              //                   ? "There aren't bell & chat right now"
              //                   : "You've ${model.activityList.where((element) => element.type == "bell").toList().length} bell and ${model.activityList.where((element) => element.type == "chat").toList().length} chat",
              //   style: pSemiBold20.copyWith(
              //     fontSize: 12,
              //     color: ConstColors.whiteFontColor,
              //   ),
              // ))
              //   ],
              // )),
            ],
          )),
          GestureDetector(
              onTap: () async {
              //  model.fetchSubscriptions(model);
                // _showModalBottomSheetActivateCard(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfileView(model)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: ConstColors.whiteFontColor,
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              height: 65,
                              width: 65,
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              imageUrl: model.user.image == null
                                  ? ""
                                  : "${Constant.baseUrl}${Constant.publicAssets}${model.user.image}",
                              placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          ConstColors.primaryColor))),
                              errorWidget: (context, url, error) => Container(
                                    alignment: Alignment.center,
                                    // margin: EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      'assets/icons/Web and Technology/user.svg',
                                      height: 35,
                                      color: ConstColors.primaryColor,
                                    ),
                                    // SizedBox(height: 10),
                                    // Text(
                                    //   "PHOTO NOT FOUND",
                                    //   style: TextStyle(fontSize: 9, color: Colors.grey),
                                    // )
                                  )))),
                  SizedBox(height: 5),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: ConstColors.textColor, width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Web and Technology/cog.svg',
                            height: 11,
                            color: ConstColors.textColor,
                          ),
                          SizedBox(width: 3),
                          Text(
                            "Profile",
                            style: pSemiBold18.copyWith(
                              fontSize: 11,
                              color: ConstColors.textColor,
                            ),
                          ),
                        ],
                      )),
                ],
              ))
        ],
      ),
    );
  }

  static void _showModalBottomSheet(context, dynamic data, MainModel model) {
    showModalBottomSheet(
        backgroundColor: ConstColors.whiteFontColor,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext bc) {
          return FractionallySizedBox(
            heightFactor: model.user.roles == "STAFF" ||
                    model.user.roles == "USER" ||
                    model.user.roles == "OWNER"||
                (model.user.accumulatedExpired ?? 0) == 0
                ? 0.68
                : 0.78,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 7,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)))),
                          SizedBox(height: 20),
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                // color: ConstColors.primaryColor,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.red.withOpacity(0.7),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // begin:
                                  //     Alignment.topLeft, //begin of the gradient color
                                  // end: Alignment
                                  //     .bottomRight, //end of the gradient color
                                  // stops: [0, 0.2, 0.5, 0.8]
                                ),
                                borderRadius: BorderRadius.circular(100)),
                            child: SvgPicture.asset(
                              'assets/icons/Web and Technology/alarm.svg',

                              // height: 10,
                              color: ConstColors.whiteFontColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text('NEW',
                                  style: pRegular14.copyWith(
                                      fontSize: 11,
                                      color: ConstColors.whiteFontColor))),
                          SizedBox(height: 15),
                          Container(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 10, vertical: 4),
                              // decoration: BoxDecoration(
                              // color: Colors.grey[300],
                              // borderRadius: BorderRadius.circular(5)),
                              child: Text("Quelqu'un SONNE",
                                  style: pSemiBold18.copyWith(
                                      fontSize: 14,
                                      color: ConstColors.textColor))),
                        ]),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          var body = {
                            'id_staff': data.usersId,
                            'message': "J'ARRIVE",
                            'idRoomBell': data.roomId,
                            'name': model.nama,
                            'idRoomForChat': data.idRoomForChat
                          };
                          Navigator.of(context).pop();
                          SocketService.sendFeedbackBell(body);
                        },
                        child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                // border:
                                //     Border.all(color: ConstColors.primaryColor),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffA6FF96),
                                    Color(0xffA6FF96).withOpacity(0.7),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // begin:
                                  //     Alignment.topLeft, //begin of the gradient color
                                  // end: Alignment
                                  //     .bottomRight, //end of the gradient color
                                  // stops: [0, 0.2, 0.5, 0.8]
                                ),
                                color: ConstColors.whiteFontColor,
                                borderRadius: BorderRadius.circular(10)),
                            // padding: EdgeInsets.only(
                            //     left: 20, right: 10, top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/Communication/bi-cycle.svg',
                                  // height: 10,
                                  color: ConstColors.whiteFontColor,
                                ),
                                Text(
                                  "J'ARRIVE",
                                  style: pRegular14.copyWith(
                                      fontSize: 14,
                                      color: ConstColors.whiteFontColor),
                                ),
                              ],
                            )),
                      )),
                      SizedBox(width: 20),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          var body = {
                            'id_staff': data.usersId,
                            'message': "JE NE SUIS PAS LA",
                            'idRoomBell': data.roomId,
                            'name': model.nama,
                            'idRoomForChat': data.idRoomForChat
                          };
                          Navigator.of(context).pop();
                          SocketService.sendFeedbackBell(body);
                        },
                        child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                // border:
                                //     Border.all(color: ConstColors.primaryColor),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffE25E3E),
                                    Color(0xffE25E3E).withOpacity(0.7),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // begin:
                                  //     Alignment.topLeft, //begin of the gradient color
                                  // end: Alignment
                                  //     .bottomRight, //end of the gradient color
                                  // stops: [0, 0.2, 0.5, 0.8]
                                ),
                                color: ConstColors.whiteFontColor,
                                borderRadius: BorderRadius.circular(10)),
                            // padding: EdgeInsets.only(
                            //     left: 20, right: 10, top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/Weather/night.svg',
                                  // height: 10,
                                  color: ConstColors.whiteFontColor,
                                ),
                                Text(
                                  "JE NE SUIS PAS LA",
                                  style: pRegular14.copyWith(
                                      fontSize: 14,
                                      color: ConstColors.whiteFontColor),
                                ),
                              ],
                            )),
                      )),
                    ],
                  ),
                  SizedBox(
                      height: model.user.roles == "STAFF" ||
                              model.user.roles == "USER" ||
                              model.user.roles == "OWNER" &&
                                  (model.user.accumulatedExpired ?? 0) == 0
                          ? 20
                          : 40),
                  model.user.roles == "STAFF" ||
                          model.user.roles == "USER" ||
                          model.user.roles == "OWNER" &&
                              (model.user.accumulatedExpired ?? 0) == 0
                      ? SizedBox()
                      : InkWell(
                          onTap: () {
                            var body = {
                              'id_staff': data.usersId,
                              'message': "CHAT",
                              'idRoomBell': data.roomId,
                              'name': model.nama,
                              'idRoomForChat': data.idRoomForChat
                            };
                            Navigator.of(context).pop();
                            SocketService.sendFeedbackBell(body);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => ChatPage(
                                        model,
                                        Activity(
                                            usersId: data.usersId,
                                            roomId: data.idRoomForChat,
                                            idRoomForChat: data.roomId))));
                          },
                          child: Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: ConstColors.primaryColor),
                              color: ConstColors.whiteFontColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/Communication/popup.svg',
                                  height: 30,
                                  // color: Colors.white54,
                                  color: ConstColors.primaryColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "ECRIRE AU VISITEUR",
                                  style: pSemiBold18.copyWith(
                                    fontSize: 16,
                                    color: ConstColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildPlaceholderBuyCard(MainModel model) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 122.37,
              width: 125,
              child: SvgPicture.asset(
                DefaultImages.paymentMethod,
                fit: BoxFit.fill,
                color: ConstColors.text2Color,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Je n'ai aucune carte",
                style: pSemiBold20.copyWith(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "Tu n'en as pas encore Carte HelloHome.\nAchetez maintenant pour accéder à toutes les fonctionnalités",
                style: pRegular14.copyWith(
                  fontSize: 16,
                  height: 1.5,
                  color: ConstColors.text2Color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PurchaseCardPage(model)));
                // Get.to(
                //   const AddCardScreen(),
                //   transition: Transition.rightToLeft,
                // );
              },
              child: Container(
                height: 40,
                width: Get.width/1.2 ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ConstColors.primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    "ACHETER LA CARTE MAINTENANT",
                    style: pSemiBold18.copyWith(
                      fontSize: 13,
                      color: ConstColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildPlaceholderActivateCard(MainModel model) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 122.37,
              width: 125,
              child: SvgPicture.asset(
                DefaultImages.paymentMethod,
                fit: BoxFit.fill,
                color: ConstColors.text2Color,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Vous devez activer une carte",
                style: pSemiBold20.copyWith(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Il semble que vous ayez une carte\nmais qu’une activation soit nécessaire.\nActivez votre carte pour utiliser la fonctionnalité.",
                    style: pRegular14.copyWith(
                      fontSize: 16,
                      height: 1.5,
                      color: ConstColors.text2Color,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfileView(model)));
                // Get.to(
                //   const AddCardScreen(),
                //   transition: Transition.rightToLeft,
                // );
              },
              child: Container(
                height: 40,
                width: Get.width / 1.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ConstColors.primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    "ACTIVER LA CARTE MAINTENANT",
                    style: pSemiBold18.copyWith(
                      fontSize: 13,
                      color: ConstColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
