import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectycube_chat/core/src/colors.dart';
import 'package:connectycube_chat/core/src/styles.dart';
import 'package:connectycube_chat/features/chat/presentation/getx/channels_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageTEC = TextEditingController(text: '');

  late bool messageIsEmpty = true;

  @override
  Widget build(BuildContext context) {
    final channelController = Get.find<ChannelsController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage( imageUrl: channelController.getUser.avatar!,
                  height: 40, width: 40, fit: BoxFit.cover,),
            ),
            SizedBox(width: 10),
            Text(channelController.getUser.fullName.toString()),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Text('chat page'),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: CustomStyle.containerShadowDecoration
                .copyWith(borderRadius: BorderRadius.circular(0)),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: CustomColors.primaryColor,
                  child: Icon(Icons.add, size: 20, color: Colors.white),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: messageTEC,
                      decoration: CustomStyle.authInputDecoration.copyWith(
                        hintText: 'Message',
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (v) {
                        v.isEmpty
                            ? messageIsEmpty = true
                            : messageIsEmpty = false;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: messageIsEmpty
                      ? Icon(
                          Icons.mic,
                          color: CustomColors.primaryColor,
                        )
                      : Icon(
                          Icons.send,
                          color: CustomColors.primaryColor,
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
