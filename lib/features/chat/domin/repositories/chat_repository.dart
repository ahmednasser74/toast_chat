import 'dart:io';

import 'package:connectycube_sdk/connectycube_sdk.dart'
    show CubeDialog, CubeFile, CubeMessage, CubeUser, PagedResult;

abstract class ChatRepository {
  Future<PagedResult<CubeUser>?> getUsers();
  Future<PagedResult<CubeMessage>?> getMessageHistory();
  Future<CubeDialog> createNewPrivateDialog(int id);
  Future<CubeMessage> sendMessage(String message);
  Stream<CubeMessage>? streamMessages();
  CubeDialog get getDialog;
  Future<CubeMessage> sendImageMessage(String path);
  Future<CubeFile> uploadCubeFile(File file);
  Future<void> startVoiceRecord({String? path});
  Future<void> resumeVoiceRecord();
  Future<void> pauseVoiceRecord();
  Future<String?> stopVoiceRecord();
  Future<void> disposeVoiceRecord();
  Future<CubeMessage> sendVoiceRecord(String? path);
  // Future<void> deleteRecord();
  Future<CubeDialog> createNewGroupDialog(List<int> users,String groupName);
  Future<PagedResult<CubeDialog>?> getGroupDialog();
}
