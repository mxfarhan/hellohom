import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodly/view/auth/verify_mobile_screen.dart';
import 'package:foodly/view/chats/chat_text_input.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:foodly/config/default_image.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/view/auth/forgot_password_screen.dart';
import 'package:foodly/view/auth/signup_screen.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../services/main_model.dart';

class SignInScreen extends StatefulWidget {
  final MainModel model;
  SignInScreen(this.model);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _emailController = TextEditingController();
  var _passController = TextEditingController();

  Timer? _timer;
  bool _isSubmitted = false, _obscureText = false;

  @override
  void initState() {
    super.initState();
    //
    widget.model.getDIDfcmToken(context);
    _obscureText = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //
    _emailController.clear();
    _passController.clear();
  }

  Future _validateAndSubmit(MainModel model) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var data = {
        'email': _emailController.text,
        'password': _passController.text,
        'fcm': model.fcmToken
      };

      var responseData = await model.signIn(data);
      debugPrint("token: ${responseData["token"]}");
      if (responseData["token"].isNotEmpty) {
        debugPrint("Response login: $responseData");

        if (responseData["email_verified_at"] == "" ||
            responseData["email_verified_at"] == null) {
          var responseOTP = await model.sendOTPemail(responseData);

          if (responseOTP['otp'] != null) {
            //
            _timer?.cancel();
            await EasyLoading.dismiss();
            //
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    VerifyMobileScreen(responseData, responseOTP)));
          }
        } else {
          //
          _timer?.cancel();
          await EasyLoading.dismiss();
          //
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        }

        //
        setState(() => _isSubmitted = false);
        //
        _passController.clear();
        _emailController.clear();
      } else {
        debugPrint("Unathorized");
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              model.message,
              style: TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        setState(() => _isSubmitted = false);
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
      // });
    } catch (e) {
      //
      setState(() => _isSubmitted = false);
      _timer?.cancel();
      await EasyLoading.dismiss();
      Get.closeCurrentSnackbar();
      Get.snackbar(
        "Sign In Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ConstColors.primaryColor.withOpacity(0.6),
        colorText: Colors.black,
        borderRadius: 10,
        margin: EdgeInsets.all(14),
        duration: Duration(seconds: 2),
      );
      debugPrint("Unathorized $e");

    }
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
              "Connexion",
              style: pSemiBold20.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          body: Container(
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('assets/images/cropped-bkg.png'))),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "HelloHome !",
                        style: pSemiBold18.copyWith(
                          fontSize: 34,
                        ),
                      ),
                      // const SizedBox(height: 16),
                      // Text(
                      //   "Enter your Phone number or Email",
                      //   style: pRegular14.copyWith(
                      //     fontSize: 16,
                      //     color: ConstColors.text2Color,
                      //   ),
                      // ),
                      // const SizedBox(height: 5),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "for sign in, Or ",
                      //       style: pRegular14.copyWith(
                      //         fontSize: 16,
                      //         color: ConstColors.text2Color,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         Get.to(
                      //           const SignUpScreen(),
                      //           transition: Transition.rightToLeft,
                      //         );
                      //       },
                      //       child: Text(
                      //         "Create new account.",
                      //         style: pRegular14.copyWith(
                      //           fontSize: 16,
                      //           color: ConstColors.primaryColor,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Email",
                        inputType: TextInputType.emailAddress,
                        obscureText: false,
                        image: 'assets/icons/Communication/envelope.svg',
                        labelText: "",
                      ),
                      const SizedBox(height: 7),

                      _isSubmitted &&
                                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                      .hasMatch(_emailController.text) ||
                              _isSubmitted && _emailController.text.isEmpty
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _emailController.text.isEmpty
                                    ? "Email ne peut pas être vide."
                                    : "Email saisi n'est pas valide.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 7),
                      CustomTextField(
                        controller: _passController,
                        hintText: "Password",
                        inputType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                        obscureFunction: (bool v) {
                          setState(() {
                            _obscureText = !v;
                          });
                        },
                        image: _obscureText
                            ? DefaultImages.visible
                            : DefaultImages.invisible,
                        labelText: "",
                      ),
                      const SizedBox(height: 7),

                      _isSubmitted && _passController.text.length < 6 ||
                              _isSubmitted && _passController.text.isEmpty
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _passController.text.isEmpty
                                    ? "Password ne peut pas être vide."
                                    : "Password doit avoir au moins 6 caractères.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            )
                          : SizedBox(),
                      const SizedBox(height: 38),
                      // const SizedBox(height: 14),
                      InkWell(
                        onTap: () {
                          Get.to(
                            ForgotPasswordScreen(),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Mot de passe oublié ?",
                            style: pSemiBold18.copyWith(
                              fontSize: 14,
                              color: ConstColors.textColor.withOpacity(0.64),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // const SizedBox(height: 14),
                      CusttomButton(
                        color: ConstColors.primaryColor,
                        text: "SIGN IN",
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          //
                          setState(() => _isSubmitted = true);
                          if (RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(_emailController.text) &&
                              _emailController.text.isNotEmpty &&
                              _passController.text.isNotEmpty &&
                              _passController.text.length > 5) {
                            await _validateAndSubmit(model);
                          } // Get.offAll(
                          //   const TabScreen(),
                          //   transition: Transition.rightToLeft,
                          // );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Pas encore de compte ? ",
                            style: pRegular14.copyWith(
                              color: ConstColors.text2Color,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(
                                SignUpScreen("Login"),
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: Text(
                              "Créer un compte.",
                              style: pRegular14.copyWith(
                                color: ConstColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
