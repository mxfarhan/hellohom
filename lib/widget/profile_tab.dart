import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';

class ProfileTab extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? image;
  final VoidCallback? ontap;
  const ProfileTab(
      {Key? key, this.title, this.subTitle, this.image, this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ontap!();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 72,
            child: Row(
              children: [
                SizedBox(
                  height: image!.contains("star-fill.svg") ? 24 : 30,
                  width: image!.contains("star-fill.svg") ? 24 : 30,
                  child: SvgPicture.asset(
                    image!,
                    fit: BoxFit.fill,
                    color: image!.contains("star-fill.svg") ||
                            image!.contains("crown.svg") ||
                            image!.contains("users.svg") ||
                            image!.contains("postcard.svg")
                        ? ConstColors.primaryColor
                        : image!.contains("unlock.svg")||image!.contains("deluser.svg")
                            ? Colors.redAccent
                            : ConstColors.textColor,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: pSemiBold18.copyWith(
                          fontSize: 18,
                          color: image!.contains("crown.svg") ||
                                  image!.contains("users.svg") ||
                                  image!.contains("postcard.svg")
                              ? ConstColors.primaryColor
                              : image!.contains("unlock.svg")
                                  ? Colors.redAccent
                                  : ConstColors.textColor),
                    ),
                    SizedBox(height: subTitle != "" ? 4 : 0),
                    subTitle != ""
                        ? Text(
                            subTitle!,
                            style: pRegular14.copyWith(
                              fontSize: 16,
                              color: ConstColors.text2Color,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                const Expanded(child: SizedBox()),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: ConstColors.text2Color,
                  size: 20,
                )
              ],
            ),
          ),
          Divider(
            color: ConstColors.text2Color.withOpacity(0.1),
            thickness: 1,
            indent: 50,
          )
        ],
      ),
    );
  }
}
