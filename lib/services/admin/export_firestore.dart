//Functions to export firestore datas
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jain_songs/models/user_behaviour_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportFirestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<UserBehaviourModel> allUserBehaviourList = [];

  //This functions also deletes the fetched data.
  Future<String> getUserBehaviourToJson({int countOfDataToFetch = 10}) async {
    try {
      String jsonConverted = '';
      allUserBehaviourList.clear();

      QuerySnapshot querySnapshot;
      querySnapshot = await _firebaseFirestore
          .collection('userSearchBehaviour')
          .limit(countOfDataToFetch)
          .get();

      debugPrint("Fetched $countOfDataToFetch datas");

      for (var query in querySnapshot.docs) {
        UserBehaviourModel userBehaviour =
            UserBehaviourModel.fromDocumentSnapshot(query);

        allUserBehaviourList.add(userBehaviour);
        jsonConverted += ', ' + jsonEncode(userBehaviour.toJson());
        debugPrint('Json converted for a user behaviour query');
      }

      debugPrint(
          'Deleting the $countOfDataToFetch datas fetched. Dont forget to store them in text file');

      for (int i = 0; i < allUserBehaviourList.length; i++) {
        bool isSuccess =
            await deleteUserBehaviourData(allUserBehaviourList[i].code);
        debugPrint('Delete of song ${i + 1}: $isSuccess');
      }

      return jsonConverted;
    } catch (e) {
      debugPrint('Error fetching and deleting user behaviour: $e');
      return 'Error fetching data: $e';
    }
  }

  //Deletes the user behavoiur data one by one
  Future<bool> deleteUserBehaviourData(String code) async {
    bool isSuccess = true;

    try {
      await _firebaseFirestore
          .collection('userSearchBehaviour')
          .doc(code)
          .delete();
    } catch (e) {
      print('Error deleting the data: $e');
      isSuccess = false;
    }

    return isSuccess;
  }

  Future<String> storeInTextFile(String data) async {
    try {
      //TODO: Add external sotrage permissions to use this.
      Directory? externalDirectory = await getExternalStorageDirectory();
      String path = join(externalDirectory!.path, 'user_behaviour.txt');
      File textFile = File(path);
      await textFile.writeAsString(data);
      debugPrint('successfully stored data as text file');
      return 'Storing success: $path';
    } catch (e) {
      debugPrint('Error storing text in file: $e');
      return 'Error storing: $e';
    }
  }

  //Not used anyhwere for now.
  void sendEmail(String emailBody) async {
    String subject = 'User Behaviour Data';
    String email = 'stavan.co.j@gmail.com';

    String url = 'mailto:$email?subject=$subject&body=$emailBody';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
