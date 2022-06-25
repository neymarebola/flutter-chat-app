class UserModel {
  String? userId;
  String? username;
  String? email;
  String? password;

  UserModel(String username, String email, String password) {
    this.username = username;
    this.email = email;
    this.password = password;
  }

  get getUserId => this.userId;

  set setUserId(userId) => this.userId = userId;

  get getUsername => this.username;

  set setUsername(username) => this.username = username;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getPassword => this.password;

  set setPassword(password) => this.password = password;
}
