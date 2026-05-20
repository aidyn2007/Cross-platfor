import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers.dart';

class ProfileState {
  final String firstName;
  final String lastName;

  ProfileState({this.firstName = '', this.lastName = ''});

  ProfileState copyWith({String? firstName, String? lastName}) {
    return ProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final SharedPreferences _prefs;

  ProfileNotifier(this._prefs) : super(ProfileState()) {
    _loadProfile();
  }

  static const _keyFirstName = 'profile_first_name';
  static const _keyLastName = 'profile_last_name';

  void _loadProfile() {
    state = ProfileState(
      firstName: _prefs.getString(_keyFirstName) ?? '',
      lastName: _prefs.getString(_keyLastName) ?? '',
    );
  }

  Future<void> updateName(String firstName, String lastName) async {
    await _prefs.setString(_keyFirstName, firstName);
    await _prefs.setString(_keyLastName, lastName);
    state = state.copyWith(firstName: firstName, lastName: lastName);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final prefs = ref.watch(sharedPrefProvider);
  return ProfileNotifier(prefs);
});
