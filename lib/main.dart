import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/src/routes.dart';
import 'core/src/theme.dart';
import 'core/usecases/usecase.dart';
import 'core/utils/configs.dart';
import 'core/utils/injection_container.dart';
import 'features/auth/domin/usecases/get_cache_user_usecase.dart';
import 'features/auth/presentation/getx/login_controller.dart';
import 'features/auth/presentation/getx/offline_controller.dart';
import 'features/auth/presentation/getx/profile_controller.dart';
import 'features/auth/presentation/getx/register_controller.dart';
import 'features/chat/presentation/getx/channels_controller.dart';
import 'features/chat/presentation/getx/chat_controller.dart';
import 'features/chat/presentation/getx/create_group_controller.dart';
import 'features/chat/presentation/getx/get_group_dialog_controller.dart';
import 'features/chat/presentation/getx/voice_record_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  await Injection.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    CubeSettings.instance.isDebugEnabled = false;
    ConnectyCubeConfig.initial(
      onSessionRestore: () async {
        final getCacheUserUseCase = Injection.sl<GetCacheUserUseCase>();
        final user = await getCacheUserUseCase(params: NoParams());
        return createSession(user);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomsThemes.defaultThemeData,
      initialRoute: Routes.splashPage,
      getPages: Routes.setPages(),
      onInit: _initControllers,
      title: 'Chat',
    );
  }

  void _initControllers() {
    // Auth
    Get.lazyPut(() => Injection.sl<LoginController>(), fenix: true);
    Get.lazyPut(() => Injection.sl<OfflineController>(), fenix: true);
    Get.lazyPut(() => Injection.sl<RegisterController>(), fenix: true);
    Get.lazyPut(() => Injection.sl<ProfileController>(), fenix: true);

    // Chat
    Get.lazyPut(() => Injection.sl<ChannelsController>());
    Get.lazyPut(() => Injection.sl<ChatController>(), fenix: true);
    Get.lazyPut(() => Injection.sl<VoiceRecordController>(), fenix: true);
    Get.lazyPut(() => Injection.sl<CreateGroupController>(), fenix: true);
    Get.lazyPut(() => Injection.sl<GetGroupDialogController>(), fenix: true);
  }
}
