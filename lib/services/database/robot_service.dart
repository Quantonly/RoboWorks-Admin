import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';

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

  Future<void> createRobot(BuildContext context, String name, String project) async {
    await robots.add({
      'name': name,
      'phases': {
        'phase_1': {},
        'phase_2': {},
        'phase_3': {},
        'phase_4': {},
        'phase_5': {},
      },
      'project': project
    }).then((value) {
      Robot robot = Robot(value.id, name, project);
      context.read<RobotProvider>().addRobot(robot);
    });
  }
}