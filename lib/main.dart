import 'package:flutter/material.dart';

void main() {
  runApp(const RoboWorksAdmin());
}

class RoboWorksAdmin extends StatelessWidget {
  const RoboWorksAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoboWorks Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Dashboard(title: 'Flutter Demo Home Page'),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[],
        ),
      ),
    );
  }
}