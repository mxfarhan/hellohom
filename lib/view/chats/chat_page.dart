import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/config/text_style.dart';
import 'package:foodly/model/activity.dart';
import 'dart:async';
import 'package:foodly/services/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../services/socket_service.dart';
import '../../model/chat.dart';
import '../../config/constant.dart';

import './message_view.dart';
import './chat_text_input.dart';

class ChatPage extends StatefulWidget {
  final MainModel model;
  final Activity activity;

  ChatPage(this.model, this.activity);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    widget.model.clearChat();

    SocketService.setUserName(widget.model.user.name!);
    widget.model.connectAndListenChat(widget.model, widget.activity);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // SocketService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Container(
                alignment: Alignment.centerRight,
                height: 30,
                margin: EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    onPressed: () async {
                      SocketService.sendMessage(
                          "end chat", model, widget.activity);
                      // Timer(Duration(seconds: 3),
                      //     () => {
                      Navigator.of(context).pop();
                      // });
                    },
                    style: ButtonStyle(
                        // padding: MaterialStateProperty.all<EdgeInsets>(
                        //     EdgeInsets.all(15)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // side: BorderSide(color: Colors.red)
                        ))),
                    child: Text(
                      "END CHAT",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )))
          ],
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
            "Chats",
            style: pSemiBold18.copyWith(),
          ),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // UserListView(),

              ChatBody(model),
              SizedBox(height: 6),
              ChatTextInput(model, widget.activity),
            ],
          ),
        ),
      );
    });
  }
}

class ChatBody extends StatefulWidget {
  final MainModel model;

  ChatBody(this.model);

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  ScrollController _scrollController = ScrollController();

  ///scrolls to the bottom of page
  void _scrollDown() {
    try {
      Future.delayed(
          const Duration(milliseconds: 300),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
    } on Exception catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      //
      _scrollDown();
      //
      return Expanded(
          child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              controller: _scrollController,
              itemCount: model.chatList.length,
              itemBuilder: (BuildContext context, int index) {
                return MessageView(chat: model.chatList[index], model: model);
              }));
    });
  }
}
