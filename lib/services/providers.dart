import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:belks_tube/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

final openPopupProvider = StateProvider<bool>((ref) {
  return false;
});

final userProvider = StateNotifierProvider<UserRepo, User>((ref) => UserRepo());

class UserRepo extends StateNotifier<User> {
  UserRepo() : super(User.defUser);

  initUser() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('canPlayBlackScreen')) {
      debugPrint('canPlayBlackScreen=${prefs.getBool('canPlayBlackScreen').toString()}');
      copyWith(canPlayBlackScreen: prefs.getBool('canPlayBlackScreen'));
    }
  }

  copyWith({String? name, bool? canPlayBlackScreen}) async {
    var prefs = await SharedPreferences.getInstance();

    state = User(
        name: name ?? state.name,
        canPlayBlackScreen: canPlayBlackScreen ?? state.canPlayBlackScreen);

    if (canPlayBlackScreen != null) {
      await prefs.setBool('canPlayBlackScreen', canPlayBlackScreen);
      debugPrint('canPlayBlackScreen=${prefs.getBool('canPlayBlackScreen').toString()}');
    }

  }
}
