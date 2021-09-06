import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  FirebaseStorage _songSuggestionStorage = FirebaseStorage.instance;

  Future<String> uploadSuggestionImage(
      File? imageFile, String? fileName) async {
    if (imageFile == null || fileName == null) {
      return '';
    }
    try {
      TaskSnapshot uploadTask = await _songSuggestionStorage
          .ref()
          .child('song_suggestions')
          .child(fileName)
          .putFile(imageFile);

      String imageURL = await uploadTask.ref.getDownloadURL();
      print('Image Uploaded: $imageURL');
      return imageURL;
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
      return 'Error in upload';
    }
  }
}
