import 'package:connectycube_chat/features/chat/domin/usecases/create_new_group_dialog_use_casr.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/get_group_dialog_use_case.dart';
import 'package:connectycube_chat/features/chat/presentation/getx/create_group_controller.dart';
import 'package:connectycube_chat/features/chat/presentation/getx/get_group_dialog_controller.dart';

import '../../features/auth/domin/usecases/is_online_usecase.dart';
import '../../features/auth/presentation/getx/offline_controller.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/user_local_data_source.dart';
import '../../features/auth/data/datasources/user_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_imp.dart';
import '../../features/auth/domin/repositories/auth_repository.dart';
import '../../features/auth/domin/usecases/delete_cache_user_usecase.dart';
import '../../features/auth/domin/usecases/get_cache_user_usecase.dart';
import '../../features/auth/domin/usecases/login_usecase.dart';
import '../../features/auth/domin/usecases/register_usecase.dart';
import '../../features/auth/domin/usecases/update_user_data_usecase.dart';
import '../../features/auth/presentation/getx/login_controller.dart';
import '../../features/auth/presentation/getx/profile_controller.dart';
import '../../features/auth/presentation/getx/register_controller.dart';
import '../../features/chat/data/datasources/chat_remote_data_source.dart';
import '../../features/chat/data/datasources/voice_record_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_imp.dart';
import '../../features/chat/domin/repositories/chat_repository.dart';
import '../../features/chat/domin/usecases/create_new_private_dialog.dart';
import '../../features/chat/domin/usecases/dispose_voice_recrod_use_case.dart';
import '../../features/chat/domin/usecases/get_dialog_use_case.dart';
import '../../features/chat/domin/usecases/get_message_history_use_case.dart';
import '../../features/chat/domin/usecases/get_stream_message_use_case.dart';
import '../../features/chat/domin/usecases/get_users_use_case.dart';
import '../../features/chat/domin/usecases/pause_voice_recrod_use_case.dart';
import '../../features/chat/domin/usecases/resume_voice_recrod_use_case.dart';
import '../../features/chat/domin/usecases/send_image_message_use_case.dart';
import '../../features/chat/domin/usecases/send_string_message_use_case.dart';
import '../../features/chat/domin/usecases/send_voice_record_message_use_case.dart';
import '../../features/chat/domin/usecases/start__voice_recrod_use_case.dart';
import '../../features/chat/domin/usecases/stop_voice_recrod_use_case.dart';
import '../../features/chat/domin/usecases/upload_file_use_case.dart';
import '../../features/chat/presentation/getx/channels_controller.dart';
import '../../features/chat/presentation/getx/chat_controller.dart';
import '../../features/chat/presentation/getx/voice_record_controller.dart';
import '../network/network_information.dart';

class Injection {
  static final sl = GetIt.instance;

  static Future<void> init() async {
    // External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker());
    sl.registerLazySingleton<FlutterSoundRecorder>(
        () => FlutterSoundRecorder());
    _auth();
    _chat();
  }

  static void _auth() async {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImp(
        userRemoteDataSource: sl(),
        userLocalDataSource: sl(),
        networkInformation: sl(),
      ),
    );
    // Use cases
    sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
    sl.registerLazySingleton<LogOutUserUseCase>(
        () => LogOutUserUseCase(authRepository: sl()));
    sl.registerLazySingleton<GetCacheUserUseCase>(
        () => GetCacheUserUseCase(authRepository: sl()));

    sl.registerLazySingleton<RegisterUseCase>(
        () => RegisterUseCase(authRepository: sl()));
    sl.registerLazySingleton<UpdateUserDataUseCase>(
        () => UpdateUserDataUseCase(authRepository: sl()));
    sl.registerLazySingleton<IsOnlineUseCase>(
        () => IsOnlineUseCase(authRepository: sl()));
    // Controller
    sl.registerFactory<LoginController>(
      () => LoginController(
          loginUseCase: sl(),
          getCacheUserUseCase: sl(),
          logOutUserUseCase: sl(),
          isOnlineUseCase: sl()),
    );
    sl.registerFactory<RegisterController>(
      () => RegisterController(
          registerUseCase: sl(), loginUseCase: sl(), isOnlineUseCase: sl()),
    );
    sl.registerFactory<OfflineController>(
      () => OfflineController(isOnlineUseCase: sl()),
    );
    sl.registerFactory<ProfileController>(
      () => ProfileController(
        updateUserDataUseCase: sl(),
        getCacheUserUseCase: sl(),
      ),
    );

