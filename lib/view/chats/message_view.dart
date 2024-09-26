import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly/config/colors.dart';
import 'package:foodly/services/main_model.dart';
import 'package:intl/intl.dart';
import '../../services/socket_service.dart';
import '../../model/chat.dart';

class MessageView extends StatelessWidget {
  final Chat chat;
  final MainModel model;
  MessageView({Key? key, required this.chat, required this.model})
      : super(key: key);
  final f = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    //
    var size = MediaQuery.of(context).size;
    bool isSendByUser = chat.userId == model.uid.toString();

    return chat.message == "end chat"
        ? Container(
            alignment: Alignment.center,
            child: Text(
              "à quitté le Tchat.",
              style: TextStyle(fontSize: 14, color: ConstColors.text2Color),
            ))
        : Align(
            alignment:
                isSendByUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Column(
                crossAxisAlignment: isSendByUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    isSendByUser ? model.nama : "Guest",
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                      padding: const EdgeInsets.all(8),
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.5,
                        minWidth: size.width * 0.01,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSendByUser
                              ? Colors.blue
                              : Colors.grey.shade500),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isSendByUser)
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: CircleAvatar(
                                child: Icon(Icons.person, size: 10),
                                radius: 8,
                              ),
                            ),
                          Flexible(
                            child: Text(
                              chat.message ?? 'none',
                              style: const TextStyle(color: Colors.white),
                              softWrap: true,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 4),
                  Text(
                    f.format(DateTime.parse("${chat.date} ${chat.time}")),
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          );
  }
}
