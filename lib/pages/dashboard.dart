import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:robo_works_admin/globals/data.dart' as data;
import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/models/user_data.dart';
import 'package:robo_works_admin/pages/projects/projects.dart';
import 'package:robo_works_admin/pages/robots/robots.dart';
import 'package:robo_works_admin/pages/users/users.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';
import 'package:robo_works_admin/providers/user_provider.dart';
import 'package:robo_works_admin/services/database/project_service.dart';
import 'package:robo_works_admin/services/database/robot_service.dart';
import 'package:robo_works_admin/services/database/user_service.dart';

enum Status { retrieving, retrieved }

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Status status = Status.retrieving;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    List<UserData> users = await UserService(uid: '').getUsers();
    context.read<UserProvider>().setUsers(users);
    List<Project> projects = await ProjectService().getProjects();
    context.read<ProjectProvider>().setProjects(projects);
    List<Robot> robots = await RobotService().getRobots();
    context.read<RobotProvider>().setRobots(robots);
    setState(() {
      status = Status.retrieved;
    });
  }

  Widget getInfo(Status newStatus) {
    if (newStatus == Status.retrieving) {
      return const Expanded(
        child: SizedBox(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Expanded(
        child: SizedBox(
          height: 500,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const UsersPage(),
                    ),
                  ).then((value) => setState(() {}));
                },
                child: Container(
                  height: 90,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(66, 66, 66, 1),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFA4CDFF).withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Color(0xFFA4CDFF),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Users',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Color.fromRGBO(223, 223, 223, 1),
                                    ),
                                  ),
                                  Text(
                                    (context.read<UserProvider>().users as List<UserData>).length.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(223, 223, 223, 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.more_vert,
                            color: Colors.white54,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const ProjectsPage(),
                          ),
                        ).then((value) => setState(() {}));
                      },
                      child: Container(
                        height: 150,
                        margin:
                            const EdgeInsets.only(left: 20, right: 5, top: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(66, 66, 66, 1),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFA113)
                                        .withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.book,
                                    size: 20,
                                    color: Color(0xFFFFA113),
                                  ),
                                ),
                                const Icon(
                                  Icons.more_vert,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            const Text(
                              'Projects',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                color: Color.fromRGBO(223, 223, 223, 1),
                              ),
                            ),
                            Text(
                              (context.read<ProjectProvider>().projects as List<Project>).length.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(223, 223, 223, 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const RobotsPage(),
                          ),
                        ).then((value) => setState(() {}));
                      },
                      child: Container(
                        height: 150,
                        margin:
                            const EdgeInsets.only(right: 20, left: 5, top: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(66, 66, 66, 1),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF007EE5)
                                        .withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.power,
                                    size: 20,
                                    color: Color(0xFF007EE5),
                                  ),
                                ),
                                const Icon(
                                  Icons.more_vert,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            const Text(
                              'Robots',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                color: Color.fromRGBO(223, 223, 223, 1),
                              ),
                            ),
                            Text(
                              (context.read<RobotProvider>().robots as List<Robot>).length.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(223, 223, 223, 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Dashboard',
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
          Column(
            children: [
              Text(
                'Welcome, ' + data.displayName,
                style: const TextStyle(
                  color: Color.fromRGBO(223, 223, 223, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          getInfo(status),
        ],
      ),
    );
  }
}
