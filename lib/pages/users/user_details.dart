import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/dialogs/delete_dialog.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:robo_works_admin/dialogs/sort_dialog.dart';
import 'package:robo_works_admin/glow_behavior.dart';
import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/models/user_data.dart';
import 'package:robo_works_admin/pages/users/edit_user.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/globals/style.dart' as style;
import 'package:robo_works_admin/providers/user_provider.dart';
import 'package:robo_works_admin/services/database/user_service.dart';

class UserDetailsPage extends StatefulWidget {
  final UserData user;
  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  List<Project> projects = [];
  String sort = "Name";
  List<String> dropDown = <String>[
    "Name",
    "Total robots",
  ];
  List<String> projectIds = [];
  List<bool> checkbox = [];

  Widget getInfo() {
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
                int projectIdIndex = projectIds.indexOf(project.id);
                Color titleColor = const Color.fromRGBO(223, 223, 223, 1);
                Color subtitleColor = const Color.fromRGBO(223, 223, 223, 0.7);
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: const Color.fromRGBO(66, 66, 66, 1),
                            trailing: Checkbox(
                              checkColor: Colors.white,
                              value: checkbox[projectIdIndex],
                              onChanged: (bool? value) {
                                setState(() {
                                  checkbox[projectIdIndex] =
                                      !checkbox[projectIdIndex];
                                });
                              },
                            ),
                            title: Text(
                              project.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Text(
                              'Total robots: ' + project.robotCount.toString(),
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
    getCheckList();
    super.initState();
  }

  void getCheckList() {
    List<Project> allProjects = context.read<ProjectProvider>().projects;
    for (var project in allProjects) {
      projectIds.add(project.id);
      checkbox.add(widget.user.projects.contains(project.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    projects = context.watch<ProjectProvider>().filteredProjects;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'User details',
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
                      'User name: ' + widget.user.displayName,
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
                            child: EditUserPage(user: widget.user),
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
                        mode: 'user',
                        user: widget.user,
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
                  'Projects',
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
                    List<String> ids = [];
                    int index = 0;
                    for (var check in checkbox) {
                      if (check) ids.add(projectIds[index]);
                      index++;
                    }
                    UserService(uid: '')
                        .editGrantedProjects(widget.user.id, ids);
                    context
                        .read<UserProvider>()
                        .editGrantedProjects(widget.user.id, ids);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Save"),
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
          getInfo(),
        ],
      ),
    );
  }
}
