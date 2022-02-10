import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/models/project.dart';
import 'package:robo_works_admin/models/robot.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';
import 'package:robo_works_admin/services/database/project_service.dart';
import 'package:robo_works_admin/services/database/robot_service.dart';

class DeleteDialog extends StatelessWidget {
  final String mode;
  final Project? project;
  final Robot? robot;
  const DeleteDialog({Key? key, required this.mode, this.project, this.robot})
      : super(key: key);

  Widget getTitle() {
    if (mode == 'project') {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Are you sure you want to delete ' + mode + ' '),
            TextSpan(
              text: project?.name ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '?'),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Are you sure you want to delete ' + mode + ' '),
            TextSpan(
              text: robot?.name ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '?'),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      title: Text('Delete ' + mode),
      content: SizedBox(
        width: double.maxFinite,
        child: getTitle(),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            Navigator.of(context).pop();
            if (mode == 'project') {
              List<Robot> robots = (context.read<RobotProvider>().robots as List<Robot>).where((robot) => robot.project == (project?.id ?? '')).toList();
              ProjectService().deleteProject(robots, project?.id ?? '');
              Navigator.of(context).pop(['delete', project?.id ?? '']);
            } else if (mode == 'robot') {
              RobotService().deleteRobot(robot?.id ?? '');
              Navigator.of(context).pop(['delete', robot?.id ?? '']);
            }
          },
        ),
      ],
    );
  }
}
