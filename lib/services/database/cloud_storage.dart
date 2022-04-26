import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:jain_songs/models/post_model.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CloudStorage {
  final Reference _firebaseStorageReference = FirebaseStorage.instance.ref();

  //Show the user info of downloading
  Future<bool> downloadPost(PostModel postModel) async {
    try {
      bool isStoragePermissionGranted =
          await Services.requestPermission(Permission.storage);

      if (isStoragePermissionGranted == false) {
        debugPrint('Permission not granted for storage');
        return false;
      }

      final postRef =
          _firebaseStorageReference.child('posts/${postModel.fileName}');
      final appDocDir = await getExternalStorageDirectory();
      await Directory(appDocDir!.path + '/' + 'posts')
          .create(recursive: true)
          .then((Directory directory) {
        debugPrint('Path of New Dir: ' + directory.path);
      });
      String filePath = join(appDocDir.path, 'posts/${postModel.fileName}');
      final file = File(filePath);

      if (!await file.exists()) {
        debugPrint('Post File does not exists, creating');
        await file.create(recursive: true);
        await postRef.writeToFile(file);
      }
      FlutterShareMe().shareToWhatsApp(
          imagePath: filePath,
          msg:
              '${postModel.descriptionTitle} Download Stavan App: ${Globals.getAppPlayStoreUrl()}');
      return true;
    } catch (e) {
      debugPrint('Error in download post: $e');
      return false;
    }
  }

  //To upload the song suggestion images given by the users
  Future<String> uploadSuggestionImage(
      File? imageFile, String? fileName) async {
    if (imageFile == null || fileName == null) {
      return '';
    }
    try {
      TaskSnapshot uploadTask = await _firebaseStorageReference
          .child('song_suggestions')
          .child(fileName)
          .putFile(imageFile);

      String imageURL = await uploadTask.ref.getDownloadURL();
      return imageURL;
    } on FirebaseException catch (e) {
      debugPrint('Error uploading image: $e');
      return 'Error in upload';
    }
  }
}
