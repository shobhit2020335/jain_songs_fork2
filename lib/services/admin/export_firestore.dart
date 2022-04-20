//Functions to export firestore datas
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jain_songs/models/user_behaviour_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportFirestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<UserBehaviourModel> allUserBehaviourList = [];

  Future<String> getUserBehaviourToJson() async {
    String jsonConverted = '';

    QuerySnapshot querySnapshot;
    querySnapshot =
        await _firebaseFirestore.collection('userSearchBehaviour').get();

    for (var query in querySnapshot.docs) {
      UserBehaviourModel userBehaviour =
          UserBehaviourModel.fromDocumentSnapshot(query);

      allUserBehaviourList.add(userBehaviour);
      jsonConverted += ', ' + jsonEncode(userBehaviour);
      print('Json converted for a user behaviour query');
    }

    return jsonConverted;
  }

  Future<void> storeInTextFile(String data) async {
    try {
      Directory? externalDirectory = await getExternalStorageDirectory();
      String path = join(externalDirectory!.path, 'user_behaviour.txt');
      File textFile = File(path);
      await textFile.writeAsString(data);
      print('successfully stored data as text file');
    } catch (e) {
      print('Error storing text in file: $e');
    }
  }

  void sendEmail(String emailBody) async {
    String subject = 'User Behaviour Data';
    String email = 'stavan.co.j@gmail.com';

    var url = 'mailto:$email?subject=$subject&body=$emailBody';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
