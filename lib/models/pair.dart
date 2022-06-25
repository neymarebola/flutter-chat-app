class Pair {
  String? uid;
  String? username;
  get getUid => this.uid;

  set setUid(uid) => this.uid = uid;

  get getUsername => this.username;

  set setUsername(username) => this.username = username;

  Pair(String uid, String username) {
    this.uid = uid;
    this.username = username;
  }
}
