import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/models/user_data.dart';
import 'package:robo_works_admin/providers/user_provider.dart';
import 'package:robo_works_admin/globals/style.dart' as style;
import 'package:robo_works_admin/services/database/user_service.dart';

class EditUserPage extends StatefulWidget {
  final UserData user;
  const EditUserPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  void editUser() async {
    UserService(uid: '').editUser(nameController.text, widget.user.id);
    context.read<UserProvider>().editUser(widget.user.id, nameController.text);
    Navigator.pop(context);
  }

  @override
  void initState() {
    nameController.text = widget.user.displayName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Edit user',
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
                    'Edit user',
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
                    editUser();
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
                      'Edit user',
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
