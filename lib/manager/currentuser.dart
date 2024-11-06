class CurrentUser {
  String? uid;
  String? role;
  String? name;
  static final CurrentUser _singleton = CurrentUser._internal();

  factory CurrentUser() {
    return _singleton;
  }

  CurrentUser._internal();
}
