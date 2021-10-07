import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'services/network_helper.dart';

class FormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  var songController = TextEditingController();
  var otherController = TextEditingController();
  List<File> images = [];

  Widget formFieldTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).primaryColorLight,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget formTextField(int? lines,
      {String? hint, required TextEditingController editingController}) {
    return TextField(
      controller: editingController,
      keyboardType: lines == 1 ? TextInputType.name : TextInputType.multiline,
      maxLines: lines,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    songController.dispose();
    otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      backgroundColor: Theme.of(context).primaryColorDark,
                      child: ConstWidget.showLogo(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'स्तवन',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
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
                  style: Theme.of(context).primaryTextTheme.headline4,
                ),
                SizedBox(height: 10),
                Text(
                  'Thank You for suggesting a new song! Credit of the song will be given to you once the song is uploaded.',
                  style: Theme.of(context).primaryTextTheme.headline5,
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: () async {
                    final source =
                        await Services.showImageSourceDialog(context);
                    if (source == null) {
                      print('source null');
                      return;
                    } else if (source == ImageSource.camera) {
                      Services.pickSingleImage(source).then((value) {
                        setState(() {
                          if (value != null) {
                            images.add(value);
                          }
                        });
                      });
                    } else {
                      Services.pickMultipleImages().then((value) {
                        setState(() {
                          images = value;
                        });
                      });
                    }
                  },
                  child: images.isNotEmpty
                      ? Image.file(
                          images[0],
                          width: 100,
                          height: 100,
                        )
                      : Icon(
                          Icons.cloud_upload_rounded,
                          color: ConstWidget.signatureColors(),
                          size: 50,
                        ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final source =
                        await Services.showImageSourceDialog(context);
                    if (source == null) {
                      print('source null');
                      return;
                    } else if (source == ImageSource.camera) {
                      Services.pickSingleImage(source).then((value) {
                        setState(() {
                          if (value != null) {
                            images.clear();
                            images.add(value);
                          }
                        });
                      });
                    } else {
                      Services.pickMultipleImages().then((value) {
                        setState(() {
                          images.clear();
                          images = value;
                        });
                      });
                    }
                  },
                  child: Text(
                    images.isEmpty
                        ? 'Upload Lyrics Image'
                        : '${images.length} images selected',
                    style: Theme.of(context).primaryTextTheme.subtitle2,
                  ),
                ),
                SizedBox(height: 20),
                formFieldTitle('Song Title'),
                SizedBox(height: 7),
                formTextField(null,
                    hint: 'Song title', editingController: songController),
                SizedBox(height: 20),
                formFieldTitle('Other Details'),
                SizedBox(height: 7),
                formTextField(
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
                      if (images.length > 0) {
                        ConstWidget.showSimpleToast(
                            context, 'Uploading Images....');
                      }
                      await FireStoreHelper()
                          .addSuggestions(currentSongSuggestion, images);

                      songController.clear();
                      otherController.clear();
                      images = [];
                      setState(() {});
                      ConstWidget.showSimpleToast(
                        context,
                        'ThankYou for suggesting! Song will be updated soon.',
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ConstWidget.signatureColors(),
                    ),
                    width: 250,
                    height: 57,
                    child: Center(
                      child: Text(
                        'Submit',
                        style: Theme.of(context).primaryTextTheme.headline6,
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
