import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User({required String name, required bool canPlayBlackScreen}) =
      _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static User get defUser =>
      const User(name: 'AnonymousUser', canPlayBlackScreen: true);
}
