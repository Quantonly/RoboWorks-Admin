import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/services/database/project_service.dart';
import 'package:robo_works_admin/globals/style.dart' as style;

class EditProjectPage extends StatefulWidget {
  final Project project;
  const EditProjectPage({Key? key, required this.project}) : super(key: key);

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  void editProject() async {
    ProjectService().editProject(nameController.text, widget.project.id);
    context.read<ProjectProvider>().editProject(widget.project.id, nameController.text);
    Navigator.pop(context);
  }

  @override
  void initState() {
    nameController.text = widget.project.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Edit project',
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
                    'Edit project',
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
                      keyboardType: TextInputType.name,
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
                    editProject();
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
                      'Edit project',
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
