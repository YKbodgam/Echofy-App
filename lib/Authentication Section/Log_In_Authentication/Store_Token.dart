import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

String generateToken() {
  const uuid = Uuid();
  return uuid.v4();
}

Future<void> storeToken(String token, String Userid) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userToken', token);
  await prefs.setString('userId', Userid);
  await prefs.setBool('firstLogin', true);
}
