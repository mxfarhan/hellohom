// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'dart:async';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/view/auth/location_screen.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VerifyMobileScreen extends StatefulWidget {
  final Map otp;
  final Map user;

  VerifyMobileScreen(this.user, this.otp);

  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  Timer? _timer;
  var _pinputController = TextEditingController();
  late String _otpCode = "", _otpValue;

  final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: pSemiBold20,
      decoration: const BoxDecoration(
        color: ConstColors.whiteFontColor,
      ),
      padding: EdgeInsets.only(right: 10));

  @override
  void initState() {
    super.initState();

    _otpValue = widget.otp["otp"]["token"];
  }

  Future _submitOTP(MainModel model) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    model.buildDelayed();

    Future.delayed(Duration(seconds: 2), () async {
      if (_otpValue != _otpCode) {
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
        //
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Incorrect OTP Code. Please check again",
              style: TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var responseVerify = await model.sendVerifiedEmail(widget.user);

        if (responseVerify['id'] != null) {
          //
          _timer?.cancel();
          await EasyLoading.dismiss();
          //
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
          //
          model.clearCheckCardCodeResult();
          //
          // _pinputController.clear();

          // final snackBar = SnackBar(
          //     backgroundColor: Colors.red,
          //     duration: Duration(seconds: 4),
          //     behavior: SnackBarBehavior.floating,
          //     content: Text(
          //       "Halo ${responseVerify["name"]}, selamat datang di Bestari 👏",
          //       style: TextStyle(fontSize: 14, height: 1.4),
          //     ));
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          _timer?.cancel();
          await EasyLoading.dismiss();
          //
          final snackBar = SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              content: Text(
                "There is an error. Please check again",
                style: TextStyle(fontSize: 14, height: 1.4),
              ));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        // backgroundColor: ConstColors.whiteFontColor,
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
            "Confirm Account",
            style: pSemiBold20.copyWith(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Vérifiez vos email",
                  style: pSemiBold20.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  widget.user["user"] == null
                      ? "Indiquer le code à 4 chiffres at\n${widget.user["email"]}"
                      : "Indiquer le code à 4 chiffres at\n${widget.user["user"]["email"]}",
                  style: pRegular14.copyWith(
                    fontSize: 16,
                    color: ConstColors.text2Color,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 34),
              Pinput(
                controller: _pinputController,
                defaultPinTheme: defaultPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onChanged: (v) {
                  setState(() {
                    _otpCode = v;
                  });
                },
                onCompleted: (pin) => {},
              ),
              const SizedBox(height: 34),
              CusttomButton(
                color: _otpCode.length < 4
                    ? ConstColors.text2Color
                    : ConstColors.primaryColor,
                text: "Continue",
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();

                  if (model.isLoadingUser
                      // || _isLoadingSendCode
                      ) {
                    debugPrint("no action");
                  } else {
                    await _submitOTP(model);
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn’t receive code? ",
                    style: pSemiBold18.copyWith(
                      fontSize: 16,
                      color: ConstColors.text2Color,
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        //
                        _timer?.cancel();
                        await EasyLoading.show(
                            maskType: EasyLoadingMaskType.custom);

                        //
                        var responseEmailOTP =
                            await model.sendOTPemail(widget.user);

                        if (responseEmailOTP['otp'] != null) {
                          //
                          _timer?.cancel();
                          await EasyLoading.dismiss();
                          //
                          setState(() {
                            _otpValue = responseEmailOTP["otp"]["token"];
                          });
                          //
                          final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 4),
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                responseEmailOTP["otp"]["message"],
                                style: TextStyle(fontSize: 14, height: 1.4),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          _timer?.cancel();
                          await EasyLoading.dismiss();
                          //
                          final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                "There is an error. Please check again",
                                style: TextStyle(fontSize: 14, height: 1.4),
                              ));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text(
                        "Renvoyer Code.",
                        style: pSemiBold18.copyWith(
                          fontSize: 16,
                          color: ConstColors.primaryColor,
                        ),
                      )),
                ],
              ),
              // const SizedBox(height: 16),
              // Text(
              //   "By Signing up you agree to our Terms\nConditions & Privacy Policy.",
              //   style: pRegular14.copyWith(
              //     fontSize: 16,
              //     color: ConstColors.text2Color,
              //     height: 1.5,
              //   ),
              //   textAlign: TextAlign.center,
              // )
            ],
          ),
        ),
      );
    });
  }
}
