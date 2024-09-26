import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/default_image.dart';
import 'package:foodly/widget/easy_faq.dart';
import 'dart:async';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/widget/custom_button.dart';
import 'package:foodly/widget/custom_textfield.dart';

import '../../services/main_model.dart';

class FAQscreen extends StatefulWidget {
  // final MainModel model;

  // FAQscreen(this.model);

  @override
  State<FAQscreen> createState() => _FAQscreenState();
}

class _FAQscreenState extends State<FAQscreen> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneController = TextEditingController();

  Timer? _timer;
  var _isSubmitted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //
    // initProfile();
  }

  void initProfile() {
    // _nameController.text = widget.model.nama;
    // _emailController.text = widget.model.email;
    // _phoneController.text = widget.model.phone;
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
            "FAQ",
            style: pSemiBold20.copyWith(),
          ),
        ),
        body: ListView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          children: [
            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question: "Qu’est-ce que Hello Home ?",
                answer:
                    "HelloHome est une sonnette NFC intelligente conçue pour simplifier la gestion des visiteurs à votre domicile. Elle vous permet de recevoir des notifications instantanées sur votre smartphone lorsque quelqu’un sonne à votre porte."),
            const SizedBox(height: 10),

            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question: "Comment fonctionne Hello Home ?",
                answer:
                    "La sonnette NFC HelloHome est équipée d’une puce NFC (Near Field Communication). Lorsqu’un visiteur approche sa carte NFC ou son smartphone compatible NFC de la sonnette, elle envoie instantanément une notification à l’application mobile sur votre téléphone. Ils peuvent aussi scanner un QR Code."),
            const SizedBox(height: 10),

            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question:
                    "Ai-je besoin d’une application mobile pour utiliser HelloHome ?",
                answer:
                    "En tant que propriétaire Oui, vous aurez besoin de télécharger l’application mobile HelloHome sur votre smartphone. L’application vous permet de gérer les paramètres de votre sonnette."),
            const SizedBox(height: 10),

            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question:
                    "Puis-je personnaliser les alertes de ma sonnette HelloHome ?",
                answer:
                    "Oui, l’application mobile vous permet de personnaliser les alertes, y compris les sonneries et les notifications visuelles, pour correspondre à vos préférences."),
            const SizedBox(height: 10),

            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question:
                    "HelloHome est-il compatible avec tous les smartphones ?",
                answer:
                    "Hello Home est compatible avec les smartphones équipés de la technologie NFC, ce qui est courant dans la plupart des smartphones modernes."),
            const SizedBox(height: 10),

            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question: "Quelle est la portée de la sonnette HelloHome ?",
                answer:
                    "La portée de la sonnette dépend de la technologie NFC, généralement à quelques centimètres. Le visiteur doit approcher sa carte NFC ou son smartphone très près de la sonnette pour déclencher une notification."),
            const SizedBox(height: 10),

            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question: "HelloHome permet-il de voir qui est à la porte ?",
                answer:
                    "Non, Hello Home est conçu pour envoyer des notifications, mais il n’a pas de fonction de vidéo ou de caméra intégrée pour voir qui est à la porte. En revanche vous pouvez lancer une discussion."),
            const SizedBox(height: 10),

            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question:
                    "Y a-t-il des frais mensuels pour utiliser HelloHome ?",
                answer:
                    "Oui, HelloHome est une solution autonome et implique un abonnement de 1,99€ par mois."),

            const SizedBox(height: 10),
            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question: "Comment puis-je installer HelloHome ?",
                answer:
                    "L’installation de HelloHome est simple et ne nécessite aucune compétence technique particulière. Suivez les instructions fournies avec la sonnette pour la mettre en place."),
            const SizedBox(height: 10),
            EasyFaq(
                questionTextStyle:
                    pSemiBold18.copyWith(color: ConstColors.whiteFontColor),
                anserTextStyle:
                    pRegular14.copyWith(color: ConstColors.whiteFontColor),
                backgroundColor: ConstColors.primaryColor,
                question: "Où puis-je acheter HelloHome ?",
                answer:
                    "HelloHome est disponible auprès de revendeurs autorisés. Vous pouvez également l’acheter en ligne sur notre site web officiel. Si vous avez d’autres questions ou avez besoin d’assistance supplémentaire, n’hésitez pas à nous contacter."),
            // Expanded(
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     physics: const ClampingScrollPhysics(),
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           CustomTextField(
            //             controller: _nameController,
            //             hintText: "Enter full name",
            //             inputType: TextInputType.name,
            //             obscureText: false,
            //             image: DefaultImages.profile,
            //             labelText: "FULL NAME",
            //           ),
            //           SizedBox(height: 7),
            //           _isSubmitted && _nameController.text.length < 3 ||
            //                   _isSubmitted && _nameController.text.isEmpty
            //               ? Container(
            //                   alignment: Alignment.centerRight,
            //                   child: Text(
            //                     _emailController.text.isEmpty
            //                         ? "Name can't be empty."
            //                         : "Name must have atleast 3 character.",
            //                     style: TextStyle(
            //                         color: Colors.red, fontSize: 12),
            //                   ),
            //                 )
            //               : const SizedBox(),
            //           SizedBox(height: 7),
            //           CustomTextField(
            //             controller: _emailController,
            //             hintText: "Enter email address",
            //             enabled: false,
            //             inputType: TextInputType.emailAddress,
            //             obscureText: false,
            //             image: '',
            //             labelText: "EMAIL",
            //           ),
            //           const SizedBox(height: 14),
            //           Padding(
            //             padding: const EdgeInsets.only(bottom: 10),
            //             child: Text(
            //               "PHONE NUMBER",
            //               style: pRegular14.copyWith(
            //                 fontSize: 14,
            //                 color: ConstColors.text2Color,
            //               ),
            //             ),
            //           ),
            //           IntlPhoneField(
            //             controller: _phoneController,
            //             decoration: InputDecoration(
            //               fillColor: const Color(0xffFBFBFB),
            //               filled: true,
            //               disabledBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(8),
            //                 borderSide: const BorderSide(
            //                   width: 1,
            //                   color: Color(0xffF3F2F2),
            //                 ),
            //               ),
            //               border: InputBorder.none,
            //               enabledBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(8),
            //                 borderSide: const BorderSide(
            //                   width: 1,
            //                   color: Color(0xffF3F2F2),
            //                 ),
            //               ),
            //               focusedBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(8),
            //                 borderSide: const BorderSide(
            //                   width: 1,
            //                   color: ConstColors.primaryColor,
            //                 ),
            //               ),
            //             ),
            //             disableLengthCheck: true,
            //             initialCountryCode: 'FR',
            //             onChanged: (phone) {
            //               print(phone.completeNumber);
            //             },
            //           ),
            //           SizedBox(height: 7),
            //           _isSubmitted && _phoneController.text.length < 7 ||
            //                   _isSubmitted && _phoneController.text.isEmpty
            //               ? Container(
            //                   alignment: Alignment.centerRight,
            //                   child: Text(
            //                     _phoneController.text.isEmpty
            //                         ? "Phone Number can't be empty."
            //                         : "Phone Number must have atleast 7 character.",
            //                     style: TextStyle(
            //                         color: Colors.red, fontSize: 12),
            //                   ),
            //                 )
            //               : const SizedBox(),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // CusttomButton(
            //   color: ConstColors.primaryColor,
            //   text: "CHANGE PROFILE",
            //   onTap: () async {
            //     FocusManager.instance.primaryFocus?.unfocus();

            //     setState(() => _isSubmitted = true);
            //     if (_nameController.text.length > 3 &&
            //         _nameController.text.isNotEmpty &&
            //         _phoneController.text.isNotEmpty &&
            //         _phoneController.text.length > 5) {
            //       await _validateAndSubmit(model);
            //     } // Get.offAll(
            //     //   const TabScreen(),
            //     //   transition: Transition.rightToLeft,
            //     // );
            //   },
            // ),
            // const SizedBox(height: 24),
          ],
        ),
      );
    });
  }
}
