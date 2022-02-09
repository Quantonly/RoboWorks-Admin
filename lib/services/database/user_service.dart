import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:robo_works_admin/models/user_data.dart';

class UserService {
  final String uid;
  UserService({required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<UserData> getUserData() async {
    UserData response = await users.doc(uid).get().then((snapshot) {
      UserData userData = UserData.fromMap(snapshot.data() as Map<String, dynamic>, uid);
      return userData;
    });
    return response;
  }

  Future<List<UserData>> getUsers() async {
    List<UserData> response = await users.get().then((snapshot) {
      List<UserData> userList = [];
      for (var user in snapshot.docs) {
        userList.add(UserData.fromMap(user.data() as Map<String, dynamic>, user.id));
      }
      return userList;
    });
    return response;
  }
}
