import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'services/network_helper.dart';

class FormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  var songController = TextEditingController();
  var otherController = TextEditingController();
  File? image;

  @override
  void dispose() {
    songController.dispose();
    otherController.dispose();
    super.dispose();
  }

  //Important to note code inside.
  Future<ImageSource?> showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_rounded),
              title: Text(
                'Camera',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                print('onTap');
                return Navigator.of(context).pop(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image_rounded),
              title: Text(
                'Gallery',
                style: TextStyle(
                  color: Colors.black,
                ),
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

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<void> pickSingleImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePermanent = await saveImagePermanently(image.path);
      this.image = imagePermanent;
    } on Exception catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //Try this and edit if not working.
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      child: ConstWidget.showLogo(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'स्तवन',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Suggest us some songs.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  'Thank You for suggesting a new song! Credit of the song will be given to you once the song is uploaded.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: () async {
                    final source = await showImageSourceDialog(context);
                    if (source == null) {
                      print('source null');
                      return;
                    }

                    pickSingleImage(source).then((value) {
                      setState(() {});
                    });
                  },
                  child: image != null
                      ? Image.file(
                          image!,
                          width: 100,
                          height: 100,
                        )
                      : Icon(
                          Icons.cloud_upload_rounded,
                          color: Colors.indigo,
                          size: 50,
                        ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final source = await showImageSourceDialog(context);
                    if (source == null) {
                      print('source null');
                      return;
                    }
                    pickSingleImage(source).then((value) {
                      setState(() {});
                    });
                  },
                  child: Text(
                    'Upload Lyrics Image',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ConstWidget.formFieldTitle('Song Title'),
                SizedBox(height: 7),
                ConstWidget.formTextField(null,
                    hint: 'Song title', editingController: songController),
                SizedBox(height: 20),
                ConstWidget.formFieldTitle('Other Details'),
                SizedBox(height: 7),
                ConstWidget.formTextField(
                  null,
                  hint:
                      'Link of Lyrics or Youtube video. Other song information',
                  editingController: otherController,
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () async {
                    SongSuggestions currentSongSuggestion = SongSuggestions(
                      songController.text,
                      otherController.text,
                    );

                    bool isInternetConnected =
                        await NetworkHelper().checkNetworkConnection();

                    if ((currentSongSuggestion.songSuggestionMap['songName'] ==
                            null ||
                        currentSongSuggestion.songSuggestionMap['songName'] ==
                            '' ||
                        currentSongSuggestion
                                .songSuggestionMap['songName'].length <
                            2)) {
                      ConstWidget.showSimpleToast(
                        context,
                        'Please fill up the Song Title',
                      );
                    } else if (isInternetConnected == false) {
                      ConstWidget.showSimpleToast(
                        context,
                        'No Internet Connection!',
                      );
                    } else {
                      await FireStoreHelper()
                          .addSuggestions(currentSongSuggestion);

                      songController.clear();
                      otherController.clear();
                      ConstWidget.showSimpleToast(
                        context,
                        'ThankYou for suggesting! Song will be updated soon.',
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.indigo,
                    ),
                    width: 250,
                    height: 57,
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
