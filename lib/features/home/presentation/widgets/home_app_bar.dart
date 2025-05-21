import 'package:chatter/features/home/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.isChatTab});
  final bool isChatTab;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(isChatTab ? 'Chats' : 'Profile'),
      centerTitle: true,
      actions: isChatTab
          ? [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () =>
                    Navigator.pushNamed(context, SearchPage.routeName),
              ),
            ]
          : null,
    );
  }
}
