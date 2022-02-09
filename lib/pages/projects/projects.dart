import 'package:flutter/material.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
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
        children: const [
          Text('Projects'),
        ],
      ),
    );
  }
}
