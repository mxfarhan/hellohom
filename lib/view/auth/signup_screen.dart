import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/default_image.dart';
import 'package:flutter/gestures.dart';
import 'package:foodly/view/auth/verify_mobile_screen.dart';
import 'package:foodly/view/privacy_policy_webview.dart';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'dart:async';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/view/auth/signin_screen.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodly/widget/custom_textfield.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  final String fromPage;
  //
  SignUpScreen(this.fromPage);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _emailController = TextEditingController();
  var _passController = TextEditingController();
  var _nameController = TextEditingController();
  var _cityController = TextEditingController();
  var _addressController = TextEditingController();
  var _zipController = TextEditingController();
  var _phoneController = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  Timer? _timer;
  bool _isSubmitted = false, _obscureText = false;

  @override
  void initState() {
    super.initState();

    _obscureText = true;
  }

  Future _validateAndSubmit(MainModel model) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    _formKey.currentState!.save();

    try {
      var data;

      if (widget.fromPage == "Login") {
        data = {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'zip_code': _zipController.text,
          'roles': 'USER'
        };
      } else {
        data = {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'zip_code': _zipController.text,
          'roles': 'OWNER'
        };
      }

      var responseData = await model.signUp(data);
      if (responseData["user"] != null) {
        //
        if (widget.fromPage == "Check Card Code") {
          var data = {
            'recipient': _nameController.text,
            'phone': _phoneController.text,
            'zip_code': _zipController.text,
            'city': _cityController.text,
            'address': _addressController.text,
            'email': _emailController.text,
            'products_id': model.checkCardCodeResult.productsId,
            'payment_id':
                'PAYID-${_nameController.text}-${responseData['user']['id']}',
            'payment_method': 'CASH',
            'status': "active",
            'price': model.checkCardCodeResult.price,
            'users_id': responseData['user']['id'],
            'card_code': model.checkCardCodeResult.cardCode,
            'start_date': '${DateTime.now()}'
          };

          var responseDataPurchase =
              await model.editPurchaseCard(data, model.checkCardCodeResult.id);
          if (responseDataPurchase["data"] != null) {
            debugPrint(
                "Response edit purchase card response: $responseDataPurchase");
            //
          }
        }

        var responseOTP = await model.sendOTPemail(responseData);

        if (responseOTP['otp'] != null) {
          _timer?.cancel();
          await EasyLoading.dismiss();
          //
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      VerifyMobileScreen(responseData, responseOTP)));

          //
          _nameController.clear();
          _passController.clear();
          _emailController.clear();
          _phoneController.clear();
          _addressController.clear();
          _cityController.clear();
          _zipController.clear();
        }
        // } else {
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        // }
        //
      } else {
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
        //
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
      }
      // });
    } catch (e) {
      print(e);
      print("Unathorized");
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
              "Sign up",
              style: pSemiBold20.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Create Account",
                      //   style: pSemiBold18.copyWith(
                      //     fontSize: 34,
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      // Text(
                      //   "Enter your Name, Email and Password",
                      //   style: pRegular14.copyWith(
                      //     fontSize: 16,
                      //     color: ConstColors.text2Color,
                      //   ),
                      // ),
                      // const SizedBox(height: 5),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "for sign up. ",
                      //       style: pRegular14.copyWith(
                      //         fontSize: 16,
                      //         color: ConstColors.text2Color,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         Get.to(
                      //           const SignInScreen(),
                      //           transition: Transition.rightToLeft,
                      //         );
                      //       },
                      //       child: Text(
                      //         "Already have account?",
                      //         style: pRegular14.copyWith(
                      //           fontSize: 16,
                      //           color: ConstColors.primaryColor,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: _nameController,
                        hintText: "Nom",
                        inputType: TextInputType.name,
                        obscureText: false,
                        image: 'assets/icons/Web and Technology/user.svg',
                        labelText: "Nom",
                      ),
                      const SizedBox(height: 7),

                      _isSubmitted && _nameController.text.length < 3 ||
                              _isSubmitted && _nameController.text.isEmpty
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _nameController.text.isEmpty
                                    ? "Name ne peut pas être vide."
                                    : "Name doit avoir au moins 3 caractères.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 7),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Email",
                        inputType: TextInputType.emailAddress,
                        obscureText: false,
                        image: 'assets/icons/Communication/envelope.svg',
                        labelText: "EMAIL",
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
                        labelText: "PASSWORD",
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
                          : const SizedBox(),
                      const SizedBox(height: 27),
                      Text(
                        "Information",
                        style: pSemiBold18.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Tèl :",
                          style: pRegular14.copyWith(
                            fontSize: 14,
                            color: ConstColors.text2Color,
                          ),
                        ),
                      ),
                      IntlPhoneField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          fillColor: const Color(0xffFBFBFB),
                          filled: true,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xffF3F2F2),
                            ),
                          ),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xffF3F2F2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1,
                              color: ConstColors.primaryColor,
                            ),
                          ),
                        ),
                        disableLengthCheck: true,
                        initialCountryCode: 'FR',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                      ),

                      const SizedBox(height: 7),

                      _isSubmitted && _phoneController.text.length < 9 ||
                              _isSubmitted && _phoneController.text.isEmpty
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _phoneController.text.isEmpty
                                    ? "Phone ne peut pas être vide."
                                    : "Phone Number doit avoir au moins 9 caractères.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox(
                              height: 7,
                            ),
                      CustomTextField(
                        controller: _addressController,
                        hintText: "Entrez votre adresse, y compris la ville",
                        inputType: TextInputType.text,
                        obscureText: false,
                        image: "",
                        labelText: "Adresse :",
                      ),
                      const SizedBox(height: 7),

                      _isSubmitted && _addressController.text.length < 9 ||
                              _isSubmitted && _addressController.text.isEmpty
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _addressController.text.isEmpty
                                    ? "Address ne peut pas être vide."
                                    : "Address doit avoir au moins 9 caractères.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox(),

                      CustomTextField(
                        controller: _cityController,
                        hintText: "veuillez entrer votre message personnel",
                        inputType: TextInputType.text,
                        obscureText: false,
                        image: "",
                        labelText: "Votre message :",
                      ),
                      const SizedBox(height: 7),

                      // _isSubmitted && _cityController.text.length < 5 ||
                      _isSubmitted && _cityController.text.isEmpty
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                // _cityController.text.isEmpty
                                //     ?
                                "City ne peut pas être vide.",
                                // : "City must have atleast 5 character.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox(),

                      CustomTextField(
                        controller: _zipController,
                        hintText: "Zip Code",
                        inputType: TextInputType.number,
                        obscureText: false,
                        image: "",
                        labelText: "Code Postal :",
                      ),

                      _isSubmitted && _zipController.text.length < 5 ||
                              _isSubmitted && _zipController.text.isEmpty
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _zipController.text.isEmpty
                                    ? "Zip Code ne peut pas être vide."
                                    : "Zip Code doit avoir au moins 5 caractères.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 24),
                      CusttomButton(
                        color: ConstColors.primaryColor,
                        text: "Enregister",
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();

                          setState(() => _isSubmitted = true);
                          if (_nameController.text.isNotEmpty &&
                              _nameController.text.length > 2 &&
                              RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(_emailController.text) &&
                              _emailController.text.isNotEmpty &&
                              _passController.text.isNotEmpty &&
                              _passController.text.length > 5 &&
                              _phoneController.text.isNotEmpty &&
                              _phoneController.text.length > 8 &&
                              _addressController.text.isNotEmpty &&
                              _addressController.text.length > 10 &&
                              _cityController.text.isNotEmpty &&
                              // _cityController.text.length > 4 &&
                              _zipController.text.isNotEmpty &&
                              _zipController.text.length > 4) {
                            await _validateAndSubmit(model);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                              text: 'En vous enregistrant vous acceptez les ',
                              style: pRegular14.copyWith(
                                fontSize: 16,
                                color: ConstColors.text2Color,
                                height: 1.5,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'conditions d’utilisations.',
                                    style: pSemiBold18.copyWith(
                                      fontSize: 18,
                                      color: ConstColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                      height: 1.5,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();

                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (BuildContext
                                        //                 context) =>
                                        //             PrivacyPolicyWebview()));
                                        // code to open / launch terms of service link here
                                      }),
                                // TextSpan(
                                //     text: ' and ',
                                //     style: TextStyle(
                                //         fontSize: 18, color: Colors.black),
                                //     children: <TextSpan>[
                                //       TextSpan(
                                //           text: 'Privacy Policy',
                                //           style: TextStyle(
                                //               fontSize: 18,
                                //               color: Colors.black,
                                //               decoration: TextDecoration.underline),
                                //           recognizer: TapGestureRecognizer()
                                //             ..onTap = () {
                                //               // code to open / launch privacy policy link here
                                //             })
                                //     ])
                              ])),
                      // Center(
                      //   child: Text(
                      //     "By Signing up you agree to our Terms\nConditions & Privacy Policy.",
                      //     style: pRegular14.copyWith(
                      //       fontSize: 16,
                      //       color: ConstColors.text2Color,
                      //       height: 1.5,
                      //     ),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      const SizedBox(height: 16),
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
                      // const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