    // Data sources
    sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImp());
    sl.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImp(sharedPreferences: sl()));
    sl.registerLazySingleton<NetworkInformation>(
        () => NetworkInformationImp(internetConnectionChecker: sl()));
  }

  static void _chat() async {
    sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImp(
        chatRemoteDataSource: sl(),
        userLocalDataSource: sl(),
        recordDataSource: sl()));
    // Use cases
    sl.registerLazySingleton<GetUsersUseCase>(
        () => GetUsersUseCase(chatRepository: sl()));
    sl.registerLazySingleton<CreateNewPrivateDialogUseCase>(
        () => CreateNewPrivateDialogUseCase(chatRepository: sl()));
    sl.registerLazySingleton<SendStringMessageUseCase>(
        () => SendStringMessageUseCase(chatRepository: sl()));
    sl.registerLazySingleton<GetStreamMessagesUseCase>(
        () => GetStreamMessagesUseCase(chatRepository: sl()));
    sl.registerLazySingleton<GetDialogUseCase>(
        () => GetDialogUseCase(chatRepository: sl()));
    sl.registerLazySingleton<SendImageMessageUseCase>(
        () => SendImageMessageUseCase(chatRepository: sl()));
    sl.registerLazySingleton<UploadFileUseCase>(
        () => UploadFileUseCase(chatRepository: sl()));

    sl.registerLazySingleton<StartVoiceRecordUseCase>(
        () => StartVoiceRecordUseCase(chatRepository: sl()));
    sl.registerLazySingleton<PauseVoiceRecordUseCase>(
        () => PauseVoiceRecordUseCase(chatRepository: sl()));
    sl.registerLazySingleton<ResumeVoiceRecordUseCase>(
        () => ResumeVoiceRecordUseCase(chatRepository: sl()));
    sl.registerLazySingleton<StopVoiceRecordUseCase>(
        () => StopVoiceRecordUseCase(chatRepository: sl()));
    sl.registerLazySingleton<DisposeVoiceRecordUseCase>(
        () => DisposeVoiceRecordUseCase(chatRepository: sl()));

    sl.registerLazySingleton<SendVoiceRecordMessageUseCase>(
        () => SendVoiceRecordMessageUseCase(chatRepository: sl()));
    sl.registerLazySingleton<GetMessageHistoryUseCase>(
        () => GetMessageHistoryUseCase(chatRepository: sl()));
    sl.registerLazySingleton<CreateNewGroupDialogUseCase>(
      () => CreateNewGroupDialogUseCase(chatRepository: sl()),
    );
    sl.registerLazySingleton<GetGroupDialogUseCase>(
      () => GetGroupDialogUseCase(chatRepository: sl()),
    );
    // Controllers
    sl.registerFactory<ChannelsController>(
      () => ChannelsController(
        getUsersUseCase: sl(),
        getCacheUserUseCase: sl(),
        createNewPrivateDialogUseCase: sl(),
      ),
    );
    sl.registerFactory<ChatController>(() => ChatController(
          sendStringMessageUseCase: sl(),
          getStreamMessagesUseCase: sl(),
          sendImageMessageUseCase: sl(),
          getDialogUseCase: sl(),
          getMessageHistoryUseCase: sl(),
          uploadFileUseCase: sl(),
          getCacheUserUseCase: sl(),
        ));
    sl.registerFactory<VoiceRecordController>(() => VoiceRecordController(
          startRecordUseCase: sl(),
          pauseRecordUseCase: sl(),
          resumeRecordUseCase: sl(),
          stopRecordUseCase: sl(),
          disposeRecordUseCase: sl(),
          sendVoiceRecordMessageUseCase: sl(),
        ));

    sl.registerFactory<CreateGroupController>(() => CreateGroupController(
          createNewGroupDialogUseCase: sl(),
          getUsersUseCase: sl(),
        ));
    sl.registerFactory<GetGroupDialogController>(() => GetGroupDialogController(
          getGroupDialogUseCase: sl(),
        ));

    // Data sources
    sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImp(),
    );
    // sl.registerLazySingleton<VoiceRecordDataSource>(
    //     () => VoiceRecordDataSourceImp(record: sl()));
    sl.registerLazySingleton<VoiceRecordDataSource>(
        () => VoiceRecordDataSourceImp2(flutterSoundRecorder: sl()));
  }
}
