import 'dart:io';

import 'package:connectycube_sdk/connectycube_sdk.dart';

import '../../../auth/data/datasources/user_local_data_source.dart';
import '../../domin/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/voice_record_data_source.dart';

class ChatRepositoryImp implements ChatRepository {
  const ChatRepositoryImp(
      {required this.chatRemoteDataSource,
      required this.userLocalDataSource,
      required this.recordDataSource});

  final ChatRemoteDataSource chatRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  final VoiceRecordDataSource recordDataSource;

  @override
  Future<PagedResult<CubeUser>?> getUsers() async {
    final currentUser = userLocalDataSource.getCacheUser();
    final currentUserID = currentUser?.id;
    final pageResult = await chatRemoteDataSource.getUsers();
    final items = pageResult?.items ?? [];
    items.removeAt(items.indexWhere((element) => element.id == currentUserID));
    return pageResult;
  }

  @override
  Future<PagedResult<CubeMessage>?> getMessageHistory() {
    return chatRemoteDataSource.getMessageHistory();
  }

  @override
  Future<CubeDialog> createNewPrivateDialog(int id) {
    return chatRemoteDataSource.createNewPrivateDialog(id);
  }

  @override
  Future<CubeMessage> sendMessage(String message) {
    final cacheUser = userLocalDataSource.getCacheUser();
    return chatRemoteDataSource.sendMessage(message, cacheUser);
  }

  @override
  Stream<CubeMessage>? streamMessages() {
    return chatRemoteDataSource.streamMessages();
  }

  @override
  CubeDialog get getDialog => chatRemoteDataSource.getDialog;

  Future<CubeMessage> sendImageMessage(String path) async {
    final file = File(path);
    final cubeFile = await uploadCubeFile(file);

    final cachedUser = userLocalDataSource.getCacheUser();
    return chatRemoteDataSource.sendImageMessage(
        cachedUser: cachedUser, cubeFile: cubeFile, imageFile: file);
  }

  @override
  Future<CubeFile> uploadCubeFile(File file) {
    return chatRemoteDataSource.uploadCubeFile(file);
  }

  // @override
  // Future<void> deleteRecord() {}

  @override
  Future<void> pauseVoiceRecord() => recordDataSource.pauseVoiceRecord();

  @override
  Future<void> startVoiceRecord({String? path}) =>
      recordDataSource.startVoiceRecord(path: path);

  @override
  Future<String?> stopVoiceRecord() => recordDataSource.stopVoiceRecord();

  @override
  Future<void> resumeVoiceRecord() => recordDataSource.resumeVoiceRecord();

  @override
  Future<void> disposeVoiceRecord() => recordDataSource.disposeVoiceRecord();

  @override
  Future<CubeMessage> sendVoiceRecord(String? path) async {
    final file = File(path!);
    final cubeFile = await uploadCubeFile(file);
    final cachedUser = userLocalDataSource.getCacheUser();
    return chatRemoteDataSource.sendVoiceRecordMessage(
        cachedUser: cachedUser, cubeFile: cubeFile, file: file);
  }

  @override
  Future<CubeDialog> createNewGroupDialog(List<int> users, String groupName) {
    return chatRemoteDataSource.createNewGroupDialog(users, groupName);
  }

  @override
  Future<PagedResult<CubeDialog>?> getGroupDialog() async {
    return await chatRemoteDataSource.getGroupDialog();
  }
}
