import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:device_info/device_info.dart';

class Services {
  static String urlBeforeCode =
      'https://stavan.page.link/?link=https://stavan.com/song?route%3Dsong%26code%3D';
  static String urlAfterCode =
      '&apn=com.JainDevelopers.jain_songs&amv=4&st=Stavan+-+Jain+Bhajan+with+Lyrics&sd=Listen+to+Jain+stavan+along+with+lyrics.&si=https://pbs.twimg.com/media/EfXqpDHUwAAVQHa.jpg';

  //Asks for permission to user.
  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();

      if (result == PermissionStatus.granted) {
        return true;
      } else {
        result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      }
    }
    return false;
  }

  //Important to note code inside.
  static Future<ImageSource?> showImageSourceDialog(
      BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text(
                'Camera',
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              onTap: () {
                debugPrint('onTap');
                return Navigator.of(context).pop(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_rounded),
              title: Text(
                'Gallery (Select multiple images)',
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              onTap: () {
                return Navigator.of(context).pop(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  static Future<File?> pickSingleImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      final imagePermanent = await saveImagePermanently(image.path);
      return imagePermanent;
    } on Exception catch (e) {
      debugPrint('Failed to pick Image: $e');
      return null;
    }
  }

  static Future<List<File>> pickMultipleImages() async {
    try {
      final images = await ImagePicker().pickMultiImage();
      if (images.isEmpty) {
        return [];
      }

      List<File> imagesPermanent = [];
      for (int i = 0; i < images.length; i++) {
        imagesPermanent.add(await saveImagePermanently(images[i].path));
      }
      return imagesPermanent;
    } on Exception catch (e) {
      debugPrint('Failed to pick multiple Images: $e');
      return [];
    }
  }

  static void launchPlayStore(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      FirebaseCrashlytics.instance.log('Error on clicking update in dialog');
    }
  }

  static void shareApp(String? name, String? code) async {
    if (name != null && code != null) {
      await FlutterShare.share(
        title: 'Google Play link',
        text: 'Find lyrics and listen to *$name* and other *Jain bhajans* on:',
        linkUrl: '$urlBeforeCode$code$urlAfterCode',
      );
    }
  }

  static void sendEmail() async {
    String subject = 'Feedback and Support: ';
    String email = 'stavan.co.j@gmail.com';

    // Code to get system info for android.
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    debugPrint('Running on ${androidInfo.model}');

    String body =
        '${androidInfo.id}\n${androidInfo.fingerprint}\n${androidInfo.brand}\n${androidInfo.device}\n${androidInfo.manufacturer}\n${androidInfo.model}\n${androidInfo.version.sdkInt}\n}';
    String url = 'mailto:$email?subject=$subject&body=$body';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
