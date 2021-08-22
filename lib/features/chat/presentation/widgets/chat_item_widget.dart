import 'package:connectycube_chat/core/src/styles.dart';
import 'package:connectycube_chat/core/src/widgets/circle_image_widget.dart';
import 'package:connectycube_chat/features/auth/domin/usecases/get_first_char_use_case.dart';
import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/material.dart';

class ChatItemWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final CubeUser cubeUser;
  final GetFirstCharUseCase getFirstCharUseCase;

  ChatItemWidget({
    required this.onPressed,
    required this.cubeUser,
    required this.getFirstCharUseCase,
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
            CircleImageWidget(
              avatar: cubeUser.avatar.toString(),
              fullName: cubeUser.fullName ?? '',
              imageSize: 30,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cubeUser.fullName!,
                          style: theme.textTheme.headline5!
                              .copyWith(fontSize: 14)),
                      Text(
                        '${cubeUser.lastRequestAt!.hour.toString()}:${cubeUser.lastRequestAt!.minute}',
                        style:
                            theme.textTheme.subtitle1!.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('hey', style: theme.textTheme.subtitle2)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
