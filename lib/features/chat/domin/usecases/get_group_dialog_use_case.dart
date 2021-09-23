import 'package:connectycube_sdk/connectycube_sdk.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class GetGroupDialogUseCase
    extends UseCase<Future<PagedResult<CubeDialog>?>, NoParams> {
  GetGroupDialogUseCase({required this.chatRepository});

  final ChatRepository chatRepository;

  @override
  Future<PagedResult<CubeDialog>?> call({required NoParams params}) async {
    return await chatRepository.getGroupDialog();
  }
}
