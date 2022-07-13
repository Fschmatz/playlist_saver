import 'package:shared_preferences/shared_preferences.dart';

class InitData {
   String sharedText;
   String routeName;

   InitData(this.sharedText, this.routeName);

   //test saving the last link
   final String key = 'lastSavedLink';
   SharedPreferences? prefs;

   _initPrefs() async {
     prefs ??= await SharedPreferences.getInstance();
   }

   Future<String> loadFromPrefs() async {
     await _initPrefs();
     return prefs!.getString(key) ?? 'empty';
   }

   saveToPrefs(String link) async {
     await _initPrefs();
     prefs!.setString(key, link);
   }
}





