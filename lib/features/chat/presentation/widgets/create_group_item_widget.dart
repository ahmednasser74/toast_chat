import 'package:connectycube_chat/core/src/colors.dart';
import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/material.dart';

import '../../../../core/src/styles.dart';
import '../../../../core/src/widgets/circle_image_widget.dart';

class CreateGroupItemWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final CubeUser cubeUser;

  CreateGroupItemWidget({
    required this.onPressed,
    required this.cubeUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: CustomStyle.containerShadowDecoration,
        child: Row(
          children: [
            CircleImageWithFirstCharWidget(
              avatar: cubeUser.avatar.toString(),
              fullName: cubeUser.fullName ?? '',
              imageSize: 30,
            ),
            SizedBox(width: 12),
            Text(
              cubeUser.fullName!,
              style: theme.textTheme.headline2?.copyWith(
                color: CustomColors.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
