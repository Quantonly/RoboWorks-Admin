import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/services/database/robot_service.dart';

class ProjectService {
  ProjectService();

  final CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  Future<List<Project>> getProjects() async {
    List<Project> response = await projects.get().then((snapshot) {
      List<Project> projectList = [];
      for (var project in snapshot.docs) {
        projectList.add(Project.fromMap(
            project.data() as Map<String, dynamic>, project.id));
      }
      return projectList;
    });
    return response;
  }

  Future<Project> createProject(String name) async {
    Project response =
        await projects.add({'name': name, 'robot_count': 0}).then((value) {
      Project project = Project(value.id, name, 0);
      return project;
    });
    return response;
  }

  Future<void> editProject(String name, String id) async {
    await projects.doc(id).update({'name': name});
  }

  Future<void> deleteProject(List<Robot> robots, String id) async {
    await projects.doc(id).delete();
    await RobotService().deleteProjectRobots(robots, id);
  }

  Future<void> changeRobotCount(Project project, String mode) async {
    int robotCount = project.robotCount;
    if (mode == 'add') {
      robotCount++;
    } else {
      robotCount--;
    }
    await projects.doc(project.id).update({'robot_count': robotCount});
  }
}
