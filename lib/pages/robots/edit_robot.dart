import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:robo_works_admin/dialogs/delete_dialog.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';
import 'package:robo_works_admin/globals/style.dart' as style;
import 'package:robo_works_admin/services/database/robot_service.dart';

class EditRobotPage extends StatefulWidget {
  final Robot robot;
  const EditRobotPage({Key? key, required this.robot}) : super(key: key);

  @override
  State<EditRobotPage> createState() => _EditRobotPageState();
}

class _EditRobotPageState extends State<EditRobotPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  void editRobot() async {
    RobotService().editRobot(nameController.text, widget.robot.id);
    context
        .read<RobotProvider>()
        .editRobot(widget.robot.id, nameController.text);
    Navigator.pop(context);
  }

  @override
  void initState() {
    nameController.text = widget.robot.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Edit robot',
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                child: const Center(
                  child: Text(
                    'Edit robot',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: style.getTextFieldDecoration('Name'),
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Invalid name'),
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    editRobot();
                  }
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                  ),
                  child: const Center(
                    child: Text(
                      'Edit robot',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => DeleteDialog(
                      mode: 'robot',
                      robot: widget.robot,
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red,
                  ),
                  child: const Center(
                    child: Text(
                      'Delete robot',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
