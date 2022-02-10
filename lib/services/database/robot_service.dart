import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/models/project.dart';

import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';
import 'package:robo_works_admin/services/database/project_service.dart';

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

  Future<Robot> createRobot(String name, Project project) async {
    Robot response = await robots.add({
      'name': name,
      'phases': {
        'phase_1': {},
        'phase_2': {},
        'phase_3': {},
        'phase_4': {},
        'phase_5': {},
      },
      'project': project.id
    }).then((value) {
      Robot robot = Robot(value.id, name, project.id);
      return robot;
    });
    await ProjectService().changeRobotCount(project, 'add');
    return response;
  }

  Future<void> editRobot(String name, String id) async {
    await robots.doc(id).update({'name': name});
  }

  Future<void> deleteRobot(String id) async {
    await robots.doc(id).delete();
    //context.read<RobotProvider>().deleteRobot(id);
  }

  Future<void> deleteProjectRobots(List<Robot> robots, String id) async {
    for (var robot in robots) { 
      deleteRobot(robot.id);
    }
  }
}