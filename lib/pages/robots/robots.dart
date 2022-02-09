import 'package:flutter/material.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';

class RobotsPage extends StatefulWidget {
  const RobotsPage({Key? key}) : super(key: key);

  @override
  State<RobotsPage> createState() => _RobotsPageState();
}

class _RobotsPageState extends State<RobotsPage> {
  @override
  Widget build(BuildContext context) {
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
        children: const [
          Text('Robots'),
        ],
      ),
    );
  }
}
