// ignore_for_file: sized_box_for_whitespace
import 'package:scoped_model/scoped_model.dart';
import '../../services/main_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/default_image.dart';
import 'package:foodly/config/text_style.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const HomeView({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "",
                  //   style: pRegular14.copyWith(
                  //     fontSize: 16,
                  //   ),
                  // ),
                  // const Expanded(child: SizedBox()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, ${model.nama}!",
                        style: pSemiBold20.copyWith(
                          fontSize: 26,
                          color: ConstColors.textColor,
                        ),
                      ),

                      const SizedBox(height: 12),
                      Text(
                        "You've 2 pesan masuk dan 3 panggilan",
                        style: pSemiBold20.copyWith(
                          fontSize: 12,
                          color: ConstColors.text2Color,
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Indonesia",
                      //       style: pSemiBold20.copyWith(
                      //         fontSize: 22,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 5),
                      //     const Icon(
                      //       Icons.keyboard_arrow_down_outlined,
                      //       color: ConstColors.textColor,
                      //       size: 25,
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                  // const Expanded(child: SizedBox()),
                  // InkWell(
                  //   onTap: () {
                  //     widget.scaffoldKey!.currentState!.showBottomSheet(
                  //       (context) => const FilterView(),
                  //     );
                  //   },
                  //   child: Text(
                  //     "Filter",
                  //     style: pRegular14.copyWith(
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                  Container(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(DefaultImages.profile2),
                      ))
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Divider(
                  color: const Color(0xff676767).withOpacity(0.10),
                  thickness: 1,
                )),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(children: [
                SvgPicture.asset(
                  'assets/icons/Communication/bullhorn.svg',
                  height: 18,
                  color: ConstColors.primaryColor,
                ),
                SizedBox(width: 10),
                Text(
                  "You received a new message, please check!",
                  style: pRegular14.copyWith(
                    fontSize: 14,
                    color: ConstColors.text2Color,
                  ),
                ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
              // margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
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
                      height: 175,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Communication/phone.svg',
                                height: 30,
                                color: ConstColors.whiteFontColor,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Incoming Call",
                                style: pRegular14.copyWith(
                                  fontSize: 16,
                                  color: ConstColors.whiteFontColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "ACTIVE",
                                style: pRegular14.copyWith(
                                  fontSize: 12,
                                  color: ConstColors.whiteFontColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                    SizedBox(width: 20),
                    Expanded(
                        child: Container(
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
                      height: 175,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Communication/popup.svg',
                                height: 30,
                                color: ConstColors.whiteFontColor,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Message",
                                style: pRegular14.copyWith(
                                  fontSize: 16,
                                  color: ConstColors.whiteFontColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "ACTIVE",
                                style: pRegular14.copyWith(
                                  fontSize: 12,
                                  color: ConstColors.whiteFontColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                        child: Container(
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
                      height: 175,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Communication/phone.svg',
                                height: 30,
                                color: ConstColors.whiteFontColor,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Incoming Call",
                                style: pRegular14.copyWith(
                                  fontSize: 16,
                                  color: ConstColors.whiteFontColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "ACTIVE",
                                style: pRegular14.copyWith(
                                  fontSize: 12,
                                  color: ConstColors.whiteFontColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                    SizedBox(width: 20),
                    Expanded(
                        child: Container(
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
                      height: 175,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Communication/phone.svg',
                                height: 30,
                                color: ConstColors.whiteFontColor,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.red),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Incoming Call",
                                style: pRegular14.copyWith(
                                  fontSize: 16,
                                  color: ConstColors.whiteFontColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "ACTIVE",
                                style: pRegular14.copyWith(
                                  fontSize: 12,
                                  color: ConstColors.whiteFontColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                )
              ]),
            )
            // Expanded(
            //   child: ListView(
            //     physics: const ClampingScrollPhysics(),
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             SizedBox(
            //               height: 200,
            //               child: Swiper(
            //                 autoplay: true,
            //                 pagination: const SwiperPagination(
            //                   alignment: Alignment.bottomRight,
            //                   margin: EdgeInsets.only(
            //                     right: 30,
            //                     bottom: 20,
            //                   ),
            //                   builder: SwiperPagination.dots,
            //                 ),
            //                 itemCount: homeController.swiperImage.length,
            //                 indicatorLayout: PageIndicatorLayout.SCALE,
            //                 layout: SwiperLayout.DEFAULT,
            //                 itemHeight: 200,
            //                 itemWidth: Get.width,
            //                 itemBuilder: (BuildContext context, int index) => Container(
            //                   height: 200,
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     image: DecorationImage(
            //                       image: AssetImage(homeController.swiperImage[index]),
            //                       fit: BoxFit.fill,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 18),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   "Our Partners",
            //                   // "Featured Partners",
            //                   style: pSemiBold20.copyWith(fontSize: 24),
            //                 ),
            //                 InkWell(
            //                   onTap: () {
            //                     Get.to(
            //                       const FeaturedPartnerScreen(),
            //                       transition: Transition.rightToLeft,
            //                     );
            //                   },
            //                   child: Text(
            //                     "See all",
            //                     style: pSemiBold18.copyWith(
            //                       fontSize: 16,
            //                       color: ConstColors.primaryColor,
            //                     ),
            //                   ),
            //                 )
            //               ],
            //             ),
            //             const SizedBox(height: 18),
            //             SizedBox(
            //               height: 250,
            //               child: ListView.builder(
            //                 physics: const ClampingScrollPhysics(),
            //                 itemCount: homeController.featuredList.length,
            //                 scrollDirection: Axis.horizontal,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   return Padding(
            //                     padding: const EdgeInsets.only(right: 15),
            //                     child: HomeCard(
            //                       title: homeController.featuredList[index].title,
            //                       image: homeController.featuredList[index].image,
            //                     ),
            //                   );
            //                 },
            //               ),
            //             ),
            //             const SizedBox(height: 18),
            //             SizedBox(
            //               height: 180,
            //               width: Get.width,
            //               child: SvgPicture.asset(
            //                 DefaultImages.h6,
            //                 fit: BoxFit.fill,
            //               ),
            //             ),
            //             // const SizedBox(height: 18),
            //             // Row(
            //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             //   children: [
            //             //     Text(
            //             //       "Best Picks\nRestaurants by team",
            //             //       style: pSemiBold20.copyWith(fontSize: 24, height: 1.3),
            //             //     ),
            //             //     Text(
            //             //       "See all",
            //             //       style: pSemiBold18.copyWith(
            //             //         fontSize: 16,
            //             //         color: ConstColors.primaryColor,
            //             //       ),
            //             //     )
            //             //   ],
            //             // ),
            //             // const SizedBox(height: 24),
            //             // SizedBox(
            //             //   height: 250,
            //             //   child: ListView.builder(
            //             //     physics: const ClampingScrollPhysics(),
            //             //     itemCount: homeController.pickList.length,
            //             //     scrollDirection: Axis.horizontal,
            //             //     itemBuilder: (BuildContext context, int index) {
            //             //       return Padding(
            //             //         padding: const EdgeInsets.only(right: 15),
            //             //         child: HomeCard(
            //             //           title: homeController.pickList[index].title,
            //             //           image: homeController.pickList[index].image,
            //             //         ),
            //             //       );
            //             //     },
            //             //   ),
            //             // ),
            //             // const SizedBox(height: 18),
            //             // Row(
            //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             //   children: [
            //             //     Text(
            //             //       "All Restaurants",
            //             //       style: pSemiBold20.copyWith(fontSize: 24, height: 1.3),
            //             //     ),
            //             //     Text(
            //             //       "See all",
            //             //       style: pSemiBold18.copyWith(
            //             //         fontSize: 16,
            //             //         color: ConstColors.primaryColor,
            //             //       ),
            //             //     )
            //             //   ],
            //             // ),
            //             // const SizedBox(height: 18),
            //             // Column(
            //             //   crossAxisAlignment: CrossAxisAlignment.start,
            //             //   children: [
            //             //     for (var i = 0; i < homeController.restaurantList.length; i++)
            //             //       Padding(
            //             //         padding: const EdgeInsets.only(bottom: 20),
            //             //         child: RestaurantCard(
            //             //           title: homeController.restaurantList[i].title,
            //             //           image: homeController.restaurantList[i].image,
            //             //         ),
            //             //       )
            //             //   ],
            //             // ),
            //             // const SizedBox(height: 18),
            //             // SizedBox(
            //             //   height: 185,
            //             //   width: Get.width,
            //             //   child: Swiper(
            //             //     itemCount: 3,
            //             //     itemHeight: 185,
            //             //     scale: 0.5,
            //             //     itemBuilder: (BuildContext context, int index) {
            //             //       return Padding(
            //             //         padding: const EdgeInsets.only(right: 10),
            //             //         child: SizedBox(
            //             //           height: 185,
            //             //           child: ClipRRect(
            //             //             borderRadius: BorderRadius.circular(15),
            //             //             child: Image.asset(
            //             //               DefaultImages.h7,
            //             //               fit: BoxFit.fill,
            //             //             ),
            //             //           ),
            //             //         ),
            //             //       );
            //             //     },
            //             //   ),
            //             // ),
            //                const SizedBox(height: 18),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   "Type of Foods",
            //                   style: pSemiBold20.copyWith(fontSize: 24, height: 1.3),
            //                 ),
            //                InkWell(
            //                   onTap: () {
            //                     Get.to(
            //                       const CategoryScreen(),
            //                       transition: Transition.rightToLeft,
            //                     );
            //                   },
            //                   child:       Text(
            //                   "See all",
            //                   style: pSemiBold18.copyWith(
            //                     fontSize: 16,
            //                     color: ConstColors.primaryColor,
            //                   ),
            //                 ))
            //               ],
            //             ),
            //             const SizedBox(height: 18),
            //             Container(
            //               height: 150,
            //               child: ListView.builder(
            //                 physics: const ClampingScrollPhysics(),
            //                 scrollDirection: Axis.horizontal,
            //                 itemCount: homeController.typeList.length,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   return TypeCard(
            //                     title: homeController.typeList[index].title,
            //                     image: homeController.typeList[index].image,
            //                   );
            //                 },
            //               ),
            //             ),
            //             const SizedBox(height: 18),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   "Greatest Foods",
            //                   style: pSemiBold20.copyWith(fontSize: 24, height: 1.3),
            //                 ),
            //                 InkWell(
            //                   onTap: () {
            //                     Get.to(
            //                       const BrowseFoodScreen(),
            //                       transition: Transition.rightToLeft,
            //                     );
            //                   },
            //                   child:  Text(
            //                   "See all",
            //                   style: pSemiBold18.copyWith(
            //                     fontSize: 16,
            //                     color: ConstColors.primaryColor,
            //                   ),
            //                 ))
            //               ],
            //             ),
            //             // const SizedBox(height: 24),
            //             Row(
            //               children: [
            //                 Expanded(
            //                   child: Column(
            //                     children: [
            //                       for (var index = 0; index < homeController.nationalList.length; index++)
            //                         Padding(
            //                           padding: const EdgeInsets.only(bottom: 15),
            //                           child: NationalFavorite(
            //                             title: homeController.nationalList[index].title,
            //                             image: homeController.nationalList[index].image,
            //                             height: 240,
            //                           ),
            //                         ),
            //                     ],
            //                   ),
            //                 ),
            //                 const SizedBox(width: 15),
            //                 Expanded(
            //                   child: Padding(
            //                     padding: const EdgeInsets.only(top: 10),
            //                     child: Column(
            //                       children: [
            //                         for (var index = 0; index < homeController.national1List.length; index++)
            //                           Padding(
            //                             padding: const EdgeInsets.only(bottom: 15),
            //                             child: NationalFavorite(
            //                               title: homeController.national1List[index].title,
            //                               image: homeController.national1List[index].image,
            //                               height: 260,
            //                             ),
            //                           ),
            //                       ],
            //                     ),
            //                   ),
            //                 )
            //               ],
            //             ),

            //             const SizedBox(height: 18),
            //             // Row(
            //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             //   children: [
            //             //     Text(
            //             //       "New Restaurants",
            //             //       style: pSemiBold20.copyWith(fontSize: 24, height: 1.3),
            //             //     ),
            //             //     Text(
            //             //       "See all",
            //             //       style: pSemiBold18.copyWith(
            //             //         fontSize: 16,
            //             //         color: ConstColors.primaryColor,
            //             //       ),
            //             //     )
            //             //   ],
            //             // ),
            //             // const SizedBox(height: 18),
            //             // Container(
            //             //   height: 220,
            //             //   child: ListView.builder(
            //             //     physics: const ClampingScrollPhysics(),
            //             //     scrollDirection: Axis.horizontal,
            //             //     itemCount: homeController.newRestaurantList.length,
            //             //     itemBuilder: (BuildContext context, int index) {
            //             //       return RestaurantContainer(
            //             //         title: homeController.newRestaurantList[index].title,
            //             //         image: homeController.newRestaurantList[index].image,
            //             //       );
            //             //     },
            //             //   ),
            //             // ),
            //             SizedBox(height: MediaQuery.of(context).padding.bottom + 70),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
