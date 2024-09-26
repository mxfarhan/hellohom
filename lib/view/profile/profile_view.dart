import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:foodly/config/colors.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodly/config/default_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/view/auth/signin_screen.dart';
import 'package:foodly/view/auth/signup_screen.dart';
import 'package:foodly/view/profile/change_language_screen.dart';
import 'package:foodly/view/profile/faq_screen.dart';
import 'package:foodly/view/profile/manage_member_screen.dart';
import 'package:foodly/view/purchase_card_page.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'package:foodly/controller/profile_controller.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:foodly/services/main_model.dart';
import 'package:foodly/view/profile/change_password_screen.dart';
import 'package:foodly/view/profile/profile_setting_screen.dart';
import 'package:foodly/view/profile/subscription_plan_screen.dart';
import 'package:foodly/widget/profile_tab.dart';
import 'package:get/get.dart';

import '../onboarding_screen.dart';

class ProfileView extends StatefulWidget {
  final MainModel model;
  ProfileView(this.model);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Timer? _timer;
  var _cardCodeController = TextEditingController();
  EasyLoadingStatus? _easyLoadingStatus;

  @override
  void initState() {
    super.initState();

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      setState(() {
        _easyLoadingStatus = status;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.removeAllCallbacks();
  }

  Future _activateCard(MainModel model) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var data = {'card_code': _cardCodeController.text, 'users_id': model.uid};

      var responseData = await model.activateCard(data);
      if (responseData["message"] == "Valid") {
        if (kDebugMode) {
          print("Response activate card response: $responseData");
        }
        //
        var formData = {
          'name': model.nama,
          'email': model.email,
          'roles': 'OWNER',
          // 'ownership_id': model.uid
        };

        var responseEditProfile = await model.editProfile(formData);
        if (responseEditProfile["data"] != null) {
          print("Response edit profile: $responseEditProfile");
          //
          //
          _timer?.cancel();
          await EasyLoading.dismiss();
          //
          var serialCard = _cardCodeController.text;
          _showSuccessDialog(serialCard);
          //
          _cardCodeController.clear();
        }
      } else {
        print("Unathorized");
        //
        _cardCodeController.clear();
        //
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              responseData['message'],
              style: TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
    } catch (e) {
      //
      _cardCodeController.clear();
      //
      _timer?.cancel();
      await EasyLoading.dismiss();
      //
      print("Unathorized");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
          body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 25, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: ConstColors.textColor,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Text(
                    "Mon compte",
                    style: pSemiBold20.copyWith(
                      fontSize: 28,
                    ),
                  )
                ],
              ),
              // Text(
              //   "Update your settings like notifications,\npayments, profile edit etc.",
              //   style: pRegular14.copyWith(
              //     fontSize: 16,
              //     height: 1.5,
              //     color: ConstColors.text2Color,
              //   ),
              // ),
              const SizedBox(height: 10),
              model.isLoadingUser ||
                      _easyLoadingStatus == EasyLoadingStatus.show
                  ? const SizedBox()
                  : Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileTab(
                                image:
                                    'assets/icons/Web and Technology/user.svg',
                                title: "Information",
                                subTitle: "Modifier le profil",
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ProfileSettingScreen(model)));

