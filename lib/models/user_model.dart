class User {
  final String name;
  final bool canPlayBlackScreen;

  User({required this.name, this.canPlayBlackScreen = false});

  static User get defUser => User(name: 'AnonymousUser');
}
