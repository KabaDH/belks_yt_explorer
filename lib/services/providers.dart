import 'package:belks_tube/data/repo/local/prefs_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:belks_tube/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

final openPopupProvider = StateProvider<bool>((ref) {
  return false;
});

final userProvider =
    StateNotifierProvider<UserRepo, User>((ref) => UserRepo(ref));

class UserRepo extends StateNotifier<User> {
  UserRepo(this._ref) : super(User.defUser) {
    initUser();
  }

  final Ref _ref;

  SharedPreferences get prefs => _ref.read(prefsProvider);

  void initUser() async {
    if (prefs.containsKey('canPlayBlackScreen')) {
      debugPrint(
          'canPlayBlackScreen=${prefs.getBool('canPlayBlackScreen').toString()}');
      copyWith(canPlayBlackScreen: prefs.getBool('canPlayBlackScreen'));
    }
  }

  void copyWith({String? name, bool? canPlayBlackScreen}) async {
    state = User(
        name: name ?? state.name,
        canPlayBlackScreen: canPlayBlackScreen ?? state.canPlayBlackScreen);

    if (canPlayBlackScreen != null) {
      await prefs.setBool('canPlayBlackScreen', canPlayBlackScreen);
      debugPrint(
          'canPlayBlackScreen=${prefs.getBool('canPlayBlackScreen').toString()}');
    }
  }
}
