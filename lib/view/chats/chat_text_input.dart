import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/model/activity.dart';
import 'package:foodly/model/chat.dart';
import 'package:foodly/services/main_model.dart';
import '../../services/socket_service.dart';

class ChatTextInput extends StatelessWidget {
  final MainModel model;
  final Activity activity;
  //
  ChatTextInput(this.model, this.activity);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    var focusCode = FocusNode();

    sendMessage() {
      var message = textController.text;
      if (message.isEmpty) return;
      SocketService.sendMessage(message, model, activity);
      //
      textController.text = '';
      focusCode.requestFocus();
    }

    return Container(
      margin: const EdgeInsets.all(12),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 60,
              child: TextFormField(
                onFieldSubmitted: (v) {
                  sendMessage();
                },
                textAlign: TextAlign.left,
                focusNode: focusCode,
                autofocus: true,
                maxLines: 1,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                style: pSemiBold18.copyWith(
                    fontSize: 16, color: ConstColors.textColor),
                controller: textController,
                cursorColor: ConstColors.primaryColor,
                decoration: InputDecoration(
                  fillColor: const Color(0xffFBFBFB),
                  filled: true,
                  contentPadding: const EdgeInsets.only(
                      left: 10, top: 16, bottom: 16, right: 10),
                  isDense: true,
                  hintText: "Send a message...",
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
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              sendMessage();
            },
            child: const CircleAvatar(
              child: Icon(Icons.send, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