                                  // transition: Transition.rightToLeft,
                                },
                              ),
                              ProfileTab(
                                image:
                                    'assets/icons/Interface and Sign/lock-alt.svg',
                                title: "Changement du mot de\npasse",
                                subTitle: "",
                                ontap: () {
                                  Get.to(
                                    const ChangePasswordScreen(),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                              ),
                              ProfileTab(
                                image: 'assets/images/deluser.svg',
                                title: "Delete Account",
                                subTitle: "",
                                ontap: () {
                                  // Show iOS-style dialog to confirm or cancel deletion
                                  Get.dialog(
                                    CupertinoAlertDialog(
                                      title: Text("Confirm Deletion"),
                                      content: Text("Are you sure! you want to delete your account?"),
                                      actions: [
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          onPressed: () {

                                            // Close the dialog and cancel deletion
                                            Get.back();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        CupertinoDialogAction(
                                          isDestructiveAction: true,
                                          onPressed: () {
                                            // Proceed with deletion and close the dialog
                                            model.deleteUserAccount(model.uid);
                                            Get.back();
                                              _timer?.cancel();
                                               EasyLoading.show(
                                                  maskType: EasyLoadingMaskType.custom);

                                               model.logOut().then((_) async {
                                                model.clearUser();
                                                model.clearProducts();
                                                model.clearMyPurchaseCards();
                                                model.clearActivities();
                                                //
                                                model.removeFcmToken(context);

                                                Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    "/onboard",
                                                        (Route<dynamic> route) => false);
                                              }

                                              );
                                              //
                                              _timer?.cancel();
                                               EasyLoading.dismiss();


                                            // Show a snackbar confirming deletion
                                            Get.closeCurrentSnackbar();
                                            Get.snackbar(
                                              "Deleted",
                                              "Your account has been deleted",
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: ConstColors.primaryColor.withOpacity(0.6),
                                              colorText: Colors.black,
                                              borderRadius: 10,
                                              margin: EdgeInsets.all(14),
                                              duration: Duration(seconds: 2),
                                            );

                                            // Optionally navigate to the login page after deletion
                                           // model.logOut();
                                           // Get.offAll(() => SignInScreen(model));
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    ),
                                    barrierDismissible: false, // Prevent dialog from closing by tapping outside
                                  );
                                },
                              ),

                              // ProfileTab(
                              //   image: DefaultImages.payment,
                              //   title: "Payment Methods",
                              //   subTitle: "Add your credit & debit cards",
                              //   ontap: () {
                              //     Get.to(
                              //       const PaymentMethodScreen(),
                              //       transition: Transition.rightToLeft,
                              //     );
                              //   },
                              // ),
                              // ProfileTab(
                              //   image: DefaultImages.marker,
                              //   title: "Locations",
                              //   subTitle: "Add or remove your delivery locations",
                              //   ontap: () {
                              //     Get.to(
                              //       const AddLoacationScreen(),
                              //       transition: Transition.rightToLeft,
                              //     );
                              //   },
                              // ),
                              // ProfileTab(
                              //   image: DefaultImages.profileFacebook,
                              //   title: "Add Social Account",
                              //   subTitle: "Add Facebook, Twitter etc",
                              //   ontap: () {
                              //     Get.to(
                              //       const AddSocialAccountScreen(),
                              //       transition: Transition.rightToLeft,
                              //     );
                              //   },
                              // ),
                              // ProfileTab(
                              //   image: DefaultImages.share,
                              //   title: "Refer to Friends",
                              //   subTitle: "Get \$10 for reffering friends",
                              //   ontap: () {
                              //     Get.to(
                              //       const ReferFriendScreen(),
                              //       transition: Transition.rightToLeft,
                              //     );
                              //   },
                              // ),
                              SizedBox(
                                  height: model.user.roles == "STAFF" ? 0 : 20),
                              model.user.roles == "STAFF"
                                  ? const SizedBox()
                                  : Text(
                                      model.user.roles == "USER" &&
                                              model.purchaseCardList.isEmpty
                                          ? "BUY A NEW CARD"
                                          : model.user.roles == "USER" &&
                                                  model.purchaseCardList
                                                      .isNotEmpty
                                              ? "ACTIVATE YOUR CARD"
                                              : model.user.roles == "OWNER" &&
                                                      model.subscriptionList
                                                          .isEmpty
                                                  ? "SUBSCRIBE A PLAN"
                                                  : "GESTION",
                                      style: pSemiBold20.copyWith(
                                        fontSize: 16,
                                        color: ConstColors.text2Color,
                                      ),
                                    ),
                              SizedBox(
                                  height: model.user.roles == "STAFF" ||
                                          model.user.roles == "USER" ||
                                          model.user.roles == "OWNER" &&
                                              model.user.jumlahHariExpired! == 0
                                      ? 0
                                      : 12),
                              model.user.roles == "STAFF" ||
                                      model.user.roles == "USER" ||
                                      model.user.roles == "OWNER" &&
                                          model.user.jumlahHariExpired! == 0
                                  ? const SizedBox()
                                  : ProfileTab(
                                      image:
                                          'assets/icons/Web and Technology/users.svg',
                                      title: "Mes Membres",
                                      subTitle: "Ajouter - Retirer vos membres",
                                      ontap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    ManageMemberScreen(model)));
                                      },
                                    ),
                              SizedBox(
                                  height: model.user.roles == "STAFF" ||
                                          model.user.roles == "USER"
                                      ? 0
                                      : 12),
                              model.user.roles == "STAFF" ||
                                      model.user.roles == "USER"
                                  ? const SizedBox()
                                  : ProfileTab(
                                      image: 'assets/icons/Personal/crown.svg',
                                      title: "Mon Abonnement",
                                      subTitle: "Gérez vos abonnements",
                                      ontap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        SubscriptionPlanScreen(
                                                            model)));
                                        // Get.to(
                                        //   SubscriptionPlanScreen(model),
                                        //   transition: Transition.rightToLeft,
                                        // );
                                      },
                                    ),

                              SizedBox(
                                  height: model.user.roles == "STAFF" ||
                                          model.user.roles == "USER" &&
                                              model.purchaseCardList.isEmpty ||
                                          model.user.roles == "OWNER"
                                      ? 0
                                      : 12),
                              model.user.roles == "STAFF" ||
                                      model.user.roles == "USER" &&
                                          model.purchaseCardList.isEmpty ||
                                      model.user.roles == "OWNER"
                                  ? const SizedBox()
                                  : ProfileTab(
                                      image:
                                          'assets/icons/Interface and Sign/unlock.svg',
                                      title: "Activer la carte maintenant!",
                                      subTitle:
                                          "utiliser toutes les fonctionnalités",
                                      ontap: () {
                                        _showModalBottomSheetActivateCard(
                                            context, model);
                                      },
                                    ),
                              SizedBox(
                                  height: model.user.roles == "STAFF" ? 0 : 12),
                              model.user.roles == "STAFF"
                                  ? const SizedBox()
                                  : ProfileTab(
                                      image:
                                          'assets/icons/Communication/postcard.svg',
                                      title: model.user.roles == "USER" &&
                                              model.purchaseCardList.isEmpty
                                          ? "Buy HelloHome Card"
                                          : "Ma Carte HelloHome",
                                      subTitle: "Profitez bien!",
                                      ontap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    PurchaseCardPage(model)));
                                        // Get.to(
                                        //   PurchaseCardPage(model),
                                        //   transition: Transition.rightToLeft,
                                        // );
                                      },
                                    ),

                              // const SizedBox(height: 20),
                              // Text(
                              //   "NOTIFICATIONS",
                              //   style: pSemiBold20.copyWith(
                              //     fontSize: 16,
                              //     color: ConstColors.text2Color,
                              //   ),
                              // ),
                              // const SizedBox(height: 12),
                              // NotificationTab(
                              //   widget: CupertinoSwitch(
                              //     onChanged: (value) {
                              //       setState(() {
                              //         profileController.isPush.value = value;
                              //       });
                              //     },
                              //     activeColor: ConstColors.primaryColor,
                              //     value: profileController.isPush.value,
                              //   ),
                              //   subTitle: "",
                              //   title: "Push Notifications",
                              //   ontap: () {},
                              // ),
                              // // NotificationTab(
                              // //   widget: CupertinoSwitch(
                              // //     onChanged: (value) {
                              // //       setState(() {
                              // //         profileController.isnotify.value = value;
                              // //       });
                              // //     },
                              // //     activeColor: ConstColors.primaryColor,
                              // //     value: profileController.isnotify.value,
                              // //   ),
                              // //   subTitle: "For daily update you will get it",
                              // //   title: "SMS Notifications",
                              // //   ontap: () {},
                              // // ),
                              // NotificationTab(
                              //   widget: CupertinoSwitch(
                              //     onChanged: (value) {
                              //       setState(() {
                              //         profileController.isPro.value = value;
                              //       });
                              //     },
                              //     activeColor: ConstColors.primaryColor,
                              //     value: profileController.isPro.value,
                              //   ),
                              //   subTitle: "Stay update for promotional",
                              //   title: "Promo Notifications",
                              //   ontap: () {},
                              // ),
                              const SizedBox(height: 20),
                              Text(
                                "MORE",
                                style: pSemiBold20.copyWith(
                                  fontSize: 16,
                                  color: ConstColors.text2Color,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // ProfileTab(
                              //   image: 'assets/icons/Education/world-alt.svg',
                              //   title: "LANGUAGE",
                              //   subTitle: "Change Language",
                              //   ontap: () {
                              //     Get.to(ChangeLanguageScreen(),
                              //         transition: Transition.rightToLeft);
                              //     // Navigator.push(
                              //     //     context,
                              //     //     MaterialPageRoute(
                              //     //         builder: (BuildContext context) =>
                              //     //             ChangeLanguageScreen()));
                              //   },
                              // ),
                              ProfileTab(
                                image: 'assets/icons/Business/notepad.svg',
                                title: "FAQ",
                                subTitle: "Frequently asked questions",
                                ontap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FAQscreen()));
                                },
                              ),
                              ProfileTab(
                                image: 'assets/icons/Direction/exit.svg',
                                title: "Logout",
                                subTitle: "",
                                ontap: () async {
                                  _timer?.cancel();
                                  await EasyLoading.show(
                                      maskType: EasyLoadingMaskType.custom);

                                  await model.logOut().then((_) async {
                                    model.clearUser();
                                    model.clearProducts();
                                    model.clearMyPurchaseCards();
                                    model.clearActivities();
                                    //
                                    model.removeFcmToken(context);

                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        "/onboard",
                                        (Route<dynamic> route) => false);
                                  });
                                  //
                                  _timer?.cancel();
                                  await EasyLoading.dismiss();
                                },
                              ),
                              const SizedBox(height: 100),
                            ],
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
      ));
    });
  }

  void _showModalBottomSheetActivateCard(context, MainModel model) {
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
                    child: Text("Already have card? Let's activate it",
                        style: pSemiBold18.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ConstColors.textColor))),
                SizedBox(height: 30),
                Container(
                    child: Image.asset(
                  'assets/images/hellohome_card.png',
                  height: 200,
                  fit: BoxFit.contain,
                )),
                SizedBox(height: 20),
                Container(
                  child: Row(children: [
                    Expanded(
                        child: Container(
                            height: 40,
                            child: TextField(
                              autocorrect: false,
                              autofocus: false,
                              controller: _cardCodeController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  hintText: "XXXX-XXXX-XXXX",
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
                              await _activateCard(model);
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
                            child: Text("ACTIVATE")))
                  ]),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  void _showSuccessDialog(String cardCode) {
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
                      "You Successfully Activate Card",
                      style: pSemiBold18.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Your Card successfully activate with $cardCode serial. You'll get all feature access in HelloHome application. Thanks for using HelloHome",
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
            padding: EdgeInsets.only(top: (Get.width / 2) - 3),
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
}
