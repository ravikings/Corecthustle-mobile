
import 'package:correct_hustle/core/constants/constants.dart';
import 'package:correct_hustle/core/data/models/user_model.dart';
import 'package:correct_hustle/core/locator.dart';
import 'package:correct_hustle/core/services/local_storage/i_local_storage_service.dart';
import 'package:correct_hustle/core/state/base_provider.dart';
import 'package:dio/dio.dart';

class UserProfileProvider extends BaseProvider {
  UserProfileProvider() {
    loadUserDetail();
  }
  final userProfileState = ProviderActionState<UserModel>();

  void setUser(UserModel user) {
    userProfileState.toSuccess(user);
    notifyListeners();
  }

  void loadUserDetail() async {
    try {
      userProfileState.isLoading(); notifyListeners();
      final token = await getIt<ILocalStorageService>().getItem(userDataBox, userTokenKey, defaultValue: null);
      print("UserToken ::: $token");
      final res = await getIt<Dio>().get("auth-user", options: Options(
        headers: {
          "authorization": "Bearer $token"
        }
      ));
      print(res.data);
      final user = UserModel.fromJson(res.data['data']);
      setUser(user);
    } catch (error) {
      userProfileState.toError('Error: $error');
      notifyListeners();
    }
  }
}