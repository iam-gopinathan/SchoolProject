class UserSession {
  static final UserSession _instance = UserSession._internal();

  String? rollNumber;
  String? userType;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  void setUserInfo(String rollNumber, String userType) {
    this.rollNumber = rollNumber;
    this.userType = userType;
  }

  void clearSession() {
    rollNumber = null;
    userType = null;
  }
}
