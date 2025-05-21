import 'package:chatter/features/auth/presentation/cubits/cubit/auth_cubit.dart';
import 'package:chatter/features/home/presentation/widgets/chats_body.dart';
import 'package:chatter/features/home/presentation/widgets/custom_nav_bar.dart';
import 'package:chatter/features/home/presentation/widgets/home_app_bar.dart';
import 'package:chatter/features/home/presentation/widgets/profile_body.dart';
import 'package:chatter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/Home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool isChatTab = _currentIndex == 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: HomeAppBar(isChatTab: isChatTab),
      ),
      bottomNavigationBar: CustomNavBar(
        onTapped: (index) => setState(
          () => _currentIndex = index,
        ),
      ),
      body: isChatTab ? ChatsBody() : ProfileBody(),
    );
  }
}
