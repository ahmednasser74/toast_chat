import 'package:connectycube_chat/features/chat/presentation/getx/get_group_dialog_controller.dart';
import 'package:connectycube_chat/features/chat/presentation/widgets/geoups_chat_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsPage extends GetView<GetGroupDialogController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (pageResult) {
          final dialogList = pageResult?.items ?? [];
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: dialogList.length,
            itemBuilder: (context, index) {
                final dialog = dialogList.elementAt(index);
              return GroupsChatItemWidget(
                dialog: dialog,
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
