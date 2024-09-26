import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../services/main_model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  Timer? _timer;
  bool? _isSendResetPassSent, _isSubmitted;

  @override
  void initState() {
    super.initState();
    // signinController.flag!.value = 0;
    _isSendResetPassSent = false;
    _isSubmitted = false;
  }

  Future _validateAndSubmit(MainModel model) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    //
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var data = {"email": _emailController.text};

      var response = await model.sendResetPassword(data);

      if (response['user'] != null) {
        // Navigator.of(context).pop();
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
        //
        setState(() {
          _isSubmitted = false;
          _isSendResetPassSent = true;
        });
        //
        final snackBar = SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Password Reset was successfully sent to ${_emailController.text}. Check your email",
              style: TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      setState(() {
        _isSubmitted = false;
      });
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
            "Mot de passe oublié ?",
            style: pSemiBold20.copyWith(),
          ),
        ),
        body: SafeArea(
          child: !_isSendResetPassSent!
              ? _buildEmailField(model)
              : _buildSuccessResetPass(),
        ),
      );
    });
  }

  Widget _buildEmailField(MainModel model) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Forgot password",
              //   style: pSemiBold18.copyWith(
              //     fontSize: 34,
              //   ),
              // ),
              // const SizedBox(height: 20),
              Text(
                "Indiquez votre e-mail pour recevoir un lien temporaire.",
                // textAlign: TextAlign.center,
                style: pRegular14.copyWith(
                  fontSize: 16,
                  color: ConstColors.text2Color,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 35),
              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                inputType: TextInputType.emailAddress,
                obscureText: false,
                image: 'assets/icons/Communication/envelope.svg',
                labelText: "",
              ),
              const SizedBox(height: 7),
              _isSubmitted! &&
                          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(_emailController.text) ||
                      _isSubmitted! && _emailController.text.isEmpty
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _emailController.text.isEmpty
                            ? "Email can't be empty."
                            : "Email has been entered is not valid.",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 34),
              CusttomButton(
                color: ConstColors.primaryColor,
                text: "Envoyer",
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  //
                  setState(() => _isSubmitted = true);
                  if (RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(_emailController.text) &&
                      _emailController.text.isNotEmpty) {
                    await _validateAndSubmit(model);
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildSuccessResetPass() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reset password",
            style: pSemiBold18.copyWith(
              fontSize: 34,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "We have sent a reset password email to",
            style: pRegular14.copyWith(
              fontSize: 16,
              color: ConstColors.text2Color,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                _emailController.text,
                style: pRegular14.copyWith(
                  fontSize: 16,
                  color: ConstColors.text2Color,
                ),
              ),
              // Text(
              //   "Having problem?",
              //   style: pRegular14.copyWith(
              //     fontSize: 16,
              //     color: ConstColors.primaryColor,
              //   ),
              // ),
            ],
          ),
          // const SizedBox(height: 34),
          // CusttomButton(
          //   color: ConstColors.primaryColor,
          //   text: "Send again",
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
