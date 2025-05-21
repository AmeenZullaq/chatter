import 'package:chatter/core/constants/app_keys.dart';
import 'package:chatter/core/constants/boxes.dart';
import 'package:chatter/core/services/hive_database.dart';
import 'package:chatter/features/auth/data/models/user_model.dart';
import 'package:chatter/features/auth/presentation/pages/login_page.dart';
import 'package:chatter/features/home/presentation/pages/home_page.dart';
import 'package:chatter/injection_container.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const routName = '/Splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    excuteNavigation();
  }

  excuteNavigation() async {
    return Future.delayed(const Duration(seconds: 4), () async {
      UserModel? user = await getIt<HiveDatabase>().get<UserModel>(
        boxName: Boxes.users,
        key: AppKeys.userData,
      );
      if (mounted) {
        if (user != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.routeName,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPage.routeName,
            (route) => false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text(
        'Chatter',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}
