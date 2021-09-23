import 'package:connectycube_chat/core/usecases/usecase.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/create_new_group_dialog_use_casr.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/get_group_dialog_use_case.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/get_users_use_case.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController with StateMixin {
  CreateGroupController({
    required this.createNewGroupDialogUseCase,
    required this.getUsersUseCase,
  });

  final CreateNewGroupDialogUseCase createNewGroupDialogUseCase;
  final GetUsersUseCase getUsersUseCase;

  final TextEditingController groupNameTEC = TextEditingController(text: '');
  final RxBool _loadingIndicator = false.obs;
  late PagedResult<CubeUser>? users;

  get getLoadingIndicator => _loadingIndicator.value;

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  void getUsers() async {
    change(null, status: RxStatus.loading());
    users = await getUsersUseCase(params: NoParams());
    change(users, status: RxStatus.success());
  }

  Future<CubeDialog?> createGroupDialog() async {
    if (groupNameTEC.text.isNotEmpty && groupNameTEC.text.length > 2) {
      _loadingIndicator.value = true;
      try {
        final newPublicDialog = await createNewGroupDialogUseCase.call(
          params: CreateNewGroupDialogParam(
            users: [4806576, 4800627, 4800466],
            groupName: groupNameTEC.text,
          ),
        );
        _loadingIndicator.value = false;
        Get.back();
        return newPublicDialog;
      } catch (e) {
        _loadingIndicator.value = false;
      }
    } else {
      Get.snackbar('Group name', 'invalid group name.',
          colorText: Colors.black);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
