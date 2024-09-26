import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? image;
  final bool? obscureText, enabled;
  final Function? obscureFunction;

  const CustomTextField(
      {Key? key,
      this.controller,
      this.inputType,
      this.hintText,
      this.obscureText = false,
      this.enabled = true,
      this.image,
      this.labelText,
      this.obscureFunction})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            labelText!,
            style: pRegular14.copyWith(
              fontSize: 14,
              color: ConstColors.text2Color,
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: TextFormField(
            onFieldSubmitted: (v) {
              FocusScope.of(context).nextFocus();
            },
            textAlign: TextAlign.left,
            autofocus: false,
            autocorrect: true,
            enabled: enabled,
            maxLines: 1,
            obscureText: obscureText!,
            textInputAction: TextInputAction.next,
            style: pSemiBold18.copyWith(
                fontSize: 16,
                color: enabled!
                    ? ConstColors.textColor
                    : ConstColors.text2Color.withOpacity(0.5)),
            keyboardType: inputType,
            controller: controller,
            cursorColor: ConstColors.primaryColor,
            decoration: InputDecoration(
              prefixIcon: hintText == "Email" ||
                      hintText == "Password" ||
                      hintText == "Nom"
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, right: 0, bottom: 18),
                      child: SvgPicture.asset(
                        hintText == "Password"
                            ? 'assets/icons/Interface and Sign/key.svg'
                            : image!,
                        color: ConstColors.text2Color,
                      ),
                    )
                  : null,
              suffixIcon: image! == "" ||
                      hintText == "Email" ||
                      hintText == "Nom" ||
                      labelText == "EMAIL" ||
                      labelText == "Tel :"
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () => obscureFunction!(obscureText),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12, left: 12, bottom: 12),
                        child: SvgPicture.asset(
                          image!,
                          // color: ConstColors.primaryColor,
                        ),
                      )),
              // : const SizedBox(),
              fillColor: const Color(0xffFBFBFB),
              filled: true,
              contentPadding: const EdgeInsets.only(
                  left: 10, top: 16, bottom: 16, right: 10),
              isDense: true,
              hintText: hintText,
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
        ),
      ],
    );
  }
}
