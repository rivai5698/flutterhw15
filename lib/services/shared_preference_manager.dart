import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager{
  static final _manager = SharedPreferencesManager._internal();
  factory SharedPreferencesManager() => _manager;
  SharedPreferencesManager._internal();

  SharedPreferences? _prefs;

  Future init() async{
    await SharedPreferences.getInstance().then((value){
      _prefs = value;
    });
  }

  Future remove(String key)async{
    await _prefs?.remove(key);
  }

  Future setString(String key, String value) async{
    await _prefs?.setString(key, value);
  }

  Future<String?> getString(String key)async{
    return _prefs?.getString(key);
  }


  Future setStringList(String key, List<String> value) async{
    await _prefs?.setStringList(key, value);
  }
  Future<List<String>?> getStringList(String key)async{
    return _prefs?.getStringList(key);
  }



  Future setBool(String key, bool value) async{
    await _prefs?.setBool(key, value);
  }
  Future<bool?> getBool(String key)async{
    return _prefs?.getBool(key);
  }

  Future setInt(String key, int value) async{
    await _prefs?.setInt(key, value);
  }
  Future<int?> getInt(String key)async{
    return _prefs?.getInt(key);
  }


}

SharedPreferencesManager sharedPrefs = SharedPreferencesManager();