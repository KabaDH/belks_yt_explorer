import 'package:belks_tube/data/repo/repo.dart';
import 'package:belks_tube/domain/user/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider =
    StateNotifierProvider<UserRepo, User>((ref) => UserRepo(ref));

class UserRepo extends StateNotifier<User> {
  UserRepo(this._ref) : super(User.defUser) {
    initUser();
  }

  final Ref _ref;

  Repo get repo => _ref.read(repoProvider);

  /// TODO store full User model with toJson
  void initUser() async {
    final canPlayBlackScreen = repo.getUser();
    state = state.copyWith(canPlayBlackScreen: canPlayBlackScreen);
  }

  void setCanPlayBlackScreen(bool v) {
    state = state.copyWith(canPlayBlackScreen: v);
    repo.setUserCanPlayBlackScreen(v);
  }
}
