import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';

import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:robo_works_admin/dialogs/sort_dialog.dart';
import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/pages/projects/add_project.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/glow_behavior.dart';

import 'package:robo_works_admin/globals/style.dart' as style;

enum Status { retrieving, retrieved }

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Project> projects = [];
  Status status = Status.retrieving;
  String sort = "Name";
  List<String> dropDown = <String>[
    "Name",
    "Total robots",
  ];

  Widget getInfo(Status newStatus) {
    if (projects.isEmpty) {
      return Expanded(
        child: SizedBox(
          child: ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'No projects found',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: SizedBox(
          height: 500,
          child: ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                Project project = projects[index];
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: const Color.fromRGBO(66, 66, 66, 1),
                            trailing: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Color.fromRGBO(223, 223, 223, 1),
                              ),
                            ),
                            title: Text(
                              project.name,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Color.fromRGBO(223, 223, 223, 1),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Text(
                              "Total robots: " + project.robotCount.toString(),
                              style: const TextStyle(
                                color: Color.fromRGBO(223, 223, 223, 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    projects = context.watch<ProjectProvider>().filteredProjects;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Projects',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const SignOutDialog(),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Projects',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(223, 223, 223, 1)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const AddProjectPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("New Project"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 16.0, right: 24),
                  child: TextFormField(
                    initialValue: context.read<ProjectProvider>().currentFilter,
                    decoration: style.getTextFieldDecoration('Search projects'),
                    onChanged: (value) {
                      context.read<ProjectProvider>().filterProjects(value);
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                child: IconButton(
                  color: const Color.fromRGBO(223, 223, 223, 1),
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => SortDialog(
                        dropDown: dropDown,
                        provider: 'projects',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          getInfo(status),
        ],
      ),
    );
  }
}
