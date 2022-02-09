import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:robo_works_admin/models/user_data.dart';

import 'package:robo_works_admin/pages/authentication/sign_in.dart';
import 'package:robo_works_admin/pages/dashboard.dart';
import 'package:robo_works_admin/services/authentication.dart';
import 'package:robo_works_admin/services/database/user_service.dart';
import 'package:robo_works_admin/globals/data.dart' as data;

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return FutureBuilder<String>(
        future: _reviewRole(firebaseUser),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'isAdmin') return const DashboardPage();
          }
          return const SignInPage(error: 'Not authorized');
        },
      );
    }
    return const SignInPage();
  }

  Future<String> _reviewRole(User? firebaseUser) async {
    UserData userData = await UserService(uid: firebaseUser!.uid).getUserData();
    if (userData.role != 'admin') {
      context.read<AuthenticationService>().signOut();
      return '';
    }
    data.displayName = userData.displayName;
    return 'isAdmin';
  }
}
