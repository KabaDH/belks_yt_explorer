class User {
  final String name;
  final bool canPlayBlackScreen;

  User(this.name, this.canPlayBlackScreen);

  static get defUser => User('AnonymousUser', false);
}
