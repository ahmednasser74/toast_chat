import 'package:connectycube_chat/core/usecases/usecase.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/get_group_dialog_use_case.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:get/get.dart';

class GetGroupDialogController extends GetxController
    with StateMixin<PagedResult<CubeDialog>?> {
  final GetGroupDialogUseCase getGroupDialogUseCase;

  GetGroupDialogController({required this.getGroupDialogUseCase});

  late PagedResult<CubeDialog>? groupDialogsList;

  @override
  void onInit() {
    getDialog();
    super.onInit();
  }

//TODO get dialogs get all dialogs >> private (which have messages between two sides) && group dialog which created
//TODO we need to check on CubeDialogType before adding in groupDialogsList
  void getDialog() async {
    groupDialogsList = await getGroupDialogUseCase(params: NoParams());
    groupDialogsList?.items.forEach((element) {
      change(null, status: RxStatus.loading());
      if (element.type == CubeDialogType.GROUP) {
        print('name = ${element.name}');
        print('type = ${element.type}');
        print('length = ${groupDialogsList?.items.length}');
      }
    });
    change(groupDialogsList, status: RxStatus.success());
  }
}
