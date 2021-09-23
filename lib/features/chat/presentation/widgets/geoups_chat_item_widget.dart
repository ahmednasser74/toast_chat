import 'package:connectycube_chat/core/src/colors.dart';
import 'package:connectycube_chat/core/src/styles.dart';
import 'package:connectycube_chat/core/src/widgets/circle_image_widget.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';

class GroupsChatItemWidget extends StatelessWidget {
  final CubeDialog dialog;
  final VoidCallback onTap;

  GroupsChatItemWidget({
    required this.dialog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: CustomStyle.containerShadowDecoration,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(6),
      child: ListTile(
        trailing: Visibility(
          visible: dialog.unreadMessageCount == 0 ? false : true,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: CustomColors.primaryColor,
            child: Text(
              dialog.unreadMessageCount.toString(),
              style: textTheme.subtitle2?.copyWith(color: Colors.black),
            ),
          ),
        ),
        title: Text(dialog.name ?? '', style: textTheme.headline5),
        leading: CircleImageWithFirstCharWidget(
          avatar: dialog.photo.toString(),
          fullName: dialog.name ?? '',
          imageSize: 30,
        ),
      ),
    );
  }
}
