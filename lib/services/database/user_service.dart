import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:robo_works_admin/models/user_data.dart';

class UserService {
  final String uid;
  UserService({required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<UserData> getUserData() async {
    UserData response = await users.doc(uid).get().then((snapshot) {
      UserData userData =
          UserData.fromMap(snapshot.data() as Map<String, dynamic>, uid);
      return userData;
    });
    return response;
  }

  Future<List<UserData>> getUsers() async {
    List<UserData> response = await users.get().then((snapshot) {
      List<UserData> userList = [];
      for (var user in snapshot.docs) {
        userList.add(
            UserData.fromMap(user.data() as Map<String, dynamic>, user.id));
      }
      return userList;
    });
    return response;
  }

  Future<UserData> createUser(String id, String name, String email) async {
    UserData response = await users.doc(id).set({
      'displayName': name,
      'email': email,
      'projects': [],
      'role': 'user'
    }).then((value) {
      UserData user = UserData(id, name, email, 'user', []);
      return user;
    });
    return response;
  }

  Future<void> editUser(String name, String id) async {
    await users.doc(id).update({'displayName': name});
  }

  Future<void> editGrantedProjects(String id, List<String> ids) async {
    await users.doc(id).update({'projects': ids});
  }

  Future<void> deleteUser(String id) async {
    await users.doc(id).delete();
  }
}
