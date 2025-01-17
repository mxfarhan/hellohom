// ignore_for_file: must_be_immutable

library flutter_easy_faq;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EasyFaq extends StatefulWidget {
  final String question;
  final String answer;
  TextStyle? questionTextStyle;
  TextStyle? anserTextStyle;
  Duration? duration = const Duration(milliseconds: 100);
  Widget? expandedIcon;
  Widget? collapsedIcon;
  Color? backgroundColor;
  BorderRadiusGeometry? borderRadius;
  EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );

  EasyFaq({
    super.key,
    required this.question,
    required this.answer,
    this.questionTextStyle,
    this.anserTextStyle,
    this.expandedIcon,
    this.collapsedIcon,
    this.duration,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  @override
  State<EasyFaq> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<EasyFaq> with TickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedSize(
        duration: widget.duration ??
            (isExpanded
                ? const Duration(milliseconds: 100)
                : const Duration(milliseconds: 50)),
        child: Card(
          margin: EdgeInsets.zero,
          color: widget.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          ),
          child: Container(
            padding: widget.padding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: widget.questionTextStyle ??
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                      ),
                    ),
                    if (isExpanded)
                      widget.expandedIcon ??
                          const Icon(
                            Icons.remove,
                            color: Colors.red,
                          )
                    else
                      widget.collapsedIcon ??
                          const Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 10),
                  Text(
                    widget.answer,
                    style: widget.anserTextStyle ??
                        Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 13,
                            ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SnackbarController extends GetxController {
  static SnackbarController get instance => Get.find();
  // Function to show a GetX snackbar
  void showGetSnackbar(String title,String message) {
    Get.snackbar(
      title,                       // Title
      message,                               // Message
      snackPosition: SnackPosition.BOTTOM,   // Position
      duration: Duration(seconds: 3),        // Duration of the snackbar
      backgroundColor: Colors.redAccent,     // Background color
      colorText: Colors.white,               // Text color
      margin: EdgeInsets.all(10),            // Margin around snackbar
      borderRadius: 8,                       // Rounded corners
    );
  }
}
