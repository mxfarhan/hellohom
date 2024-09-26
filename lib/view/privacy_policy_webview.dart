// import 'dart:async';
// import 'package:scoped_model/scoped_model.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../services/main_model.dart';
// import 'package:foodly/config/colors.dart';
// import 'package:foodly/config/text_style.dart';
//
// class PrivacyPolicyWebview extends StatefulWidget {
//   @override
//   _PrivacyPolicyWebviewState createState() => _PrivacyPolicyWebviewState();
// }
//
// class _PrivacyPolicyWebviewState extends State<PrivacyPolicyWebview> {
//   var controller =
//       WebViewController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setBackgroundColor(const Color(0x00000000))
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onWebResourceError: (WebResourceError error) {},
//       onNavigationRequest: (NavigationRequest request) {
//         if (request.url.startsWith('https://hellohome.casa/conditions-generales/')) {
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     ),
//   )
//   ..loadRequest(Uri.parse('https://hellohome.casa/conditions-generales/'));
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
//       return Scaffold(
//           backgroundColor: ConstColors.whiteFontColor,
//           appBar: AppBar(
//             centerTitle: true,
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             leading: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const Icon(
//                 Icons.arrow_back_ios,
//                 color: ConstColors.textColor,
//                 size: 20,
//               ),
//             ),
//             title: Text(
//               "Conditions d’utilisations",
//               style: pSemiBold20.copyWith(),
//             ),
//           ),
//           body: WebViewWidget(controller: controller),);
//     });
//   }
//
//   Widget _buildActions(MainModel model) {
//     return Container(
//       margin: EdgeInsets.only(left: 8, right: 5, top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Image.asset('assets/bestari.png', height: 50),
//               Container(
//                   child: Text("Bestari",
//                       style: TextStyle(fontSize: 25, color: Colors.red)))
//             ],
//           ),
//           GestureDetector(
//               onTap: () {
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //         builder: (BuildContext context) =>
//                 //             NotificationsPage(model)));
//               },
//               child: Container(
//                   margin: EdgeInsets.only(),
//                   alignment: Alignment.centerRight,
//                   // margin: EdgeInsets.all(12),
//                   child: Icon(Icons.more_vert, size: 35, color: Colors.red)))
//         ],
//       ),
//     );
//   }
//
// }
