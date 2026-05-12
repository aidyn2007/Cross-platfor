import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy/data/models/current_recipe_data.dart';
import 'package:yummy/data/repositories/memory_repository.dart';
import 'package:yummy/network/service_interface.dart';
import 'package:yummy/ui/main_screen_state.dart';

import 'components/message.dart';
import 'models/message_dao.dart';
import 'models/user_dao.dart';

final sharedPrefProvider = Provider<SharedPreferences>((ref) {
  throw Exception('SharedPreferences not initialized. Please restart the app.');
});

final bottomNavigationProvider =
    StateNotifierProvider<MainScreenStateProvider, MainScreenState>((ref) {
  return MainScreenStateProvider();
});

final repositoryProvider =
    NotifierProvider<MemoryRepository, CurrentRecipeData>(() {
  return MemoryRepository();
});

final serviceProvider = Provider<ServiceInterface>((ref) {
  throw Exception('Search service not initialized. Please restart the app.');
});

final userDaoProvider = ChangeNotifierProvider<UserDao>((ref) {
  return UserDao();
});

final messageDaoProvider = Provider<MessageDao>((ref) {
  return MessageDao(ref.watch(userDaoProvider));
});

final messageListProvider = StreamProvider<List<Message>>((ref) {
  final messageDao = ref.watch(messageDaoProvider);
  return messageDao.getMessageStream();
});
