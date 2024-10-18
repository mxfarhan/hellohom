import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'dart:async';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/config/default_image.dart';
//import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:get/get.dart';
import 'package:foodly/model/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  int _radioGroup = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
              "Change Language",
              style: pSemiBold20.copyWith(),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Container(
                    height: 100,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 2),
                        // gradient: LinearGradient(
                        // colors: [
                        //   ConstColors.primaryColor,
                        //   ConstColors.primaryColor.withOpacity(0.7),
                        // ],
                        // begin: Alignment.bottomCenter,
                        // end: Alignment.topCenter,
                        // begin:
                        //     Alignment.topLeft, //begin of the gradient color
                        // end: Alignment
                        //     .bottomRight, //end of the gradient color
                        // stops: [0, 0.2, 0.5, 0.8]
                        // ), //stop),
                        color:
                            // _selectSubscriptionPlan == e
                            //     ? ConstColors.textColor
                            //     :
                            ConstColors.whiteFontColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                        left: 20, right: 10, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/uk.png', height: 46),
                            SizedBox(width: 12),
                            Text(
                              "English",
                              style: pSemiBold20.copyWith(
                                // letterSpacing: 1.7,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: ConstColors.textColor,
                              ),
                            )
                          ],
                        ),
                        Transform.scale(
                            scale: 1.5,
                            child: Radio(
                                value: 1,
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  return ConstColors.primaryColor;
                                }),
                                // ----

                                // value: 'en',
                                // groupValue: langValue,
                                activeColor: Colors.white,
                                // activeColor: ,
                                groupValue: _radioGroup,
                                onChanged: (int? v) {
                                  setState(() {
                                    _radioGroup = v!;
                                  });
                                }))
                      ],
                    )),
                Container(
                    height: 100,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 2),
                        // gradient: LinearGradient(
                        // colors: [
                        //   ConstColors.primaryColor,
                        //   ConstColors.primaryColor.withOpacity(0.7),
                        // ],
                        // begin: Alignment.bottomCenter,
                        // end: Alignment.topCenter,
                        // begin:
                        //     Alignment.topLeft, //begin of the gradient color
                        // end: Alignment
                        //     .bottomRight, //end of the gradient color
                        // stops: [0, 0.2, 0.5, 0.8]
                        // ), //stop),
                        color:
                            // _selectSubscriptionPlan == e
                            //     ? ConstColors.textColor
                            //     :
                            ConstColors.whiteFontColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                        left: 20, right: 10, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/france.png', height: 46),
                            SizedBox(width: 12),
                            Text(
                              "French",
                              style: pSemiBold20.copyWith(
                                // letterSpacing: 1.7,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: ConstColors.textColor,
                              ),
                            )
                          ],
                        ),
                        Transform.scale(
                            scale: 1.5,
                            child: Radio(
                                value: 2,
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  return ConstColors.primaryColor;
                                }),
                                // ----

                                // value: 'en',
                                // groupValue: langValue,
                                activeColor: Colors.white,
                                // activeColor: ,
                                groupValue: _radioGroup,
                                onChanged: (int? v) {
                                  setState(() {
                                    _radioGroup = v!;
                                  });
                                }))
                      ],
                    ))
              ],
            ),
          ));
    });
  }
}
