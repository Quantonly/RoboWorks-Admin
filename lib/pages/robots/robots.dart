import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:robo_works_admin/glow_behavior.dart';
import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/pages/robots/add_robot.dart';
import 'package:robo_works_admin/pages/robots/edit_robot.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';
import 'package:robo_works_admin/globals/style.dart' as style;

class RobotsPage extends StatefulWidget {
  const RobotsPage({Key? key}) : super(key: key);

  @override
  State<RobotsPage> createState() => _RobotsPageState();
}

class _RobotsPageState extends State<RobotsPage> {
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
  Widget build(BuildContext context) {
    robots = context.watch<RobotProvider>().filteredRobots;
    projects = context.read<ProjectProvider>().projects;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Robots',
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
                    if (projects.isNotEmpty) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const AddRobotPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'You first need to create a project',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
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
