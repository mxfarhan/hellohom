import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
//import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/controller/client_token_generator.dart';
import 'package:foodly/model/subscription.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:foodly/config/text_style.dart';
import 'package:intl/intl.dart';
import 'package:foodly/config/default_image.dart';
//import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:get/get.dart';
import 'package:foodly/model/product.dart';
import 'package:purchases_flutter/models/price_wrapper.dart';
//import 'package:pay/pay.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
//import 'package:pay/pay.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  final MainModel model;

  SubscriptionPlanScreen(this.model);

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  Timer? _timer;
  late Product _selectSubscriptionPlan = Product();
  EasyLoadingStatus? _easyLoadingStatus;

  @override
  void initState() {
    super.initState();
    //_loadApplePayConfiguration(widget.model);
    setupSubscriptionListener(widget.model);
    _fetchProducts();

    loadData();
  }

  Future<void> setupSubscriptionListener(MainModel model) async {
    if (model.user.accumulatedExpired == 0 ||
        model.user.accumulatedExpired == null) {
      // Add listener to track subscription updates
      Purchases.addCustomerInfoUpdateListener((purchaserInfo) async {
        // Check if the user has an active subscription
        if (purchaserInfo.entitlements.all["HH313"]?.isActive == true) {
          // User successfully subscribed
          if (kDebugMode) {
            print('User has an active subscription.');
          }

          // Call your backend subscription logic here
          await _subscribePlanIOS(model);
        }
      });
    } else {
      if (kDebugMode) {
        print("failed to upload data after purchase");
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    widget.model.clearMyPurchaseCards();
    EasyLoading.removeAllCallbacks();
  }

  /// payment configuration for applePay
  //PaymentConfiguration? _paymentConfiguration;

  // Future<void> _loadApplePayConfiguration() async {
  //   try {
  //     // Load the JSON configuration from assets
  //     String jsonApplePayString = await rootBundle.loadString('assets/apple_pay.json');
  //     setState(() {
  //       _paymentConfiguration = PaymentConfiguration.fromJsonString(jsonApplePayString);
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error loading Apple Pay configuration: $e');
  //     }
  //   }
  // }

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
      var responseData = await widget.model.fetchSubscriptionPlanProducts();
      if (responseData.statusCode == 200) {
        if (kDebugMode) {
          print("Response subs plan product: $responseData");
        }
        //
        var responseProduct =
            await widget.model.fetchSubscriptions(widget.model);
        if (responseProduct['message'] == 'true') {
          if (kDebugMode) {
            print("Response my subs: $responseProduct");
          }

          _timer?.cancel();
          await EasyLoading.dismiss();
        } else {
          //
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

  Future _subscribePlan(MainModel model, Map paymentData) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);
    try {
      var data = {
        'products_id': _selectSubscriptionPlan.id,
        'start_date': '${DateTime.now()}',
        'expired_date':
            '${DateTime.now().add(Duration(days: _selectSubscriptionPlan.period!))}',
        'payment_id': model.user.name,
        'payment_method': paymentData['data']['payer']['payment_method']
            .toString()
            .toUpperCase(),
        'status': "SUCCESS",
        'price': _selectSubscriptionPlan.price!,
        'users_id': model.user.id!,
      };

      var responseDataSubs = await model.subscriptionPlan(data);
      if (responseDataSubs["message"] == 'true') {
        if (kDebugMode) {
          print("Response subs plan: $responseDataSubs");
        }

        var formData = {
          'name': model.nama,
          'email': model.user.email,
          'accumulated_expired': model.user.accumulatedExpired == null ||
                  model.user.accumulatedExpired == ""
              ? "${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: _selectSubscriptionPlan.period!)))}"
              : "${DateFormat('yyyy-MM-dd').format(DateTime.parse(model.user.accumulatedExpired!).add(Duration(days: _selectSubscriptionPlan.period!)))}",
        };

        var responseData = await model.editProfile(formData);
        if (responseData["data"] != null) {
          if (kDebugMode) {
            print("Response edit profile: $responseData");
          }

          var responseProduct = await model.fetchSubscriptions(model);

          //
          if (responseProduct['message'] == 'true') {
            if (kDebugMode) {
              print("Response my subs: $responseProduct");
            }

            _timer?.cancel();
            await EasyLoading.dismiss();
            //
            _showSuccessDialog();
            //
            setState(() {
              _selectSubscriptionPlan = Product();
            });
            //
          } else {
            //
            _timer?.cancel();
            await EasyLoading.dismiss();
            //
          }
        } else {
          //
          _timer?.cancel();
          await EasyLoading.dismiss();
          //
        }
      } else {
        if (kDebugMode) {
          print("Unathorized");
        }
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              model.message,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
      // });
    } catch (e) {
      //
      _timer?.cancel();
      await EasyLoading.dismiss();
      //
      print("Unathorized");
    }
  }

  Future _subscribePlanIOS(MainModel model) async {
    _timer?.cancel();
    await EasyLoading.show(maskType: EasyLoadingMaskType.custom);
    try {
      var data = {
        'products_id': _selectSubscriptionPlan.id,
        'start_date': '${DateTime.now()}',
        'expired_date': '${DateTime.now().add(const Duration(days: 365))}',
        'payment_id': model.user.name,
        'payment_method': 'In App Subscription',
        'status': "SUCCESS",
        'email': model.user.email,
        'price': _products[0].price.toInt().toStringAsFixed(2),
        'users_id': model.user.id!,
      };

      var responseDataSubs = await model.subscriptionPlan(data);
      if (responseDataSubs["message"] == 'true') {
        if (kDebugMode) {
          print("Response subs plan: $responseDataSubs");
        }

        var formData = {
          'name': model.nama,
          'email': model.user.email,
          'accumulated_expired': model.user.accumulatedExpired == null ||
                  model.user.accumulatedExpired == ""
              ? "${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 365)))}"
              : "${DateFormat('yyyy-MM-dd').format(DateTime.parse(model.user.accumulatedExpired!).add(Duration(days: 365)))}",
        };

        var responseData = await model.editProfile(formData);
        if (responseData["data"] != null) {
          if (kDebugMode) {
            print("Response edit profile: $responseData");
          }

          var responseProduct = await model.fetchSubscriptions(model);

          //
          if (responseProduct['message'] == 'true') {
            if (kDebugMode) {
              print("Response my subs: $responseProduct");
            }

            _timer?.cancel();
            await EasyLoading.dismiss();
            //
            _showSuccessDialog();
            //
            setState(() {
              _selectSubscriptionPlan = Product();
            });
            //
          } else {
            //
            _timer?.cancel();
            await EasyLoading.dismiss();
            //
          }
        } else {
          //
          _timer?.cancel();
          await EasyLoading.dismiss();
          //
        }
      } else {
        if (kDebugMode) {
          print("Unauthorized");
        }
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              model.message,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        _timer?.cancel();
        await EasyLoading.dismiss();
      }
      // });
    } catch (e) {
      //
      _timer?.cancel();
      await EasyLoading.dismiss();
      //
      if (kDebugMode) {
        print("Unauthorized");
      }
    }
  }

  ///fetch products
  List<StoreProduct> _products = [];
  Future<void> _fetchProducts() async {
    try {
      List<StoreProduct> products = await Purchases.getProducts(['HH313']);
      setState(() {
        _products = products; // Set the fetched products to the _products list
      });
      print('test price: ${_products[0].price}');
    } catch (e) {
      setState(() {
        subscriptionStatus = 'Failed to fetch products: $e';
      });
    }
  }

  bool isPurchasing = false; // Flag to track purchase status

  Future<void> makePurchase(MainModel model) async {
    if (isPurchasing) return; // Prevent multiple purchase attempts

    setState(() {
      isPurchasing = true; // Set flag when starting the purchase
    });

    await EasyLoading.show(
        status: 'Processing purchase...',
        maskType: EasyLoadingMaskType.custom); // Show loading spinner

    try {
      if (_products.isNotEmpty) {
        // Proceed with the purchase of the first product
        print('testhere');
        await Purchases.purchaseProduct(_products[0].identifier);

        // Check if the purchase was successful
        if (model.user.accumulatedExpired == 0 ||
            model.user.accumulatedExpired == null) {
          setState(() async {
            subscriptionStatus = 'Subscription purchased successfully!';
          });
        }
      }
    } catch (e) {
      // Handle errors during the purchase flow
      setState(() {
        subscriptionStatus = 'Purchase failed: $e';
      });
    } finally {
      await EasyLoading.dismiss(); // Dismiss the loading spinner
      setState(() {
        isPurchasing = false; // Reset the flag after purchase process
      });
    }
  }

  bool isLoading = false;
  String subscriptionStatus = '';

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
            "Abonnement",
            style: pSemiBold20.copyWith(),
          ),
        ),
        body: model.isLoadingProduct ||
                model.isLoadingSubscription ||
                _easyLoadingStatus == EasyLoadingStatus.show
            ? const SizedBox()
            : _easyLoadingStatus == EasyLoadingStatus.dismiss &&
                    !model.isLoadingProduct &&
                    !model.isLoadingSubscription &&
                    model.subscriptionList.length == 0
                ? _buildPlaceholderBuyCard(model)
                : _easyLoadingStatus == EasyLoadingStatus.dismiss &&
                        !model.isLoadingProduct &&
                        !model.isLoadingSubscription &&
                        model.subscriptionList.isNotEmpty
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      ConstColors.primaryColor,
                                      ConstColors.primaryColor.withOpacity(0.7),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    // begin:
                                    //     Alignment.topLeft, //begin of the gradient color
                                    // end: Alignment
                                    //     .bottomRight, //end of the gradient color
                                    // stops: [0, 0.2, 0.5, 0.8]
                                  ), //stop),
                                  // color: ConstColors.primaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 220,
                              padding: EdgeInsets.only(top: 15, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/Personal/crown.svg',
                                        height: 60,
                                        color: ConstColors.whiteFontColor,
                                      ),
                                      SizedBox(height: 7),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Votre Plan",
                                            style: pRegular14.copyWith(
                                              fontSize: 12,
                                              color: ConstColors.whiteFontColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        model.user.jumlahHariExpired == null ||
                                                model.user.jumlahHariExpired ==
                                                    0
                                            ? "0 Jours Restant"
                                            : "${model.user.jumlahHariExpired} Jours Restant",
                                        style: pSemiBold20.copyWith(
                                          fontSize: 26,
                                          color: ConstColors.whiteFontColor,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      // Text(
                                      //   "subsciption left!",
                                      //   style: pRegular14.copyWith(
                                      //     fontSize: 14,
                                      //     color: ConstColors.whiteFontColor,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        model.user.accumulatedExpired == null &&
                                                    model.user
                                                            .jumlahHariExpired ==
                                                        null ||
                                                model.user.jumlahHariExpired ==
                                                    0
                                            ? "Choisir un plan d'abonnement"
                                            : "Votre plan expirera le\n${DateFormat('MMMM dd, yyyy').format(DateTime.parse(model.user.accumulatedExpired!))}",
                                        textAlign: TextAlign.center,
                                        style: pRegular14.copyWith(
                                          fontSize: 13,
                                          color: ConstColors.whiteFontColor,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Historique",
                                  style: pSemiBold20.copyWith(
                                    fontSize: 20,
                                  ),
                                )),
                            SizedBox(height: 5),
                            Expanded(
                                child: ListView.builder(
                              padding:
                                  const EdgeInsets.only(top: 14, bottom: 10),
                              physics: const BouncingScrollPhysics(),
                              itemCount: model.subscriptionList.length,
                              itemBuilder: (context, i) {
                                var subs = model.subscriptionList[i];
                                //
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                          // color: ConstColors.primaryColor,
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              ConstColors
                                                                  .primaryColor,
                                                              ConstColors
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.7),
                                                            ],
                                                            begin: Alignment
                                                                .bottomCenter,
                                                            end: Alignment
                                                                .topCenter,
                                                            // begin:
                                                            //     Alignment.topLeft, //begin of the gradient color
                                                            // end: Alignment
                                                            //     .bottomRight, //end of the gradient color
                                                            // stops: [0, 0.2, 0.5, 0.8]
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/Personal/crown.svg',
                                                        // height: 10,
                                                        color: ConstColors
                                                            .whiteFontColor,
                                                      ),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Expanded(
                                                        child: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            Platform.isIOS
                                                                ? (_products[0].title)  // Provide a fallback in case title is null
                                                                : (subs.product?.name ?? 'Default Name'),
                                                            style: pSemiBold18.copyWith(
                                                                fontSize: 18,
                                                                color: ConstColors
                                                                    .primaryColor),
                                                          ),
                                                          const SizedBox(
                                                              height: 2),
                                                          Text(
                                                            "${subs.product?.description}",
                                                            style: pRegular14
                                                                .copyWith(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            "will expire on ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(subs.expiredDate!))}",
                                                            style: pRegular14
                                                                .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      Platform.isIOS
                                                          ? "€${_products[0].price.toStringAsFixed(2)}"  // Handle null price
                                                          : "€${subs.price ?? '0'}",
                                                      style:
                                                          pSemiBold18.copyWith(
                                                              fontSize: 18,
                                                              color: ConstColors
                                                                  .primaryColor),
                                                    ),
                                                  ],
                                                )),
                                            // Expanded(
                                            //   flex: 1,
                                            //   child: Container(
                                            //       alignment:
                                            //           Alignment.centerRight,
                                            //       // color: Colors.red,
                                            //       child: SvgPicture.asset(
                                            //         'assets/icons/Web and Technology/download.svg',
                                            //         height: 20,
                                            //         color:
                                            //             ConstColors.text2Color,
                                            //       )),
                                            // ),
                                          ]),
                                      Container(
                                        height: 1,
                                        margin: EdgeInsets.only(left: 60),
                                        color: Colors.grey[200],
                                      )
                                    ],
                                  ),
                                );
                              },
                            )),
                            const SizedBox(height: 14),

                            InkWell(
                              onTap: () async {
                                // await model.fetchProducts();
                                _showPicker(context, model);
                              },
                              child: Container(
                                height: 48,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ConstColors.primaryColor),
                                  color: ConstColors.whiteFontColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/Interface and Sign/unlock.svg',
                                      height: 30,
                                      // color: Colors.white54,
                                      color: ConstColors.primaryColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Prendre un abonnement",
                                      style: pSemiBold18.copyWith(
                                        fontSize: 16,
                                        color: ConstColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // CusttomButton(
                            //   color: ConstColors.primaryColor,
                            //   text: "SUBSCRIBE A NEW PLAN",
                            //   onTap: () {
                            //     // Navigator.pop(context);
                            //     _showPicker(context);
                            //   },
                            // ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      )
                    : SizedBox(),
      );
    });
  }

  void _showPicker(context, MainModel model) {
    const String tokenizationKey = 'production_8h9cg6qd_c6fsbpck5c25549n';
    showModalBottomSheet(
        backgroundColor: ConstColors.whiteFontColor,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext bc) {
          return FractionallySizedBox(
            // heightFactor: 0.58,
            heightFactor: 0.75,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 7,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)))),
                          SizedBox(height: 20),
                          Container(
                              child: Text('Choisir votre formule',
                                  style: pSemiBold20.copyWith(
                                      fontSize: 16,
                                      color: ConstColors.textColor))),
                        ]),
                  ),
                  const SizedBox(height: 30),
                  Column(
                      children: model.productList.map((e) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectSubscriptionPlan = e;
                          });
                          Navigator.of(context).pop();
                          _showPicker(context, model);
                          // _showPickerPukal(context, model);
                        },
                        child: Container(
                            height: 100,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                // border: Border.all(color: Colors.grey, width: 2),
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
                                color: _selectSubscriptionPlan == e
                                    ? ConstColors.textColor
                                    : ConstColors.primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.only(
                                left: 20, right: 10, top: 12, bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          Platform.isIOS
                                              ? (_products[0].title)  // Provide a fallback in case title is null
                                              : (e.name ?? 'Default Name'),  // Provide a fallback in case e.name is null
                                          style: pSemiBold20.copyWith(
                                            fontSize: 16,
                                            color: ConstColors.whiteFontColor,
                                          ),
                                        ),
                                        Text(
                                          Platform.isIOS
                                              ? "Prix: ${_products[0].price.toStringAsFixed(2)}€"  // Handle null price
                                              : "Prix: ${e.price ?? '0'}€",  // Handle null e.price
                                          style: pSemiBold20.copyWith(
                                            letterSpacing: 1.7,
                                            fontSize: 20,
                                            color: ConstColors.whiteFontColor,
                                          ),
                                        ),
                                        // Text(
                                        //   Platform.isIOS
                                        //       ? (_products[0].description)  // Provide fallback for null description
                                        //       : (e.description ?? 'No Description'),  // Handle null e.description
                                        //   style: pRegular14.copyWith(
                                        //     fontSize: 14,
                                        //     color: ConstColors.whiteFontColor,
                                        //   ),
                                        // ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 6,
                                              width: 6,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Durée de l'abonnement : 1 an",
                                              style: pRegular14.copyWith(
                                                fontSize: 14,
                                                color: ConstColors.whiteFontColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )


                                ),
                                Expanded(
                                    flex: 1,
                                    child: SvgPicture.asset(
                                      'assets/icons/Personal/crown.svg',
                                      height: 50,
                                      // color: Colors.white54,
                                      color: ConstColors.whiteFontColor,
                                    )),
                              ],
                            )));
                  }).toList()),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () async {
                      if (kDebugMode) {
                        print({
                          "amount": {
                            "total": _selectSubscriptionPlan.price,
                            "currency": "EUR",
                            "details": {
                              "subtotal": _selectSubscriptionPlan.price,
                              "shipping": '0',
                              "shipping_discount": 0
                            }
                          },
                          "description": "${_selectSubscriptionPlan.name}",
                          "item_list": {
                            "items": [
                              {
                                "name":
                                    "${_selectSubscriptionPlan.description} - ${_selectSubscriptionPlan.period} Period",
                                "quantity": 1,
                                "price": _selectSubscriptionPlan.price,
                                "currency": "EUR"
                              },
                            ],
                          }
                        });
                      }

                      /// for android where only paypal is used
                      if (Platform.isAndroid &&
                          _selectSubscriptionPlan.id != null) {
                        Navigator.pop(context);

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => UsePaypal(
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
                                  "total": _selectSubscriptionPlan.price,
                                  "currency": "EUR",
                                  "details": {
                                    "subtotal": _selectSubscriptionPlan.price,
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "${_selectSubscriptionPlan.name} - ${_selectSubscriptionPlan.period} Period",
                                "item_list": {
                                  "items": [


                                    {
                                      "name":
                                          "${_selectSubscriptionPlan.description}",
                                      "quantity": 1,
                                      "price": _selectSubscriptionPlan.price,
                                      "currency": "EUR"
                                    },
                                  ],
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              if (kDebugMode) {
                                print("onSuccess: $params");
                              }
                              await _subscribePlan(model, params);
                            },
                            onError: (error) {
                              if (kDebugMode) {
                                print("onError: $error");
                              }
                              Navigator.pop(context);
                            },
                            onCancel: () {
                              if (kDebugMode) {
                                print('cancelled:');
                              }
                            },
                          ),
                        ));
                      }

                      /// for IOS where only ApplePay is used
                      else if (Platform.isIOS &&
                          _selectSubscriptionPlan.id != null) {
                        if (kDebugMode) {
                          print('hanipaytest');
                        }

                        Navigator.pop(context);

                        ///making payments
                        if (kDebugMode) {
                          print('datasentinit');
                        }
                        //for debub only

                        //_subscribePlanIOS(model);
                        checkSubscriptionStatus(model);

                        //await Purchases.purchaseProduct('HH313');
                        // await Purchases.getProducts(['HH313']);
                        ///apple pay
                        //          Navigator.of(context).push(
                        //            MaterialPageRoute(
                        //              builder: (BuildContext context) => Scaffold(
                        //                appBar: AppBar(
                        //                  title: const Text('Apple Payment'),
                        //                ),
                        //                backgroundColor: Colors.white,
                        //                body: ListView(
                        //                  padding: const EdgeInsets.symmetric(horizontal: 20),
                        //                  children: [
                        //                    Text(
                        //                      _selectSubscriptionPlan.name.toString(),
                        //                      style: const TextStyle(
                        //                        fontSize: 20,
                        //                        color: Color(0xff333333),
                        //                        fontWeight: FontWeight.bold,
                        //                      ),
                        //                    ),
                        //                    const SizedBox(height: 5),
                        //                    Text(
                        //                      "\EUR ${_selectSubscriptionPlan.price.toString()}",
                        //                      style: const TextStyle(
                        //                        color: Color(0xff777777),
                        //                        fontSize: 15,
                        //                      ),
                        //                    ),
                        //                    const SizedBox(height: 15),
                        //                    Text(
                        //                      _selectSubscriptionPlan.description.toString(),
                        //                      style: const TextStyle(
                        //                        fontSize: 15,
                        //                        color: Color(0xff333333),
                        //                        fontWeight: FontWeight.bold,
                        //                      ),
                        //                    ),
                        //                    const SizedBox(height: 15),
                        //                    ApplePayButton(
                        //                      paymentConfiguration: PaymentConfiguration.fromJsonString('''
                        // {
                        //    "provider": "apple_pay",
                        //    "data": {
                        //       "merchantIdentifier": "merchant.casa.hellohome.nicesolution",
                        //       "displayName": "HelloHome",
                        //       "merchantCapabilities": ["3DS", "debit", "credit"],
                        //       "supportedNetworks": ["visa", "masterCard", "amex"],
                        //       "countryCode": "FR",
                        //       "currencyCode": "EUR"
                        //    }
                        // }
                        // '''),
                        //                      paymentItems: [
                        //                        PaymentItem(
                        //                          label: _selectSubscriptionPlan.name,
                        //                          amount: _selectSubscriptionPlan.price.toString(), // Ensure formatted correctly
                        //                        )
                        //                      ],
                        //                      style: ApplePayButtonStyle.black,
                        //                      type: ApplePayButtonType.buy,
                        //                      margin: const EdgeInsets.only(top: 15.0),
                        //                      onPaymentResult: (Map params) async {
                        //                        print("onSuccess: $params");
                        //                        await _subscribePlan(model, params);
                        //                      },
                        //                      onError: (error) {
                        //                        print("Error In Payment: ${error.toString()}");
                        //
                        //                        Get.closeCurrentSnackbar();
                        //                        Get.snackbar(
                        //                          "Payment Failed",
                        //                          error.toString(),
                        //                          snackPosition: SnackPosition.BOTTOM,
                        //                          backgroundColor: ConstColors.primaryColor.withOpacity(0.6),
                        //                          colorText: Colors.black,
                        //                          borderRadius: 10,
                        //                          margin: EdgeInsets.all(14),
                        //                          duration: const Duration(seconds: 2),
                        //                        );
                        //                      },
                        //                      loadingIndicator: const Center(
                        //                        child: CircularProgressIndicator(),
                        //                      ),
                        //                    ),
                        //                  ],
                        //                ),
                        //              ),
                        //            ),
                        //          );
                      }
                    },
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _selectSubscriptionPlan.id == null
                                ? ConstColors.text2Color
                                : ConstColors.primaryColor),
                        color: ConstColors.whiteFontColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Payer",
                          style: pSemiBold18.copyWith(
                            fontSize: 16,
                            color: _selectSubscriptionPlan.id == null
                                ? ConstColors.text2Color
                                : ConstColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Function to check if the user already has a subscription
  Future<void> checkSubscriptionStatus(MainModel model) async {
    setState(() {
      isLoading = true; // Show loading state
    });

    try {
      // Show loading spinner while fetching customer info
      await EasyLoading.show(
          status: 'Checking subscription status...',
          maskType: EasyLoadingMaskType.custom);

      // Fetch the latest customer info
      //CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      // Check if the entitlement for subscription is active
      // if (customerInfo.entitlements.all['HH313']?.isActive ?? false) {
      //   // User already has an active subscription
      //   Get.snackbar(
      //     "Already Subscribed",
      //     "You already have a subscription.",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: ConstColors.primaryColor.withOpacity(0.6),
      //     colorText: Colors.black,
      //     borderRadius: 10,
      //     margin: const EdgeInsets.all(14),
      //     duration: const Duration(seconds: 2),
      //   );
      //   if (kDebugMode) {
      //     print('User already has an active subscription.');
      //   }
      // } else
      if (model.user.accumulatedExpired == 0 ||
          model.user.accumulatedExpired == null) {
        try {
          // Show the paywall
          await RevenueCatUI.presentPaywallIfNeeded("HH313");
          //_subscribePlanIOS(model);
          await setupSubscriptionListener(model);
          {
            // The user either canceled or didn't complete the purchase
            if (kDebugMode) {
              print('Purchase was not completed.');
            }
          }
        } catch (e) {
          // Handle any unexpected errors
          if (kDebugMode) {
            print('Error occurred: $e');
          }
        }

        //final payWallResult= await RevenueCatUI.presentPaywallIfNeeded("HH313");

        // Pass the model to makePurchase if needed
      } else {
        // User has an expired subscription
        Get.snackbar(
          "Already Subscribed",
          "You already have a subscription.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ConstColors.primaryColor.withOpacity(0.6),
          colorText: Colors.black,
          borderRadius: 10,
          margin: EdgeInsets.all(14),
          duration: Duration(seconds: 2),
        );
        if (kDebugMode) {
          print('User has an expired subscription.');
        }
      }
    } catch (e) {
      // Handle error if any exception occurs
      setState(() {
        subscriptionStatus = 'Error: $e';
      });
    } finally {
      await EasyLoading.dismiss(); // Dismiss loading spinner
      setState(() {
        isLoading = false; // Reset loading state
      });
    }
  }

  // Function to initiate the purchase flow
  // Future<void> makePurchase() async {
  //   try {
  //     // Fetch available products from RevenueCat
  //     List<StoreProduct> products = await Purchases.getProducts(['HH313']);
  //     products[0].price;
  //
  //     if (products.isNotEmpty) {
  //       // Proceed with the purchase of the first product
  //       CustomerInfo customerInfo = await Purchases.purchaseProduct(products[0].identifier);
  //
  //       // Check if the purchase was successful
  //       if (customerInfo.entitlements.all['HH313']?.isActive ?? false) {
  //         setState(() {
  //           subscriptionStatus = 'Subscription purchased successfully!';
  //         });
  //       } else {
  //         setState(() {
  //           subscriptionStatus = 'Subscription purchase failed.';
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         subscriptionStatus = 'No products available.';
  //       });
  //     }
  //   } catch (e) {
  //     // Handle errors during the purchase flow
  //     setState(() {
  //       subscriptionStatus = 'Purchase failed: $e';
  //     });
  //   }
  // }

  // Future<void> makePayment() async {
  //
  //   // To store apple payment data
  //   dynamic applePaymentData;
  //
  //   // List of items with label & price
  //   List<PaymentItem> paymentItems = [
  //     PaymentItem(label: 'Label', amount: 1.00,shippingcharge: 2.00)
  //   ];
  //
  //   try {
  //     // initiate payment
  //     applePaymentData = await ApplePayFlutter.makePayment(
  //
  //       countryCode: "US",
  //       currencyCode: "SAR",
  //       paymentNetworks: [
  //         PaymentNetwork.visa,
  //         PaymentNetwork.mastercard,
  //         PaymentNetwork.amex,
  //       ],
  //       merchantIdentifier: "merchant.casa.hellohome.nicesolution",
  //       paymentItems:  paymentItems,
  //       customerEmail: "demo.user@business.com",
  //       customerName: "Demo User",
  //       companyName: "Demo Company",
  //
  //     );
  //
  //     // This logs the Apple Pay response data
  //     print(applePaymentData.toString());
  //
  //   } on PlatformException {
  //     print('Failed payment');
  //   }
  // }

  Widget _buildPlaceholderBuyCard(MainModel model) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xfff6f6f6),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 122.37,
              width: 125,
              child: SvgPicture.asset(
                'assets/icons/Personal/crown.svg',
                fit: BoxFit.fill,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Vous n'avez pas encore votre plan",
                textAlign: TextAlign.center,
                style: pSemiBold20.copyWith(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "It’s seems like you don’t have\nany subscription plan.",
                style: pRegular14.copyWith(
                  fontSize: 16,
                  height: 1.5,
                  color: ConstColors.text2Color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                _showPicker(context, model);
              },
              child: Container(
                height: 38,
                width: Get.width / 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ConstColors.primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Choisissez votre plan",
                    style: pSemiBold18.copyWith(
                      fontSize: 14,
                      color: ConstColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
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
                    "Bravo ! commencez à utiliser HelloHome.",
                    // "You've successfully subscribe ${_selectSubscriptionPlan.name} Plan. Then, you can get all features in application.",
                    style: pRegular14.copyWith(
                      fontSize: 15,
                      color: ConstColors.text2Color,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
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
              child: SvgPicture.asset('assets/icons/Personal/crown.svg',
                  height: 20, color: ConstColors.whiteFontColor),
            ),
          )
        ],
      ),
    );
  }
}
