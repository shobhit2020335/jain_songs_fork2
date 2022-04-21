import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:jain_songs/services/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CloudStorage {
  final Reference _firebaseStorageReference = FirebaseStorage.instance.ref();

  Future<void> downloadPost() async {
    bool isStoragePermissionGranted =
        await Services.requestPermission(Permission.storage);

    if (isStoragePermissionGranted == false) {
      print('Permission not granted for storage');
      return;
    }

    final postRef =
        _firebaseStorageReference.child('posts/happy paryushan.jpg');
    final appDocDir = await getExternalStorageDirectory();
    await Directory(appDocDir!.path + '/' + 'posts')
        .create(recursive: true)
        .then((Directory directory) {
      print('Path of New Dir: ' + directory.path);
    });
    String filePath = join(appDocDir.path, 'posts/happy paryushan.jpg');
    final file = File(filePath);

    if (!await file.exists()) {
      print('Post File does not exists, creating');
      await file.create(recursive: true);
      await postRef.writeToFile(file);
    }
    FlutterShareMe().shareToWhatsApp(imagePath: filePath, msg: 'Ye rhi image');
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
      print('Error uploading image: $e');
      return 'Error in upload';
    }
  }
}
