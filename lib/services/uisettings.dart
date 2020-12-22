import 'package:flutter_windowmanager/flutter_windowmanager.dart';

//This method disables taking ss and srec.
Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}