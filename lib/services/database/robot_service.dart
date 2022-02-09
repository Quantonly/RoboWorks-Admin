import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:robo_works_admin/models/robot.dart';

class RobotService {
  RobotService();

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference robots =
      FirebaseFirestore.instance.collection('robots');

  Future<List<Robot>> getRobots() async {
    List<Robot> response = await robots.get().then((snapshot) {
      List<Robot> robotList = [];
      for (var robot in snapshot.docs) {
        robotList.add(Robot.fromMap(robot.data() as Map<String, dynamic>, robot.id));
      }
      return robotList;
    });
    return response;
  }
}