import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:jain_songs/models/post_model.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CloudStorage {
  final Reference _firebaseStorageReference = FirebaseStorage.instance.ref();

  //Show the user info of downloading
  Future<bool> downloadPost(PostModel postModel) async {
    try {
      final postRef =
          _firebaseStorageReference.child('posts/${postModel.fileName}');

      //Gives the internal storage dierctory
      Directory applicationInternalDirectory =
          await getApplicationDocumentsDirectory();
      //Create posts folder in the internal storage directory
      await Directory(applicationInternalDirectory.path + '/' + 'posts')
          .create(recursive: true)
          .then((Directory directory) {
        debugPrint('Path of New Dir for posts: ${directory.path}');
      });

      // final appDocDir = await getExternalStorageDirectory();
      // await Directory(appDocDir!.path + '/' + 'posts')
      //     .create(recursive: true)
      //     .then((Directory directory) {
      //   debugPrint('Path of New Dir: ' + directory.path);
      // });
      String filePath = join(
          applicationInternalDirectory.path, 'posts/${postModel.fileName}');
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
      //Handles the corrupt file and deletes it.
      Directory applicationInternalDirectory =
          await getApplicationDocumentsDirectory();
      String filePath = join(
          applicationInternalDirectory.path, 'posts/${postModel.fileName}');
      final file = File(filePath);

      if (await file.exists()) {
        debugPrint('Corrupt post file exist, deleting');
        await file.delete();
        //TODO: Can add recursive function to this function here to try applying status again
      }

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
