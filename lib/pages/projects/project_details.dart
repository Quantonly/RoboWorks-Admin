import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/dialogs/delete_dialog.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:robo_works_admin/glow_behavior.dart';
import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/pages/projects/edit_project.dart';
import 'package:robo_works_admin/pages/robots/add_robot.dart';
import 'package:robo_works_admin/pages/robots/edit_robot.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';
import 'package:robo_works_admin/globals/style.dart' as style;

class ProjectDetailsPage extends StatefulWidget {
  final Project project;
  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  String projectName = '';
  List<Robot> robots = [];
  List<Project> projects = [];

  Widget getInfo() {
    if (robots.isEmpty) {
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
                          'No robots found',
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
              itemCount: robots.length,
              itemBuilder: (context, index) {
                Robot robot = robots[index];
                Project project = projects
                    .firstWhere((project) => project.id == robot.project);
                Color titleColor = const Color.fromRGBO(223, 223, 223, 1);
                Color subtitleColor = const Color.fromRGBO(223, 223, 223, 0.7);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: EditRobotPage(
                          robot: robot,
                        ),
                      ),
                    ).then((data) {
                      if (data != null) {
                        List<String> newData = data;
                        if (newData[0] == 'delete') {
                          context.read<RobotProvider>().deleteRobot(newData[1]);
                        }
                      }
                    });
                  },
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
                                Icons.edit,
                                color: Color.fromRGBO(223, 223, 223, 1),
                              ),
                            ),
                            title: Text(
                              robot.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Text(
                              project.name,
                              style: TextStyle(
                                color: subtitleColor,
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (projects.any((project) => project.id == widget.project.id)) {
      projectName = projects
          .firstWhere((project) => project.id == widget.project.id)
          .name;
    }
    robots = (context.watch<RobotProvider>().filteredRobots as List<Robot>)
        .where((robot) => robot.project == widget.project.id)
        .toList();
    projects = context.read<ProjectProvider>().projects;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Project details',
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Project name: ' + projectName,
                      style: const TextStyle(
                        color: Color.fromRGBO(223, 223, 223, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EditProjectPage(project: widget.project),
                          ),
                        ).then((value) => setState(() {}));
                      },
                      child: const Icon(
                        Icons.edit,
                        color: Color.fromRGBO(223, 223, 223, 1),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => DeleteDialog(
                        mode: 'project',
                        project: widget.project,
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Robots',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(223, 223, 223, 1)),
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
                        child: AddRobotPage(
                          project: widget.project,
                        ),
                      ),
                    ).then((value) => setState(() {}));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("New robot"),
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
                    initialValue: context.read<RobotProvider>().currentFilter,
                    decoration: style.getTextFieldDecoration('Search robots'),
                    onChanged: (value) {
                      context.read<RobotProvider>().filterRobots(value);
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          getInfo(),
        ],
      ),
    );
  }
}
