// ignore_for_file: prefer_const_constructors
import 'package:foodly/firebase_options.dart';
import 'package:foodly/view/home/home_view.dart';
import 'package:foodly/view/search/search_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:purchases_flutter/models/purchases_configuration.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import './services/main_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';
import './services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodly/view/onboarding_screen.dart';
import 'package:get/get.dart';

final _configuration=PurchasesConfiguration('appl_vqOYsKidsTqpCaPtJsLsoEPgkDW');

void main() async {

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.white,
  //     statusBarBrightness: Brightness.dark,
  //     systemNavigationBarColor: Colors.white,
  //     statusBarIconBrightness: Brightness.dark,
  //   ),
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Purchases.configure(_configuration);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  await FirebaseService().initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) {
      runApp(MyApp());
      configLoading();
    },
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 5)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 75.0
    ..radius = 10.0
    ..progressColor = Colors.blue
    ..indicatorColor = Colors.blue
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          MainModel model = MainModel();
          return ScopedModel(
            model: model,
            child: GetMaterialApp(
              navigatorKey: navigatorKey,
              title: "HelloHome",
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: const MaterialColor(
                  0xff193566,
                  <int, Color>{
                    50: Color(0xff22A45D),
                    100: Color(0xff22A45D),
                    200: Color(0xff22A45D),
                    300: Color(0xff22A45D),
                    400: Color(0xff22A45D),
                    500: Color(0xff22A45D),
                    600: Color(0xff22A45D),
                    700: Color(0xff22A45D),
                    800: Color(0xff22A45D),
                    900: Color(0xff22A45D),
                  },
                ),
              ),
              builder: EasyLoading.init(),
              routes: {
                '/home': (BuildContext context) => SearchView(model),
                '/onboard': (BuildContext context) => OnboardingScreen(model)
              },
              home: OnboardingScreen(model),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
