import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/src/colors.dart';
import '../../../../core/src/widgets/circle_image_widget.dart';
import '../../../../core/src/widgets/custom_button.dart';
import '../../../../core/src/widgets/loading_indicator_widget.dart';
import '../../../../core/utils/resposive.dart';
import '../getx/profile_controller.dart';
import '../widgets/text_field_widget.dart';

class ProfileUserPage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    final avatar =
        controller.getCacheUserUseCase.authRepository.getCacheUser()!.avatar;
    final res = Responsive(context);
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: controller.getLoadingIndicator,
        progressIndicator: LoadingIndicatorWidget(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          body: Form(
            key: controller.formKey,
            child: ListView(
              padding:
                  EdgeInsets.only(top: res.getHeight(10), left: 10, right: 10),
              children: [
                SizedBox(height: res.getHeight(2)),
                Center(
                  child: GestureDetector(
                    onTap: controller.pickImg,
                    child: Stack(
                      children: [
                        GetBuilder<ProfileController>(
                          builder: (controller) => Hero(
                            tag: 'profile_hero',
                            child: controller.pickedImgFile != null
                                ? ClipOval(
                                    child: Image.file(
                                      controller.pickedImgFile!,
                                      fit: BoxFit.cover,
                                      width: res.getWidth(40),
                                      height: res.getHeight(20),
                                    ),
                                  )
                                : CircleImageWithFirstCharWidget(
                                    avatar: avatar.toString(),
                                    fullName: controller.fullNameTEC.text,
                                    imageSize: 80,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          // alignment: Alignment.centerRight,
                          child: CircleAvatar(
                            backgroundColor: CustomColors.primaryColor,
                            radius: 20,
                            child: Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: res.getHeight(4)),
                TextFieldWidget(
                  controller: controller.fullNameTEC,
                  hint: 'Full Name',
                  inputType: TextInputType.text,
                  prefixIcon: Icons.person_outline,
                  validator: (v) {
                    final value = v ?? '';
                    if (value.isEmpty) {
                      return 'Invalid';
                    }
                  },
                ),
                SizedBox(height: res.getHeight(4)),
                TextFieldWidget(
                  controller: controller.userNameTEC,
                  hint: 'User Name',
                  inputType: TextInputType.text,
                  prefixIcon: Icons.person_outline,
                  validator: (v) {
                    final value = v ?? '';
                    if (value.isEmpty) {
                      return 'Invalid';
                    }
                  },
                ),
                SizedBox(height: res.getHeight(4)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: res.getWidth(20)),
                  child: CustomButton(
                    title: 'Done',
                    onPressed: controller.updateUserData,
                    paddingHorizontal: 70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
