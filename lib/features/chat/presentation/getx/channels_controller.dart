import 'package:connectycube_sdk/connectycube_sdk.dart'
    show CubeDialog, CubeUser, PagedResult, getDialogs;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart'
    show PagingController;

import '../../../../core/usecases/usecase.dart';
import '../../../auth/domin/usecases/get_cache_user_usecase.dart';
import '../../domin/usecases/create_new_private_dialog.dart';
import '../../domin/usecases/get_users_use_case.dart';

class ChannelsController extends GetxController
    with SingleGetTickerProviderMixin, StateMixin<PagedResult<CubeUser>?> {
  ChannelsController({
    required this.getCacheUserUseCase,
    required this.getUsersUseCase,
    required this.createNewPrivateDialogUseCase,
  });

  final GetUsersUseCase getUsersUseCase;
  final GetCacheUserUseCase getCacheUserUseCase;
  final CreateNewPrivateDialogUseCase createNewPrivateDialogUseCase;

  late TabController tabController;
  PagedResult<CubeUser>? users;
  late CubeUser cubeUser;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.empty());
    getUsers();
    tabController = new TabController(length: 2, vsync: this);
  }

  void getUsers() async {
    change(null, status: RxStatus.loading());
    users = await getUsersUseCase(params: NoParams());
    change(users, status: RxStatus.success());
  }

  set setUser(CubeUser cubeUser) {
    this.cubeUser = cubeUser;
    update();
  }

  CubeUser get getUser => cubeUser;

  Future<CubeDialog?> createNewPrivateDialog(CubeUser user) async {
    final id = user.id;
    if (id != null) {
      return createNewPrivateDialogUseCase(params: PrivateDialogParam(id: id));
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
