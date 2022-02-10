import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/dialogs/sign_out_dialog.dart';
import 'package:robo_works_admin/dialogs/sort_dialog.dart';
import 'package:robo_works_admin/glow_behavior.dart';
import 'package:robo_works_admin/models/user_data.dart';
import 'package:robo_works_admin/globals/style.dart' as style;
import 'package:robo_works_admin/pages/users/add_user.dart';
import 'package:robo_works_admin/providers/user_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserData> users = [];
  String sort = "Name";
  List<String> dropDown = <String>[
    "Name",
    "Email",
  ];

  Widget getInfo() {
    if (users.isEmpty) {
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
                          'No users found',
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
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserData user = users[index];
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
                            trailing: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                Icons.edit,
                                color: Color.fromRGBO(223, 223, 223, 1),
                              ),
                            ),
                            title: Text(
                              user.displayName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Text(
                              user.email,
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
    users = context.watch<UserProvider>().filteredUsers;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(40, 40, 40, 1),
        title: const Text(
          'Users',
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
                  'Users',
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
                        child: const AddUserPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("New user"),
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
                    initialValue: context.read<UserProvider>().currentFilter,
                    decoration: style.getTextFieldDecoration('Search users'),
                    onChanged: (value) {
                      context.read<UserProvider>().filterUsers(value);
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
                        provider: 'users',
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
