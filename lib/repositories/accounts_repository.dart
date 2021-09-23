import 'package:mobility_one/util/api_calls.dart';
import 'package:mobility_one/util/local_storage.dart';

class AccountsRepository {
  final ApiCalls api;
  final LocalStorage localStorage;
  AccountsRepository({required this.api, required this.localStorage});

  Future<String> getCurrentAccount() async {
    return await api.getCurrentAccount();
  }

  Future<void> setUserName(String userName) async {
    return await localStorage.setUserName(userName);
  }

  Future<void> signUp({required Map<String, String> requestBody}) async {
    return await api.postAccount(requestBody: requestBody);
  }
}
