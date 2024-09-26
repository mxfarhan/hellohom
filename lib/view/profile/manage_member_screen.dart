import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly/config/constant.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:foodly/config/default_image.dart';
import 'package:foodly/widget/easy_faq.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';

import '../../services/main_model.dart';

class ManageMemberScreen extends StatefulWidget {
  final MainModel model;

  ManageMemberScreen(this.model);

  @override
  State<ManageMemberScreen> createState() => _ManageMemberScreenState();
}

class _ManageMemberScreenState extends State<ManageMemberScreen> {
  var _emailController = TextEditingController();

  Timer? _timer;
  var _isSubmitted = false;

  EasyLoadingStatus? _easyLoadingStatus;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      setState(() {
        _easyLoadingStatus = status;
      });
    });
    //
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var responseData = await widget.model.fetchAllMembers();
      if (responseData.statusCode == 200) {
        print("Response all members: $responseData");

        _timer?.cancel();
        await EasyLoading.dismiss();
      } else {
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
    } catch (e) {
      _timer?.cancel();
      await EasyLoading.dismiss();
    }
  }

  Future _addMemberByEmail(MainModel model) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var data = {
        'name': _emailController.text,
        'email': _emailController.text,
        'email_verified_at': DateTime.now().toString(),
        'ownership_id': model.uid,
        'phone': model.user.phone,
        'city': model.user.city,
        'zip_code': model.user.zipCode,
        'address': model.user.address,
        'roles': 'STAFF'
      };

      var responseData = await model.addMemberByEmail(data);
      if (responseData["message"] == "true") {
        print("Response add member by email new user: $responseData");
        //

        var responseGetMembers = await widget.model.fetchAllMembers();
        if (responseGetMembers.statusCode == 200) {
          print("Response all members: $responseData");

          _timer?.cancel();
          await EasyLoading.dismiss();
          //
          var emailMember = _emailController.text;
          _showSuccessDialog(emailMember);
          //
          _emailController.clear();
          //
        } else {
          _timer?.cancel();
          await EasyLoading.dismiss();
        }
      } else if (responseData['message'] == false) {
        print("Response add member by email already exist: $responseData");
        //

        var responseGetMembers = await widget.model.fetchAllMembers();
        if (responseGetMembers.statusCode == 200) {
          print("Response all members: $responseData");

          _timer?.cancel();
          await EasyLoading.dismiss();
          //
          var emailMember = _emailController.text;
          _showSuccessDialog(emailMember);
          //
          _emailController.clear();
          //
        } else {
          _timer?.cancel();
          await EasyLoading.dismiss();
        }
      } else {
        print("Unathorized");
        //
        _emailController.clear();
        //
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              responseData['error'],
              style: TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
    } catch (e) {
      //
      _emailController.clear();
      //
      _timer?.cancel();
      await EasyLoading.dismiss();
      //
      print("Unathorized");
    }
  }

  @override
  void dispose() {
    super.dispose();

    EasyLoading.removeAllCallbacks();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        backgroundColor: ConstColors.whiteFontColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: ConstColors.textColor,
              size: 20,
            ),
          ),
          title: Text(
            "Manage Members",
            style: pSemiBold20.copyWith(),
          ),
        ),
        body: model.isLoadingMember ||
                _easyLoadingStatus == EasyLoadingStatus.show
            ? const SizedBox()
            : _easyLoadingStatus == EasyLoadingStatus.dismiss &&
                    !model.isLoadingMember &&
                    !model.isLoadingMember &&
                    model.allMembers.length == 0
                ? _buildPlaceholderMember(model)
                : _easyLoadingStatus == EasyLoadingStatus.dismiss &&
                        !model.isLoadingMember
                    ? Column(
                        children: [
                          Expanded(
                              child: GroupedListView<dynamic, String>(
                            elements: model.allMembers,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            groupBy: (element) =>
                                element.staff.roles == 'STAFF' &&
                                        element.staff.ownershipId.toString() ==
                                            model.uid.toString()
                                    ? "Mes membres"
                                    : "Tous",
                            groupSeparatorBuilder: (String groupByValue) =>
                                Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              // color: Colors.green,
                              height: 30,
                              child: Row(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            color: ConstColors.text2Color),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                      child: Container(
                                    height: 1,
                                    color: Colors.grey[200],
                                  ))
                                ],
                              ),
                            ),
                            itemBuilder: (context, dynamic element) =>
                                Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CachedNetworkImage(
                                                    height: 40,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    fit: BoxFit.cover,
                                                    imageUrl: element.staff.image ==
                                                                null ||
                                                            element.staff.image ==
                                                                ""
                                                        ? ""
                                                        : "${Constant.baseUrl}${Constant.publicAssets}${element.staff.image}",
                                                    placeholder: (context, url) => Center(
                                                        child: CircularProgressIndicator(
                                                            valueColor: AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.white))),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          // margin: EdgeInsets.all(8),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/Web and Technology/user.svg',
                                                            height: 40,
                                                            color: ConstColors
                                                                .primaryColor,
                                                          ),
                                                        ))),
                                            SizedBox(width: 10),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${element.staff.name}",
                                                    style: pSemiBold18.copyWith(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    "${element.staff.city}",
                                                    style: pRegular14.copyWith(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                            onTap: () async {
                                              _timer?.cancel();
                                              await EasyLoading.show(
                                                  maskType: EasyLoadingMaskType
                                                      .custom);

                                              try {
                                                var response = await model
                                                    .addOrRemoveMember(
                                                        element.id);

                                                if (response['data'] != null) {
                                                  var responseData = await model
                                                      .fetchAllMembers();
                                                  if (responseData.statusCode ==
                                                      200) {
                                                    //
                                                    _timer?.cancel();
                                                    await EasyLoading.dismiss();
                                                  } else {
                                                    //
                                                    _timer?.cancel();
                                                    await EasyLoading.dismiss();
                                                  }
                                                } else {
                                                  //
                                                  _timer?.cancel();
                                                  await EasyLoading.dismiss();
                                                }
                                              } catch (e) {
                                                print("e: $e");
                                              }
                                            },
                                            child: Container(
                                              child: SvgPicture.asset(
                                                  'assets/icons/Web and Technology/trash-can.svg',
                                                  height: 30,
                                                  color: Colors.red),
                                            )),
                                      ]),
                                  SizedBox(height: 12),
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    height: 1,
                                    color: Colors.grey[200],
                                  )
                                ],
                              ),
                            ),

                            // itemComparator: (item1,
                            //         item2) =>
                            //     item1.room_id.compareTo(item2
                            //         .room_id), // optional
                            useStickyGroupSeparators: false, // optional
                            floatingHeader: false, // optional
                            order: GroupedListOrder.DESC, // optional
                          )),
                          InkWell(
                            onTap: () async {
                              _showModalBottomSheetAddMember(context, model);
                            },
                            child: Container(
                              margin: EdgeInsets.all(20),
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
                                    'assets/icons/Web and Technology/users.svg',
                                    height: 30,
                                    color: ConstColors.primaryColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Add Member",
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
                      )
                    : SizedBox(),
      );
    });
  }

  void _showModalBottomSheetAddMember(context, MainModel model) {
    showModalBottomSheet(
        backgroundColor: ConstColors.whiteFontColor,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext bc) {
          return Container(
            padding: MediaQuery.of(context).viewInsets,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                    child: Text("Entrez votre email de membre",
                        style: pSemiBold18.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ConstColors.textColor))),
                SizedBox(height: 30),
                Container(
                  child: Row(children: [
                    Expanded(
                        child: Container(
                            height: 40,
                            child: TextField(
                              autocorrect: false,
                              autofocus: false,
                              controller: _emailController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  contentPadding: EdgeInsets.all(0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ConstColors.primaryColor,
                                          width: 2))),
                            ))),
                    SizedBox(width: 10),
                    Container(
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _addMemberByEmail(model);
                            },
                            style: ButtonStyle(
                                // padding: MaterialStateProperty.all<EdgeInsets>(
                                //     EdgeInsets.all(15)),
                                // foregroundColor:
                                //     MaterialStateProperty.all<Color>(Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              // side: BorderSide(color: Colors.red)
                            ))),
                            child: Text("ADD")))
                  ]),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  void _showSuccessDialog(String emailMember) {
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
              height: 300,
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
                      "Successfully Adding Member",
                      style: pSemiBold18.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "An email has been sent to your member at $emailMember. Member can login using the account sent",
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
                    },
                    child: Text(
                      "CLOSE",
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
            padding: EdgeInsets.only(top: (Get.width / 2) - 15),
            child: const CircleAvatar(
              backgroundColor: ConstColors.primaryColor,
              radius: 26,
              child: Icon(
                Icons.check,
                color: ConstColors.whiteFontColor,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaceholderMember(MainModel model) {
    return Container(
        decoration: BoxDecoration(
            color: ConstColors.whiteFontColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 122.37,
                  width: 125,
                  child: SvgPicture.asset(
                    'assets/icons/Web and Technology/users.svg',
                    fit: BoxFit.fill,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Vous n'avez aucun membre",
                    textAlign: TextAlign.center,
                    style: pSemiBold20.copyWith(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    "Il semble que vous n’ayez\naucun membre.",
                    style: pRegular14.copyWith(
                      fontSize: 16,
                      height: 1.5,
                      color: ConstColors.text2Color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )),
            InkWell(
              onTap: () async {
                _showModalBottomSheetAddMember(context, model);
              },
              child: Container(
                margin: EdgeInsets.all(20),
                height: 48,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: ConstColors.primaryColor),
                  color: ConstColors.whiteFontColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Web and Technology/users.svg',
                      height: 30,
                      color: ConstColors.primaryColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Add Member",
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
        ));
  }
}
