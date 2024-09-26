import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/default_image.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var _currentPassController = TextEditingController();
  var _newPassController = TextEditingController();
  var _confirmNewPassController = TextEditingController();

  Timer? _timer;
  bool _isSubmitted = false;

  Future _validateAndSubmit(MainModel model) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var data = {
        'password': _newPassController.text,
        // 'password_now': _currentPassController.text,
        'name': model.nama,
        'email': model.email
      };

      print(data);

      var responseData = await model.changePassword(data);
      if (responseData.data['message'] == 'true') {
        print("Response change password: $responseData");

        _timer?.cancel();
        await EasyLoading.dismiss();
        //
        setState(() => _isSubmitted = false);
        //
        _newPassController.clear();
        _currentPassController.clear();
        _confirmNewPassController.clear();
        //
        Navigator.of(context).pop();
        final snackBar = SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Password has been changed.",
              style: TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print("Unathorized");
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              responseData.data['message'],
              style: TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        setState(() => _isSubmitted = false);
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
    } catch (e) {
      print("Exception $e");
      //
      setState(() => _isSubmitted = false);
      //
      _timer?.cancel();
      await EasyLoading.dismiss();
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
            "Modifier le mot de passe",
            style: pSemiBold20.copyWith(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _currentPassController,
                          hintText: "Enter current password",
                          inputType: TextInputType.visiblePassword,
                          obscureText: true,
                          image: "",
                          labelText: "Mot de passe actuel",
                        ),
                        const SizedBox(height: 7),
                        _isSubmitted &&
                                    _currentPassController.text.length < 6 ||
                                _isSubmitted &&
                                    _currentPassController.text.isEmpty
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _currentPassController.text.isEmpty
                                      ? "Current Password can't be empty"
                                      : "Current Password must have atleast 6 character.",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : SizedBox(),
                        const SizedBox(height: 7),
                        CustomTextField(
                          controller: _newPassController,
                          hintText: "Enter new password",
                          inputType: TextInputType.visiblePassword,
                          obscureText: true,
                          image: "",
                          labelText: "Nouveau mot depasse",
                        ),
                        const SizedBox(height: 7),
                        _isSubmitted && _newPassController.text.length < 6 ||
                                _isSubmitted && _newPassController.text.isEmpty
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _newPassController.text.isEmpty
                                      ? "New Password can't be empty"
                                      : "New Password must have atleast 6 character.",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : SizedBox(),
                        const SizedBox(height: 7),
                        CustomTextField(
                          controller: _confirmNewPassController,
                          hintText: "Enter confirm new password",
                          inputType: TextInputType.visiblePassword,
                          obscureText: true,
                          image: "",
                          labelText: "Confirmer le mot de passe",
                        ),
                        const SizedBox(height: 7),
                        _isSubmitted &&
                                    _confirmNewPassController.text.isEmpty ||
                                _isSubmitted &&
                                    _newPassController.text !=
                                        _confirmNewPassController.text
                            ? Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  _confirmNewPassController.text.isEmpty
                                      ? "Confirm Password can't be empty"
                                      : "Confirm Password doesn't match.",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
              CusttomButton(
                color: ConstColors.primaryColor,
                text: "Valider",
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();

                  setState(() => _isSubmitted = true);
                  if (_currentPassController.text.isNotEmpty &&
                      _currentPassController.text.length > 5 &&
                      _newPassController.text.isNotEmpty &&
                      _newPassController.text.length > 5 &&
                      _confirmNewPassController.text.isNotEmpty &&
                      _confirmNewPassController.text ==
                          _newPassController.text) {
                    await _validateAndSubmit(model);
                  } // Get.offAll(
                  //   const TabScreen(),
                  //   transition: Transition.rightToLeft,
                  // );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    });
  }
}
