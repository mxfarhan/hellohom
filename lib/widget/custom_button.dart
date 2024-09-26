import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';

class CusttomButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final VoidCallback? onTap;

  const CusttomButton({Key? key, this.text, this.onTap, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 48,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: color!,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text!,
            style: pSemiBold18.copyWith(
              fontSize: 16,
              color: ConstColors.whiteFontColor,
            ),
          ),
        ),
      ),
    );
  }
}
