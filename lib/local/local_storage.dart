import 'package:get_storage/get_storage.dart';

mixin CacheManager {
  void setUserType(String userType) {
    final box = GetStorage();
    box.write('userType', userType);
  }

  String? getUserType() {
    final box = GetStorage();
    return box.read('userType');
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove('userType');
  }
}
