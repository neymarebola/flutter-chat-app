import 'package:chat/models/usermodel.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseMethods {
  FirebaseDatabase ref = FirebaseDatabase.instance;

  getUserByUsername(String username) {}

  uploadUserInfo(UserModel user) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users");
    await ref.push().set(user);
  }
}

void main(List<String> args) {
  UserModel user = new UserModel("duong", "duong@gmail.com", "123456");
  DatabaseMethods databaseMethods = new DatabaseMethods();
  databaseMethods.uploadUserInfo(user);
}
