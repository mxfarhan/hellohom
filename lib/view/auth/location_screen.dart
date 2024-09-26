import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/default_image.dart';
import 'package:foodly/config/text_style.dart';
import 'package:get/get.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.whiteFontColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: ConstColors.textColor,
            size: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Find best foods near you",
                  style: pSemiBold20.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "Please enter your location or allow access to\nyour location to find foods near you.",
                  style: pRegular14.copyWith(
                    fontSize: 16,
                    color: ConstColors.text2Color,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ConstColors.primaryColor,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      DefaultImages.location,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Use current location",
                      style: pRegular14.copyWith(
                        fontSize: 16,
                        color: ConstColors.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: pSemiBold18.copyWith(fontSize: 16),
                cursorColor: ConstColors.primaryColor,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.location_pin,
                    color: ConstColors.primaryColor,
                  ),
                  fillColor: const Color(0xffFBFBFB),
                  filled: true,
                  contentPadding: const EdgeInsets.only(
                      left: 10, top: 16, bottom: 16, right: 10),
                  isDense: true,
                  hintText: "Enter a new address",
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
              const SizedBox(height: 18),
              Expanded(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        // Get.offAll(
                        //   const TabScreen(),
                        //   transition: Transition.rightToLeft,
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    DefaultImages.location,
                                    color: ConstColors.primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "San Francisco",
                                        style: pRegular14.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "California",
                                        style: pRegular14.copyWith(
                                          fontSize: 13,
                                          color: ConstColors.text2Color,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              color: ConstColors.text2Color.withOpacity(0.1),
                              thickness: 1,
                              indent: 35,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
