import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:books/data/models/current_book_data.dart';
import 'package:books/data/repositories/memory_repository.dart';
import 'package:books/components/message.dart';
import 'package:books/models/message_dao.dart';
import 'package:books/network/service_interface.dart';
import 'package:books/ui/main_screen_state.dart';
import 'package:books/models/user_dao.dart';

final sharedPrefProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'SharedPreferences not initialized. Restart the app.');
});

final bottomNavigationProvider =
    StateNotifierProvider<MainScreenStateProvider, MainScreenState>((ref) {
  return MainScreenStateProvider();
});

final repositoryProvider =
    NotifierProvider<MemoryRepository, CurrentBookData>(() {
  return MemoryRepository();
});

final serviceProvider = Provider<ServiceInterface>((ref) {
  throw UnimplementedError('Search service not initialized. Restart the app.');
});

final userDaoProvider = ChangeNotifierProvider<UserDao>((ref) {
  return UserDao();
});

final messageDaoProvider = Provider<MessageDao>((ref) {
  final userDao = ref.watch(userDaoProvider);
  return MessageDao(userDao);
});

final messageListProvider = StreamProvider<List<Message>>((ref) {
  final messageDao = ref.watch(messageDaoProvider);
  return messageDao.getMessageStream();
});
