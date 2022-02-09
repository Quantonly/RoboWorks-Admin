import 'package:flutter/material.dart';
import 'package:robo_works_admin/models/robot.dart';

class RobotProvider with ChangeNotifier {
  List<Robot> _robots = [];
  List<Robot> _filteredRobots = [];
  String currentFilter = "";

  dynamic get robots => _robots;
  dynamic get filteredRobots => _filteredRobots;

  void setRobots(List<Robot> robots) async {
    _robots = robots;
    _filteredRobots = robots;
    notifyListeners();
  }

  void filterRobots(filter) {
    if (filter == "") {
      _filteredRobots = _robots;
    } else {
      _filteredRobots = _robots
          .where((robot) => robot.name
              .toLowerCase()
              .contains(filter.toString().toLowerCase()))
          .toList();
    }
    currentFilter = filter;
    notifyListeners();
  }
}
