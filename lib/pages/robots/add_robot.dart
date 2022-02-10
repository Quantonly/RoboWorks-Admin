import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:robo_works_admin/globals/style.dart' as style;
import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';
import 'package:robo_works_admin/services/database/robot_service.dart';
import 'package:provider/provider.dart';

class AddRobotPage extends StatefulWidget {
  final Project? project;
  const AddRobotPage({Key? key, this.project}) : super(key: key);

  @override
  State<AddRobotPage> createState() => _AddRobotPageState();
}

class _AddRobotPageState extends State<AddRobotPage> {
  final _formKey = GlobalKey<FormState>();
  List<Project> projects = [];
  String dropdownValue = '';
  List<String> projectIds = [];

  final TextEditingController nameController = TextEditingController();

  void createRobot() async {
    Project project =
        (context.read<ProjectProvider>().projects as List<Project>)
            .firstWhere((project) => project.id == dropdownValue);
    Robot robot = await RobotService().createRobot(nameController.text, project);
    context.read<RobotProvider>().addRobot(robot);
    context.read<ProjectProvider>().changeRobotCount(robot.project, 'add');
    Navigator.pop(context);
  }

  void setLists() {
    if (projectIds.isEmpty) {
      projects = context.read<ProjectProvider>().projects;
      for (var project in projects) {
        projectIds.add(project.id);
      }
      dropdownValue = projectIds[0];
      if (widget.project != null) dropdownValue = widget.project!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    setLists();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Create robot',
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
                    'Create new robot',
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
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: projectIds.map((String id) {
                      Project project =
                          projects.firstWhere((project) => project.id == id);
                      return DropdownMenuItem<String>(
                        value: project.id,
                        child: Text(project.name),
                      );
                    }).toList(),
                  ),
                ]),
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    createRobot();
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
                      'Create robot',
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
