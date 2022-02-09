import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/providers/project_provider.dart';

class ProjectService {
  ProjectService();

  final CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  Future<List<Project>> getProjects() async {
    List<Project> response = await projects.get().then((snapshot) {
      List<Project> projectList = [];
      for (var project in snapshot.docs) {
        projectList.add(Project.fromMap(project.data() as Map<String, dynamic>, project.id));
      }
      return projectList;
    });
    return response;
  }

  Future<void> createProject(BuildContext context, String name) async {
    await projects.add({
      'name': name,
      'robot_count': 0
    }).then((value) {
      Project project = Project(value.id, name, 0);
      context.read<ProjectProvider>().addProject(project);
    });
  }
}
