import 'package:chatter/core/services/shared_preferences.dart';
import 'package:chatter/features/auth/presentation/pages/login_page.dart';
import 'package:chatter/features/auth/presentation/pages/sign_up_page.dart';
import 'package:chatter/features/home/presentation/pages/home_page.dart';
import 'package:chatter/firebase_options.dart';
import 'package:chatter/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await InjectionContainer.initDependency();
  await SharedPrefs.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        SignUpPage.routeName: (context) => SignUpPage(),
        HomePage.routeName: (context) => HomePage(),
      },
      home: LoginPage(),
    );
  }
}
