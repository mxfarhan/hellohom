import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'dart:async';
import 'dart:math';
import 'package:foodly/config/text_style.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:get/get.dart';
import 'package:randomstring_dart/randomstring_dart.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';
import '../../services/main_model.dart';

class PurchaseCardPage extends StatefulWidget {
  final MainModel model;

  PurchaseCardPage(this.model);

  @override
  State<PurchaseCardPage> createState() => _PurchaseCardPageState();
}

class _PurchaseCardPageState extends State<PurchaseCardPage> {
  Timer? _timer;
  EasyLoadingStatus? _easyLoadingStatus;

  var _nameController = TextEditingController();
  var _surnameController = TextEditingController();
  var _addressController = TextEditingController();
  var _zipCodeController = TextEditingController();
  var _cityController = TextEditingController();

  final rs = RandomString();
  var randomString;

  var _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  @override
  void initState() {
    super.initState();

    loadData("Init State");
  }

  Future loadData(String fromPart) async {
    EasyLoading.addStatusCallback((status) {
      debugPrint('EasyLoading Status $status');
      setState(() {
        _easyLoadingStatus = status;
      });
    });

    if (fromPart == "Init State") {
      _timer?.cancel();
      await EasyLoading.show(maskType: EasyLoadingMaskType.custom);
    }

    try {
      var responseDataCard = await widget.model.fetchProductCard();
      if (responseDataCard.statusCode == 200) {
        //
        debugPrint("responseDataCard: ${responseDataCard.data}");

        var responseData = await widget.model.fetchMyPurchaseCards();
        if (responseData['message'] == 'true') {
          _timer?.cancel();
          await EasyLoading.dismiss();
          //

          if (widget.model.purchaseCardList.isEmpty) {
            //
            _nameController.text = widget.model.user.name ?? "";
            _surnameController.text = "";
            _addressController.text = widget.model.user.address ?? "";
            _cityController.text = widget.model.user.city ?? "";
            _zipCodeController.text = widget.model.user.zipCode ?? "";
          } else {
            //
            _nameController.text =
                widget.model.purchaseCardList[0].user?.name ?? "";
            _surnameController.text =
                widget.model.purchaseCardList[0].recipient ?? "";
            _addressController.text =
                widget.model.purchaseCardList[0].address ?? "";
            _cityController.text =
                widget.model.purchaseCardList[0].city ?? "Marseille";
            _zipCodeController.text =
                widget.model.purchaseCardList[0].zipCode ?? "";
          }

          if (fromPart == "Purchase Card") {
            _showSuccessDialog();
          }

          //
        } else {
          _timer?.cancel();
          await EasyLoading.dismiss();
        }
      } else {
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
    } catch (e) {
      _timer?.cancel();
      await EasyLoading.dismiss();
    }
  }

  Future _purchaseCard(MainModel model, Map paymentData) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);

