import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  late SharedPreferences _sharedPreferences;

  static final SharedPreferenceService _inst =
      SharedPreferenceService._internal();

  SharedPreferenceService._internal();

  SharedPreferences get instance => _sharedPreferences;

  factory SharedPreferenceService([SharedPreferences? sharedPreferences]) {
    if (sharedPreferences != null) _inst._sharedPreferences = sharedPreferences;
    return _inst;
  }
}
