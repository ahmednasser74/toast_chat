import 'package:connectycube_chat/features/auth/domin/usecases/delete_cache_user_usecase.dart';
import 'package:connectycube_chat/features/auth/domin/usecases/get_cache_user_usecase.dart';
import 'package:connectycube_chat/features/auth/domin/usecases/register_usecase.dart';
import 'package:connectycube_chat/features/auth/domin/usecases/update_user_data_usecase.dart';
import 'package:connectycube_chat/features/auth/presentation/getx/profile_controller.dart';
import 'package:connectycube_chat/features/auth/presentation/getx/register_controller.dart';
import 'package:connectycube_chat/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:connectycube_chat/features/chat/data/repositories/chat_repository_imp.dart';
import 'package:connectycube_chat/features/chat/domin/repositories/chat_repository.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/create_new_private_dialog.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/get_users_use_case.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/send_image_message_use_case.dart';
import 'package:connectycube_chat/features/chat/domin/usecases/send_string_message_use_case.dart';
import 'package:connectycube_chat/features/chat/presentation/getx/channels_controller.dart';
import 'package:connectycube_chat/features/chat/presentation/getx/chat_controller.dart';

import '../network/network_information.dart';
import '../../features/auth/data/datasources/user_local_data_source.dart';
import '../../features/auth/data/datasources/user_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/domin/repositories/auth_repository.dart';
import '../../features/auth/domin/usecases/login_usecase.dart';
import '../../features/auth/presentation/getx/login_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Injection {
  static final sl = GetIt.instance;

  static Future<void> init() async {
    // External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker());
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

    // Controller
    sl.registerFactory<LoginController>(
      () => LoginController(
          loginUseCase: sl(),
          getCacheUserUseCase: sl(),
          logOutUserUseCase: sl()),
    );
    sl.registerFactory<RegisterController>(
      () => RegisterController(registerUseCase: sl()),
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
    sl.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImp(chatRemoteDataSource: sl()));
    // Use cases
    sl.registerLazySingleton<GetUsersUseCase>(
        () => GetUsersUseCase(chatRepository: sl()));
    sl.registerLazySingleton<CreateNewPrivateDialogUseCase>(
        () => CreateNewPrivateDialogUseCase(chatRepository: sl()));
    sl.registerLazySingleton<SendStringMessageUseCase>(
        () => SendStringMessageUseCase(chatRepository: sl()));
    sl.registerLazySingleton<SendImageMessageUseCase>(
        () => SendImageMessageUseCase(chatRepository: sl()));
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
          sendImageMessageUseCase: sl(),
        ));
    // Data sources
    sl.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImp());
  }
}
