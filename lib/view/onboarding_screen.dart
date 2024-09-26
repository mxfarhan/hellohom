import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/default_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'package:foodly/config/text_style.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:foodly/services/main_model.dart';
import 'package:foodly/view/auth/forgot_password_screen.dart';
import 'package:foodly/view/auth/signin_screen.dart';
import 'package:foodly/view/auth/signup_screen.dart';
import 'package:foodly/view/chats/chat_text_input.dart';
import 'package:foodly/view/search/search_view.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  final MainModel model;
  OnboardingScreen(this.model);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _debugLabelString = "";
  String? _emailAddress;
  String? _smsNumber;
  String? _externalUserId;
  String? _language;
  bool _enableConsentButton = false;
  String _token = "";
  Timer? _timer;
  var _cardCodeController = TextEditingController();
  EasyLoadingStatus? _easyLoadingStatus;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = true;

  startTime() async {
    return Timer(
        Duration(seconds: 2),
        () => {
              // if (_token == null)
              //   {Navigator.of(context).pushReplacementNamed('/login')}
              if (_token != "")
                {Navigator.of(context).pushReplacementNamed('/home')}
              // else
              //   {Navigator.of(context).pushReplacementNamed('/home')}
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //
    widget.model.checkUid().then((data) {
      setState(() {
        _token = data['token'];
        // _phone = data['phone'];
      });
      debugPrint("Token onboard: $_token");

      startTime();
    });
  }

  // void completeOnboarding() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isOnboarded', true);
  //   Navigator.pushReplacementNamed(context, '/home');
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        backgroundColor: ConstColors.whiteFontColor,
        // appBar: AppBar(
        //   centerTitle: true,
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   leading: InkWell(
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     child: const Icon(
        //       Icons.arrow_back_ios,
        //       color: ConstColors.textColor,
        //       size: 20,
        //     ),
        //   ),
        //   title: Text(
        //     "Sign in",
        //     style: pSemiBold20.copyWith(
        //       fontSize: 16,
        //     ),
        //   ),
        // ),
        body: SafeArea(
            child: Container(
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage('assets/images/cropped-bkg.png'))),
                child: Column(
          // physics: const ClampingScrollPhysics(),
          // padding: EdgeInsets.zero,
          children: [
            Expanded(
                flex: 4,
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        // BoxShadow(
                        //   color: Colors.grey.withOpacity(0.5),
                        //   spreadRadius: 2,
                        //   blurRadius: 7,
                        //   offset: Offset(2, 1), // changes position of shadow
                        // ),
                      ],
                    ),
                    child: Image.asset('assets/images/cropped-bkg.png'))),

            if (_token == '') // Check if _token is empty
            Expanded(
                flex: 2,
                child: Container(
                    margin: EdgeInsets.only(left: 25, right: 25, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Un interphone digital pour vos visiteurs\nToujours connecté - Pas d'installation - sans application à télécharger",
                              style: pRegular14.copyWith(
                                height: 1.6,
                                fontSize: 14,
                                color: ConstColors.text2Color,
                              ),
                            )),
                        // SizedBox(height: 20),

                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: CusttomButton(
                                  color: ConstColors.primaryColor,
                                  text: "Activer votre carte!",
                                  onTap: () {
                                    _showModalBottomSheetActivateCard(
                                        context, model);
                                  },
                                )),
                            SizedBox(height: 5),
                              TextButton(
                                child: Text(
                                  "Go to HelloHome",
                                  style: pRegular14.copyWith(
                                    fontSize: 16,
                                    color: ConstColors.primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  // Navigate to SignInScreen
                                  Get.to(
                                    SignInScreen(model),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                              ),
                          ],
                        )
                      ],
                    )))
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Welcome to",
            //         style: pSemiBold18.copyWith(
            //           fontSize: 34,
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       Text(
            //         "Enter your Phone number or Email",
            //         style: pRegular14.copyWith(
            //           fontSize: 16,
            //           color: ConstColors.text2Color,
            //         ),
            //       ),
            //       const SizedBox(height: 5),
            //       Row(
            //         children: [
            //           Text(
            //             "for sign in, Or ",
            //             style: pRegular14.copyWith(
            //               fontSize: 16,
            //               color: ConstColors.text2Color,
            //             ),
            //           ),
            //           InkWell(
            //             onTap: () {
            //               Get.to(
            //                 const SignUpScreen(),
            //                 transition: Transition.rightToLeft,
            //               );
            //             },
            //             child: Text(
            //               "Create new account.",
            //               style: pRegular14.copyWith(
            //                 fontSize: 16,
            //                 color: ConstColors.primaryColor,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 20),
            //       CustomTextField(
            //         controller: TextEditingController(),
            //         hintText: "Email",
            //         inputType: TextInputType.emailAddress,
            //         obscureText: false,
            //         image: DefaultImages.phone,
            //         labelText: "EMAIL",
            //       ),
            //       const SizedBox(height: 14),
            //       CustomTextField(
            //         controller: TextEditingController(),
            //         hintText: "Password",
            //         inputType: TextInputType.visiblePassword,
            //         obscureText: true,
            //         image: DefaultImages.eye,
            //         labelText: "PASSWORD",
            //       ),
            //       const SizedBox(height: 45),
            //       // const SizedBox(height: 14),
            //       InkWell(
            //         onTap: () {
            //           Get.to(
            //             const ForgotPasswordScreen(),
            //             transition: Transition.rightToLeft,
            //           );
            //         },
            //         child: Container(
            //           alignment: Alignment.centerRight,
            //           child: Text(
            //             "Forget Password?",
            //             style: pSemiBold18.copyWith(
            //               fontSize: 14,
            //               color: ConstColors.textColor.withOpacity(0.64),
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 30),
            //       // const SizedBox(height: 14),
            //       CusttomButton(
            //         color: ConstColors.primaryColor,
            //         text: "SIGN IN",
            //         onTap: () {
            //           Get.offAll(
            //             const TabScreen(),
            //             transition: Transition.rightToLeft,
            //           );
            //         },
            //       ),
            //       const SizedBox(height: 16),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             "Don’t have account? ",
            //             style: pRegular14.copyWith(
            //               color: ConstColors.text2Color,
            //             ),
            //           ),
            //           InkWell(
            //             onTap: () {
            //               Get.to(
            //                 const SignUpScreen(),
            //                 transition: Transition.rightToLeft,
            //               );
            //             },
            //             child: Text(
            //               "Create new account.",
            //               style: pRegular14.copyWith(
            //                 color: ConstColors.primaryColor,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            // const SizedBox(height: 16),
            // Center(
            //   child: Text(
            //     "Or",
            //     style: pSemiBold18.copyWith(
            //       fontSize: 16,
            //       color: ConstColors.textColor.withOpacity(0.64),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            // SocialButton(
            //   color: const Color(0xff395998),
            //   image: DefaultImages.facebook,
            //   onTap: () {},
            //   text: "Connect with Facebook",
            // ),
            // const SizedBox(height: 16),
            // SocialButton(
            //   color: const Color(0xff4285F4),
            //   image: DefaultImages.google,
            //   onTap: () {},
            //   text: "Connect with google",
            // ),
            // const SizedBox(height: 30),
            //     ],
            //   ),
            // ),
          ],
        ))),
      );
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
                    child: Text(
                        "Vous avez déjà votre carte ? Activez-là maintenant.",
                        textAlign: TextAlign.center,
                        style: pSemiBold18.copyWith(
                            fontSize: 18,
                            height: 1.2,
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
                              await _checkingCardCode(model);
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
                            child: Text("ACTIVER")))
                  ]),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  Future _checkingCardCode(MainModel model) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var responseData = await model.checkCardCode(_cardCodeController.text);
      if (responseData["message"]) {
        debugPrint("Response activate card response: $responseData");

        _timer?.cancel();
        await EasyLoading.dismiss();
        //
        Get.to(SignUpScreen("Check Card Code"),
            transition: Transition.rightToLeft);
        //
        var serialCard = _cardCodeController.text;
        _showSuccessDialog(serialCard);
        //
        _cardCodeController.clear();
        // }
      } else {
        debugPrint("Unathorized");
        //
        _cardCodeController.clear();
        //
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Your Card code are invalid. please try again",
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
      debugPrint("Unathorized");
    }
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
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Let's signup your Account",
                      style: pSemiBold18.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Your Card successfully confirmed with $cardCode serial. You'll get all feature access in HelloHome application.",
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
            padding: EdgeInsets.only(top: (Get.width / 2) - 20),
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
