import 'package:flutter/material.dart';
import 'package:robo_works_admin/models/user_data.dart';

class UserProvider with ChangeNotifier {
  List<UserData> _users = [];
  List<UserData> _filteredUsers = [];
  String currentFilter = "";
  String currentSort = "Name";

  dynamic get users => _users;
  dynamic get filteredUsers => _filteredUsers;

  void setUsers(List<UserData> users) async {
    _users = users;
    _filteredUsers = users;
    sortUsers(currentSort);
  }

  void filterUsers(filter) {
    if (filter == "") {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users
          .where((users) => users.displayName
              .toLowerCase()
              .contains(filter.toString().toLowerCase()))
          .toList();
    }
    currentFilter = filter;
    sortUsers(currentSort);
  }

  void sortUsers(sort) {
    switch (sort) {
      case "Name": {
        _filteredUsers.sort((a, b) => a.displayName.compareTo(b.displayName));
      }
      break;
      case "Email": {
        _filteredUsers.sort((a, b) => a.email.compareTo(b.email));
      }
      break;
    }
    currentSort = sort;
    notifyListeners();
  }
}
