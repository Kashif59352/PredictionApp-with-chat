import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Storage._internal();

  static final Storage _instence = Storage._internal();

  factory Storage() => _instence;

  SharedPreferences? _share;

  Future<void> init() async {
    _share = await SharedPreferences.getInstance();
  }

  bool get isLogin => _share?.getBool("user") ?? false;

  Future<void> setLogin({required bool val}) async {
    await _share?.setBool("user", val);
  }

  Future<void> logOut() async {
    await _share?.setBool("user", false);
  }
}
