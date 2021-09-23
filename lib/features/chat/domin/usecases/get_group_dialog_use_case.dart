import 'package:connectycube_sdk/connectycube_sdk.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class GetDialogUseCase extends UseCase<CubeDialog, NoParams> {
  GetDialogUseCase({required this.chatRepository});
  final ChatRepository chatRepository;

  @override
  CubeDialog call({required NoParams params}) {
    return chatRepository.getDialog;
  }
}
