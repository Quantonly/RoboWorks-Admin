import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:robo_works_admin/pages/authentication/authentication_wrapper.dart';
import 'package:robo_works_admin/providers/project_provider.dart';
import 'package:robo_works_admin/providers/robot_provider.dart';
import 'package:robo_works_admin/providers/user_provider.dart';
import 'package:robo_works_admin/services/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const RoboWorksAdmin());
}

class RoboWorksAdmin extends StatelessWidget {
  const RoboWorksAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RobotProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'RoboWorks Admin',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthenticationWrapper(),
      ),
    );
  }
}