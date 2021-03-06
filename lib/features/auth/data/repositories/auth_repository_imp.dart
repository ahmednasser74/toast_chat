import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:connectycube_sdk/src/core/users/models/cube_user.dart';

import '../../../../core/network/network_information.dart';
import '../../domin/repositories/auth_repository.dart';
import '../../domin/usecases/login_usecase.dart';
import '../../domin/usecases/register_usecase.dart';
import '../../domin/usecases/update_user_data_usecase.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';

class AuthRepositoryImp implements AuthRepository {
  final UserLocalDataSource userLocalDataSource;
  final UserRemoteDataSource userRemoteDataSource;
  final NetworkInformation networkInformation;

  AuthRepositoryImp(
      {required this.userLocalDataSource,
      required this.userRemoteDataSource,
      required this.networkInformation});

  @override
  Future<CubeUser?> login(LoginParams params) async {
    final user = await userRemoteDataSource.login(params);

    if (userLocalDataSource.getCacheUser() == null && user != null) {
      await userLocalDataSource.saveUser(user);
    }
    return user;
  }

  @override
  Future<CubeUser?> register(RegisterParams params) async {
    final user = await userRemoteDataSource.register(params);
    final isCached = await userLocalDataSource.saveUser(user);
    return isCached ? user : null;
  }

  @override
  CubeUser? getCacheUser() {
    return userLocalDataSource.getCacheUser();
  }

  @override
  Future<bool> logoutUser() async {
    final isdeleted = await userLocalDataSource.deleteUser();
    await signOut().whenComplete(() {
      CubeChatConnection.instance.destroy();
    });
    return isdeleted;
  }

  @override
  Future<CubeUser?> updateUserData(UpdateUserDataParams params) async {
    final user = await userRemoteDataSource.updateUserData(params);
    await userLocalDataSource.saveUser(user);
    return user;
  }

  @override
  Future<bool> isOnline() => networkInformation.isConnected;
}
