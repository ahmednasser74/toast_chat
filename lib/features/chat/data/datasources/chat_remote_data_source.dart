import 'dart:io';

import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart' show decodeImageFromList;

abstract class ChatRemoteDataSource {
  Future<PagedResult<CubeUser>?> getUsers();

  Future<PagedResult<CubeMessage>?> getMessageHistory();

  CubeDialog get getDialog;

  Future<CubeDialog> createNewPrivateDialog(int id);

  Future<CubeMessage> sendMessage(String message, CubeUser? cachedUser);

  Stream<CubeMessage>? streamMessages();

  Future<CubeMessage> sendImageMessage({
    required CubeFile cubeFile,
    required File imageFile,
    CubeUser? cachedUser,
  });

  Future<CubeMessage> sendVoiceRecordMessage({
    required CubeFile cubeFile,
    required File file,
    CubeUser? cachedUser,
  });

  Future<CubeFile> uploadCubeFile(File file);

  Future<CubeDialog> createNewGroupDialog(List<int> users, String groupName);

  Future<PagedResult<CubeDialog>?> getGroupDialog();
}

class ChatRemoteDataSourceImp implements ChatRemoteDataSource {
  ChatRemoteDataSourceImp();

  @override
  Future<PagedResult<CubeUser>?> getUsers() async => getAllUsers();
  late CubeDialog _dialog;
  Stream<CubeMessage>? messagesStatusesManager =
      CubeChatConnection.instance.chatMessagesManager?.chatMessagesStream;

  @override
  Future<CubeDialog> createNewPrivateDialog(int id) async {
    final setDialog = CubeDialog(CubeDialogType.PRIVATE, occupantsIds: [id]);
    _dialog = await createDialog(setDialog);
    return _dialog;
  }

  @override
  Future<CubeMessage> sendMessage(String message, CubeUser? cachedUser) async {
    final newCubeMessage = _createCubeMessage()
      ..senderId = cachedUser?.id
      ..body = message;
    return _dialog.sendMessage(newCubeMessage);
  }

  @override
  Future<PagedResult<CubeMessage>?> getMessageHistory() async {
    final dialogId = getDialog.dialogId!;
    return getMessages(dialogId);
  }

  CubeMessage _createCubeMessage() => CubeMessage()
    ..dateSent = DateTime.now().millisecondsSinceEpoch ~/ 1000
    ..markable = true
    ..saveToHistory = true;

  CubeAttachment _createCubeFileAttachment(
          {required File file,
          required String url,
          required String type,
          int? height,
          int? width}) =>
      CubeAttachment()
        ..id = file.hashCode.toString()
        ..type = type
        ..url = url
        ..height = height
        ..width = width
        ..size = file.lengthSync().toDouble();

  @override
  Stream<CubeMessage>? streamMessages() {
    return messagesStatusesManager;
  }

  @override
  CubeDialog get getDialog => _dialog;

  @override
  Future<CubeMessage> sendImageMessage(
      {required CubeFile cubeFile,
      required File imageFile,
      CubeUser? cachedUser}) async {
    var decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    final url = cubeFile.getPublicUrl().toString();
    final attachment = _createCubeFileAttachment(
      file: imageFile,
      url: url,
      type: CubeAttachmentType.IMAGE_TYPE,
      height: decodedImage.height,
      width: decodedImage.width,
    );
    CubeMessage message = _createCubeMessage()
      ..body = "Attachment"
      ..attachments = [attachment]
      ..senderId = cachedUser?.id;

    message = await _dialog.sendMessage(message);
    return message;
  }

  @override
  Future<CubeFile> uploadCubeFile(File file) {
    print(file.toString());
    return uploadFile(
      file,
      isPublic: true,
      onProgress: (progress) {
        print("uploadImageFile progress = $progress");
      },
    );
  }

  @override
  Future<CubeMessage> sendVoiceRecordMessage(
      {required CubeFile cubeFile,
      required File file,
      CubeUser? cachedUser}) async {
    final url = cubeFile.getPublicUrl().toString();
    final attachment = _createCubeFileAttachment(
      file: file,
      url: url,
      type: CubeAttachmentType.AUDIO_TYPE,
    );
    CubeMessage message = _createCubeMessage()
      ..body = "Attachment"
      ..attachments = [attachment]
      ..senderId = cachedUser?.id;

    message = await _dialog.sendMessage(message);
    return message;
  }

  @override
  Future<CubeDialog> createNewGroupDialog(
      List<int> users, String groupName) async {
    final newGroupDialog =
        CubeDialog(CubeDialogType.GROUP, occupantsIds: users);
    newGroupDialog.name = groupName;
    _dialog = await createDialog(newGroupDialog);
    return _dialog;
  }

  @override
  Future<PagedResult<CubeDialog>?> getGroupDialog() async {
    return await getDialogs();
  }
}
