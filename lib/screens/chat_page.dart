import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/login.dart';
import '../components/message_list.dart';
import '../providers.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDao = ref.watch(userDaoProvider);

    if (!userDao.isLoggedIn()) {
      return const Login();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  userDao.email() ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              IconButton(
                tooltip: 'Log out of chat',
                onPressed: userDao.logout,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        const Expanded(child: MessageList()),
      ],
    );
  }
}