    try {
      var data = {
        // 'nick_name': _nameController.text,
        'recipient': _surnameController.text,
        // 'surname': _nameController.text,
        'phone': model.user.phone,
        'zip_code': _zipCodeController.text,
        'city': _cityController.text,
        'address': _addressController.text,
        'email': model.user.email,
        'products_id': model.hellohomeCardProduct.id,
        'payment_id': paymentData['data']['id'],
        'payment_method': paymentData['data']['payer']['payment_method'],
        'status': "not active",
        'price': model.hellohomeCardProduct.price,
        'users_id': model.users.id,
        'card_code':
            "${getRandomString(4)}-${getRandomString(4)}-${getRandomString(4)}",
        'start_date': '${DateTime.now()}'
      };

      var responseData = await model.purchaseCard(data);
      if (responseData["data"] != null) {
        debugPrint("Response purchase card response: $responseData");
        //
        // _timer?.cancel();
        // await EasyLoading.dismiss();
        //
        // _nameController.clear();
        // _addressController.clear();
        //
        await loadData("Purchase Card");
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
        // setState(() => _isSubmitted = false);
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
      // });
    } catch (e) {
      //
      // setState(() => _isSubmitted = false);
      _timer?.cancel();
      await EasyLoading.dismiss();
      //
      debugPrint("Unathorized");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // widget.model.clearMyPurchaseCards();
    EasyLoading.removeAllCallbacks();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        backgroundColor: model.isLoadingPurchaseCard ||
                _easyLoadingStatus == EasyLoadingStatus.show
            ? ConstColors.whiteFontColor
            : _easyLoadingStatus == EasyLoadingStatus.dismiss &&
                    !model.isLoadingPurchaseCard &&
                    model.purchaseCardList.length == 0
                ? ConstColors.primaryColor
                : ConstColors.whiteFontColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: model.isLoadingPurchaseCard ||
                      _easyLoadingStatus == EasyLoadingStatus.show
                  ? ConstColors.textColor
                  : _easyLoadingStatus == EasyLoadingStatus.dismiss &&
                          !model.isLoadingPurchaseCard &&
                          model.purchaseCardList.length == 0
                      ? ConstColors.whiteFontColor
                      : ConstColors.textColor,
              size: 20,
            ),
          ),
          title: Text(
            // model.isLoadingPurchaseCard
            //     ?
            "HelloHome Card",
            // : !model.isLoadingPurchaseCard &&
            //         model.purchaseCardList.length == 0
            //     ? "Purchase Card"
            //     : "My Card",
            // "Purchase Card",
            style: pSemiBold20.copyWith(
                color: model.isLoadingPurchaseCard ||
                        _easyLoadingStatus == EasyLoadingStatus.show
                    ? ConstColors.textColor
                    : _easyLoadingStatus == EasyLoadingStatus.dismiss &&
                            !model.isLoadingPurchaseCard &&
                            model.purchaseCardList.length == 0
                        ? ConstColors.whiteFontColor
                        : ConstColors.textColor),
          ),
        ),
        body: model.isLoadingPurchaseCard ||
                _easyLoadingStatus == EasyLoadingStatus.show
            ? const SizedBox()
            : _easyLoadingStatus == EasyLoadingStatus.dismiss &&
                    !model.isLoadingPurchaseCard
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                Image.asset('assets/hellohome_purchase.jpg')),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.only(top: 14, bottom: 10),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/card.svg',
                                    color: model.isLoadingPurchaseCard ||
                                            !model.isLoadingPurchaseCard &&
                                                model.purchaseCardList.length ==
                                                    0
                                        ? ConstColors.whiteFontColor
                                        : ConstColors.textColor,
                                    height: 24,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    "Pack HelloHome",
                                    style: pSemiBold20.copyWith(
                                        fontSize: 18,
                                        color: model.isLoadingPurchaseCard ||
                                                !model.isLoadingPurchaseCard &&
                                                    model.purchaseCardList
                                                            .length ==
                                                        0
                                            ? ConstColors.whiteFontColor
                                            : ConstColors.textColor),
                                  )
                                ],
                              ),
                              SizedBox(height: 14),
                              // Container(
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //           child: Text("Identity:",
                              //               style: pRegular14.copyWith(
                              //                 fontSize: 14,
                              //                 color: model.isLoadingPurchaseCard ||
                              //                         !model.isLoadingPurchaseCard &&
                              //                             model.purchaseCardList
                              //                                     .length ==
                              //                                 0
                              //                     ? ConstColors.whiteFontColor
                              //                     : ConstColors.textColor,
                              //               ))),
                              //       Expanded(
                              //           child: Text("QR Code",
                              //               style: pRegular14.copyWith(
                              //                   fontSize: 14,
                              //                   color: model.isLoadingPurchaseCard ||
                              //                           !model.isLoadingPurchaseCard &&
                              //                               model.purchaseCardList
                              //                                       .length ==
                              //                                   0
                              //                       ? ConstColors.whiteFontColor
                              //                       : ConstColors.textColor))),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(height: 4),
                              // Container(
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //           child: Text("Item:",
                              //               style: pRegular14.copyWith(
                              //                 fontSize: 14,
                              //                 color: model.isLoadingPurchaseCard ||
                              //                         !model.isLoadingPurchaseCard &&
                              //                             model.purchaseCardList
                              //                                     .length ==
                              //                                 0
                              //                     ? ConstColors.whiteFontColor
                              //                     : ConstColors.textColor,
                              //               ))),
                              //       Expanded(
                              //           child: Text("1 pc",
                              //               style: pRegular14.copyWith(
                              //                   fontSize: 14,
                              //                   color: model.isLoadingPurchaseCard ||
                              //                           !model.isLoadingPurchaseCard &&
                              //                               model.purchaseCardList
                              //                                       .length ==
                              //                                   0
                              //                       ? ConstColors.whiteFontColor
                              //                       : ConstColors.textColor))),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(height: 4),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text("Color:",
                                            style: pRegular14.copyWith(
                                              fontSize: 14,
                                              color: model.isLoadingPurchaseCard ||
                                                      !model.isLoadingPurchaseCard &&
                                                          model.purchaseCardList
                                                                  .length ==
                                                              0
                                                  ? ConstColors.whiteFontColor
                                                  : ConstColors.textColor,
                                            ))),
                                    Expanded(
                                        child: Text(
                                            "${model.hellohomeCardProduct.description}",
                                            style: pRegular14.copyWith(
                                              fontSize: 14,
                                              color: model.isLoadingPurchaseCard ||
                                                      !model.isLoadingPurchaseCard &&
                                                          model.purchaseCardList
                                                                  .length ==
                                                              0
                                                  ? ConstColors.whiteFontColor
                                                  : ConstColors.textColor,
                                            ))),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              // Container(
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //           child: Text("Period:",
                              //               style: pRegular14.copyWith(
                              //                 fontSize: 14,
                              //                 color: model.isLoadingPurchaseCard ||
                              //                         !model.isLoadingPurchaseCard &&
                              //                             model.purchaseCardList
                              //                                     .length ==
                              //                                 0
                              //                     ? ConstColors.whiteFontColor
                              //                     : ConstColors.textColor,
                              //               ))),
                              //       Expanded(
                              //           child: Text("1 Year",
                              //               style: pRegular14.copyWith(
                              //                 fontSize: 14,
                              //                 color: model.isLoadingPurchaseCard ||
                              //                         !model.isLoadingPurchaseCard &&
                              //                             model.purchaseCardList
                              //                                     .length ==
                              //                                 0
                              //                     ? ConstColors.whiteFontColor
                              //                     : ConstColors.textColor,
                              //               ))),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(height: 4),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                            model.isLoadingPurchaseCard ||
                                                    !model.isLoadingPurchaseCard &&
                                                        model.purchaseCardList
                                                                .length ==
                                                            0
                                                ? "Tarif:"
                                                : "Statut:",
                                            style: pRegular14.copyWith(
                                              fontSize: 14,
                                              color: model.isLoadingPurchaseCard ||
                                                      !model.isLoadingPurchaseCard &&
                                                          model.purchaseCardList
                                                                  .length ==
                                                              0
                                                  ? ConstColors.whiteFontColor
                                                  : ConstColors.textColor,
                                            ))),
                                    Expanded(
                                        child: Container(
                                            // padding: EdgeInsets.symmetric(
                                            //     horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                                // color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                                model.isLoadingPurchaseCard ||
                                                        !model.isLoadingPurchaseCard &&
                                                            model.purchaseCardList
                                                                    .length ==
                                                                0
                                                    ? "€${model.hellohomeCardProduct.price}"
                                                    : "ACTIVE",
                                                style: pSemiBold18.copyWith(
                                                  fontSize: 14,
                                                  color: model.isLoadingPurchaseCard ||
                                                          !model.isLoadingPurchaseCard &&
                                                              model.purchaseCardList
                                                                      .length ==
                                                                  0
                                                      ? ConstColors
                                                          .whiteFontColor
                                                      : Colors.green,
                                                )))),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                model.isLoadingPurchaseCard ||
                                        !model.isLoadingPurchaseCard &&
                                            model.purchaseCardList.length == 0
                                    ? "Destinataire"
                                    : "Adresse de livraison",
                                style: pSemiBold20.copyWith(
                                    fontSize: 18,
                                    color: model.isLoadingPurchaseCard ||
                                            !model.isLoadingPurchaseCard &&
                                                model.purchaseCardList.length ==
                                                    0
                                        ? ConstColors.whiteFontColor
                                        : ConstColors.textColor),
                              ),
                              SizedBox(height: 14),
                              TextFormField(
                                style: pSemiBold18.copyWith(fontSize: 16),
                                controller: _nameController,
                                enabled: model.isLoadingPurchaseCard ||
                                        !model.isLoadingPurchaseCard &&
                                            model.purchaseCardList.length == 0
                                    ? true
                                    : false,
                                cursorColor: ConstColors.primaryColor,
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                      margin: EdgeInsets.all(7),
                                      child: SvgPicture.asset(
                                        'assets/images/profile.svg',
                                        color: ConstColors.primaryColor,
                                      )),
                                  fillColor: const Color(0xffFBFBFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 16, bottom: 16, right: 10),
                                  isDense: true,
                                  hintText: "Enter the Destinataire name",
                                  hintStyle: pRegular14.copyWith(
                                    fontSize: 16,
                                    color: ConstColors.text2Color,
                                  ),
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
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                style: pSemiBold18.copyWith(fontSize: 16),
                                controller: _surnameController,
                                enabled: model.isLoadingPurchaseCard ||
                                        !model.isLoadingPurchaseCard &&
                                            model.purchaseCardList.length == 0
                                    ? true
                                    : false,
                                cursorColor: ConstColors.primaryColor,
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                      margin: EdgeInsets.all(7),
                                      child: SvgPicture.asset(
                                        'assets/images/profile.svg',
                                        color: ConstColors.primaryColor,
                                      )),
                                  fillColor: const Color(0xffFBFBFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 16, bottom: 16, right: 10),
                                  isDense: true,
                                  hintText: "Enter your surname",
                                  hintStyle: pRegular14.copyWith(
                                    fontSize: 16,
                                    color: ConstColors.text2Color,
                                  ),
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
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                style: pSemiBold18.copyWith(
                                    fontSize: 16, height: 1.4),
                                cursorColor: ConstColors.primaryColor,
                                controller: _addressController,
                                maxLines: null,
                                enabled: model.isLoadingPurchaseCard ||
                                        !model.isLoadingPurchaseCard &&
                                            model.purchaseCardList.length == 0
                                    ? true
                                    : false,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                      margin: EdgeInsets.all(7),
                                      child: SvgPicture.asset(
                                        'assets/images/marker.svg',
                                        color: ConstColors.primaryColor,
                                      )),
                                  fillColor: const Color(0xffFBFBFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 16, bottom: 16, right: 10),
                                  isDense: true,
                                  hintText: "Enter your address",
                                  hintStyle: pRegular14.copyWith(
                                    fontSize: 16,
                                    color: ConstColors.text2Color,
                                  ),
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
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                style: pSemiBold18.copyWith(
                                    fontSize: 16, height: 1.4),
                                cursorColor: ConstColors.primaryColor,
                                controller: _cityController,
                                maxLines: null,
                                enabled: model.isLoadingPurchaseCard ||
                                        !model.isLoadingPurchaseCard &&
                                            model.purchaseCardList.length == 0
                                    ? true
                                    : false,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  // prefixIcon: Container(
                                  //     margin: EdgeInsets.all(7),
                                  //     child: SvgPicture.asset(
                                  //       'assets/images/marker.svg',
                                  //       color: ConstColors.primaryColor,
                                  // )),
                                  fillColor: const Color(0xffFBFBFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 16, bottom: 16, right: 10),
                                  isDense: true,
                                  hintText: "Enter your city",
                                  hintStyle: pRegular14.copyWith(
                                    fontSize: 16,
                                    color: ConstColors.text2Color,
                                  ),
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
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                style: pSemiBold18.copyWith(
                                    fontSize: 16, height: 1.4),
                                cursorColor: ConstColors.primaryColor,
                                controller: _zipCodeController,
                                maxLines: null,
                                enabled: model.isLoadingPurchaseCard ||
                                        !model.isLoadingPurchaseCard &&
                                            model.purchaseCardList.length == 0
                                    ? true
                                    : false,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  // prefixIcon: Container(
                                  //     margin: EdgeInsets.all(7),
                                  //     child: SvgPicture.asset(
                                  //       'assets/images/marker.svg',
                                  //       color: ConstColors.primaryColor,
                                  // )),
                                  fillColor: const Color(0xffFBFBFB),
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 16, bottom: 16, right: 10),
                                  isDense: true,
                                  hintText: "Enter your zip code",
                                  hintStyle: pRegular14.copyWith(
                                    fontSize: 16,
                                    color: ConstColors.text2Color,
                                  ),
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
                              ),
                              const SizedBox(height: 36),
                              InkWell(
                                onTap: () async {
                                  if (model.isLoadingPurchaseCard ||
                                      !model.isLoadingPurchaseCard &&
                                          model.purchaseCardList.length == 0) {
                                    if (_nameController.text.isEmpty ||
                                        _surnameController.text.isEmpty ||
                                        _addressController.text.isEmpty ||
                                        _cityController.text.isEmpty ||
                                        _zipCodeController.text.isEmpty) {
                                      final snackBar = SnackBar(
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            "Make sure there are no empty fields.",
                                            style: TextStyle(
                                                fontSize: 14, height: 1.4),
                                          ));

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PaypalCheckout(
                                          sandboxMode: false,
                                          clientId: "AV4QNNZ1YsVj6kaQgvwvTWxACzzAKzDYDY93-sc8tg-8rHb2za_pFJ5jBpaLw8kXKFPTrk6bKdYUvYcX",
                                            //  "AY0LwNGUdjsxABMPUbU3yXkUoFRvZmcjIilpldjnf07JS8Cw3xgx4x3IYPaE_LayI1m2w-KWga8gjczy",
                                          // "AfoizQgMUTjIuH-R0axBoDrZNz5S8M0aZFBHY1Q14InD-Wea9gEIBAvCIXfweU8mLj9Tnkq3I1UXYKc0",
                                          secretKey: "ECabSQA8uGmdcSb9qPyfbfiLn5mmuoha-M-8TT6MUfEDiSSCC0YvjoS9O_D-B9dG8SJjPXNK21RcSSct",
                                              // "EL6rrqYX_J-Lr5lHwZHEViZmXr3P-0qJMn5dIw_9ZaVRvk_Gp5Ui7mskS-bWvMhjXz4wZaQQ8pPJasbz",
                                              // "ELGiHNrV75iV4Q55ozYN5c3fhYEzZvtJSur1QC7qbpZ7ULV_f83smb613nFb7EjpM24Nw_Dq7qcD0uTt",
                                          returnURL: "success.snippetcoder.com",
                                          cancelURL: "cancel.snippetcoder.com",
                                          transactions: [
                                            {
                                              "amount": {
                                                "total":
                                                    '${model.hellohomeCardProduct.price}',
                                                "currency": "EUR",
                                                "details": {
                                                  "subtotal":
                                                      '${model.hellohomeCardProduct.price}',
                                                  "shipping": '0',
                                                  "shipping_discount": 0
                                                }
                                              },
                                              "description":
                                                  "HelloHome Card for ${model.user.name!}",
                                              "item_list": {
                                                "items": [
                                                  {
                                                    "name": "HelloHome Card",
                                                    "quantity": 1,
                                                    "price":
                                                        '${model.hellohomeCardProduct.price}',
                                                    "currency": "EUR"
                                                  }
                                                ]
                                              }
                                            }
                                          ],
                                          note:
                                              "Contact us for any questions on your order.",
                                          onSuccess: (Map params) async {
                                            debugPrint("onSuccess: $params");
                                            await _purchaseCard(model, params);
                                          },
                                          onError: (error) {
                                            debugPrint("onError: $error");
                                            Navigator.pop(context);
                                          },
                                          onCancel: () {
                                            debugPrint('cancelled:');
                                          },
                                        ),
                                      ));
                                    }
                                  } else {
                                    Clipboard.setData(ClipboardData(
                                            text: model
                                                .purchaseCardList[0].cardCode??''))
                                        .then((_) {
                                      final snackBar = SnackBar(
                                          backgroundColor:
                                              ConstColors.primaryColor,
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            "Code copied to clipboard",
                                            style: TextStyle(
                                                fontSize: 14, height: 1.4),
                                          ));

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    });
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ConstColors.primaryColor),
                                    color: model.isLoadingPurchaseCard ||
                                            _easyLoadingStatus ==
                                                EasyLoadingStatus.show
                                        ? ConstColors.primaryColor
                                        : _easyLoadingStatus ==
                                                    EasyLoadingStatus.dismiss &&
                                                !model.isLoadingPurchaseCard &&
                                                model.purchaseCardList.length ==
                                                    0
                                            ? ConstColors.whiteFontColor
                                            : ConstColors.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        model.isLoadingPurchaseCard ||
                                                !model.isLoadingPurchaseCard &&
                                                    model.purchaseCardList
                                                            .length ==
                                                        0
                                            ? 'assets/icons/Business/cart.svg'
                                            : 'assets/icons/Communication/postcard.svg', //icon cart
                                        height: 30,
                                        // color: Colors.white54,
                                        color: model.isLoadingPurchaseCard ||
                                                _easyLoadingStatus ==
                                                    EasyLoadingStatus.show
                                            ? ConstColors.whiteFontColor
                                            : _easyLoadingStatus ==
                                                        EasyLoadingStatus
                                                            .dismiss &&
                                                    !model
                                                        .isLoadingPurchaseCard &&
                                                    model.purchaseCardList
                                                            .length ==
                                                        0
                                                ? ConstColors.primaryColor
                                                : ConstColors.whiteFontColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        model.isLoadingPurchaseCard ||
                                                !model.isLoadingPurchaseCard &&
                                                    model.purchaseCardList
                                                            .length ==
                                                        0
                                            ? "ACHETER"
                                            : "${model.purchaseCardList[0].cardCode}",
                                        style: pSemiBold18.copyWith(
                                          fontSize: 16,
                                          color: model.isLoadingPurchaseCard ||
                                                  _easyLoadingStatus ==
                                                      EasyLoadingStatus.show
                                              ? ConstColors.whiteFontColor
                                              : _easyLoadingStatus ==
                                                          EasyLoadingStatus
                                                              .dismiss &&
                                                      !model
                                                          .isLoadingPurchaseCard &&
                                                      model.purchaseCardList
                                                              .length ==
                                                          0
                                                  ? ConstColors.primaryColor
                                                  : ConstColors.whiteFontColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
      );
    });
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
                  // const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Transaction Success",
                      style: pSemiBold18.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Votre carte arrive dans quelques jours, il vous suffira de l'activer dans l'application. Merci",
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

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             PurchaseCardPage(widget.model)));
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
            padding: EdgeInsets.only(top: (Get.width / 2) - 5),
            child: CircleAvatar(
              backgroundColor: Colors.green,
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
}
