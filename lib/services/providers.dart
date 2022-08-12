import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:belks_tube/models/models.dart';

final openPopupProvider = StateProvider<bool>((ref) {
  return false;
});

final userProvider = StateNotifierProvider<UserRepo, User>((ref) => UserRepo());

class UserRepo extends StateNotifier<User> {
  UserRepo() : super(User.defUser);


}
