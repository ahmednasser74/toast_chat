import 'package:connectycube_chat/core/src/colors.dart';

import '../../../../core/src/widgets/custom_button.dart';

import '../../../../core/src/widgets/circle_image_widget.dart';
import '../../../auth/presentation/getx/login_controller.dart';
import '../getx/channels_controller.dart';

import '../../../../core/src/routes.dart';
import '../../../../core/utils/resposive.dart';
import 'groups_page.dart';
import 'users_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChannelsPage extends GetView<ChannelsController> {
  @override
  Widget build(BuildContext context) {
    final res = Responsive(context);
    final theme = Theme.of(context);
    final cachedUser =
        controller.getCacheUserUseCase.authRepository.getCacheUser()!;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      try {
                        final loginController = Get.find<LoginController>();
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            contentPadding: EdgeInsets.all(10),
                            title: Text('Log out?'),
                            actions: [
                              CustomButton(
                                onPressed: () => Get.back(),
                                title: 'No',
                                fonSize: 12,
                              ),
                              CustomButton(
                                onPressed: loginController.logout,
                                title: 'Yes',
                                fonSize: 12,
                              ),
                            ],
                            titleTextStyle: theme.textTheme.headline1,
                            backgroundColor: Colors.white,
                          ),
                        );
                      } catch (e) {
                        Get.snackbar('error', '$e');
                      }
                    },
                    icon: Icon(Icons.logout)),
                // GestureDetector(
                //   onTap: () async {},
                //   child: Container(
                //     padding: EdgeInsets.all(8),
                //     width: res.size.width - 150,
                //     decoration: BoxDecoration(
                //       color: CustomColors.yellowLightColor,
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(Icons.search, color: CustomColors.accentColor),
                //         Text('Search...')
                //       ],
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.profileUserPage),
                  child: Hero(
                    tag: 'profile_hero',
                    child: CircleImageWithFirstCharWidget(
                      avatar: cachedUser.avatar.toString(),
                      fullName: cachedUser.fullName ?? 'A',
                      imageSize: 24,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: res.getHeight(2)),
            Text('Recent Chat', style: theme.textTheme.headline2),
            // Expanded(child: UsersPage()),
            Container(
              margin: EdgeInsets.all(14),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: CustomColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: CustomColors.accentColor,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                labelStyle: theme.textTheme.headline4,
                tabs: [
                  Tab(text: 'Chats'),
                  Tab(text: 'Groups'),
                ],
                controller: controller.tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  UsersPage(),
                  GroupsPage(),
                ],
                controller: controller.tabController,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.createGroupPage),
        backgroundColor: CustomColors.primaryColor,
        child: Icon(Icons.add, size: 40, color: Colors.white),
      ),
    );
  }
}
