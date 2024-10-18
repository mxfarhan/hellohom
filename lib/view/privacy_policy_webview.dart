import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import '../services/main_model.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';

class PrivacyPolicyWebview extends StatefulWidget {
  @override
  _PrivacyPolicyWebviewState createState() => _PrivacyPolicyWebviewState();
}

class _PrivacyPolicyWebviewState extends State<PrivacyPolicyWebview> {
  late WebViewController controller;
  String initialUrl = 'https://hellohome.casa/conditions-generales/';

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            EasyLoading.show(status: 'Loading...'); // Show loading spinner
          },
          onPageFinished: (String url) {
            EasyLoading.dismiss(); // Dismiss loading spinner
          },
          onWebResourceError: (WebResourceError error) {
            EasyLoading.showError('Failed to load the page.'); // Error message
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });
  }

  void _showDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Select an Option"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                _loadUrl('https://hellohome.casa/rgpd/');
                Navigator.of(context).pop();
              },
              child: const Text("Privacy Policy"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                _loadUrl('https://hellohome.casa/conditions-generales/');
                Navigator.of(context).pop();
              },
              child: const Text("Terms of Use (EULA)"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                _loadUrl('https://hellohome.casa/mentions-legales/');
                Navigator.of(context).pop();
              },
              child: const Text("Licenses"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _loadUrl(String url) {
    controller.loadRequest(Uri.parse(url));
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
            "À propos de cette application",
            style: pSemiBold20.copyWith(),
          ),
        ),
        body: WebViewWidget(controller: controller),
      );
    });
  }
}
