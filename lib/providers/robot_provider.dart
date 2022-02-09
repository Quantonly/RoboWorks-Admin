import 'package:flutter/material.dart';
import 'package:robo_works_admin/models/robot.dart';

class RobotProvider with ChangeNotifier {
  List<Robot> _robots = [];
  List<Robot> _filteredRobots = [];
  String currentFilter = "";
  String currentSort = "Name";

  dynamic get robots => _robots;
  dynamic get filteredRobots => _filteredRobots;

  void setRobots(List<Robot> robots) async {
    _robots = robots;
    _filteredRobots = robots;
    sortRobots(currentSort);
  }

  void addRobot(Robot robot) {
    _robots.add(robot);
    filterRobots(currentFilter);
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
    sortRobots(currentSort);
  }

  void sortRobots(sort) {
    switch (sort) {
      case "Name": {
        _filteredRobots.sort((a, b) => a.name.compareTo(b.name));
      }
      break;
    }
    currentSort = sort;
    notifyListeners();
  }
}
