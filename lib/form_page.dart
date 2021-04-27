import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';

import 'services/network_helper.dart';

class FormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var songController = TextEditingController();
  var lyricsController = TextEditingController();
  var otherController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    songController.dispose();
    lyricsController.dispose();
    otherController.dispose();
    super.dispose();
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
                      child: showLogo(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'स्तवन',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 40,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Thank You for suggesting a new song! Credit of the song will be given to you once the song is uploaded.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          formFieldTitle('Name (Optional)'),
                          SizedBox(
                            height: 7,
                          ),
                          formTextField(
                            1,
                            hint: 'Name',
                            editingController: nameController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          formFieldTitle('Email (Optional)'),
                          SizedBox(
                            height: 7,
                          ),
                          formTextField(
                            1,
                            hint: 'Email',
                            editingController: emailController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                formFieldTitle('Song Name'),
                SizedBox(
                  height: 7,
                ),
                formTextField(null,
                    hint: 'Song name', editingController: songController),
                SizedBox(
                  height: 20,
                ),
                formFieldTitle('Lyrics / Link'),
                SizedBox(
                  height: 7,
                ),
                formTextField(
                  null,
                  hint: 'Lyrics or link where lyrics can be found',
                  editingController: lyricsController,
                ),
                SizedBox(
                  height: 20,
                ),
                formFieldTitle('Other Details'),
                SizedBox(
                  height: 7,
                ),
                formTextField(
                  null,
                  hint: 'Other details of the song.',
                  editingController: otherController,
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  onPressed: () async {
                    SongSuggestions currentSongSuggestion = SongSuggestions(
                      nameController.text,
                      emailController.text,
                      songController.text,
                      lyricsController.text,
                      otherController.text,
                    );

                    bool isInternetConnected =
                        await NetworkHelper().checkNetworkConnection();

                    if ((currentSongSuggestion.songSuggestionMap['songName'] ==
                                '' ||
                            currentSongSuggestion
                                    .songSuggestionMap['songName'] ==
                                null ||
                            currentSongSuggestion
                                    .songSuggestionMap['songName'].length <
                                2) &&
                        (currentSongSuggestion
                                    .songSuggestionMap['lyrics'] ==
                                '' ||
                            currentSongSuggestion.songSuggestionMap['lyrics'] ==
                                null ||
                            currentSongSuggestion
                                    .songSuggestionMap['lyrics'].length <
                                2)) {
                      showToast('Song Name and Lyrics both cannot be empty',
                          toastColor: Colors.red);
                    } else if (isInternetConnected == false) {
                      showToast('No Internet Connection!',
                          toastColor: Colors.red);
                    } else {
                      await FireStoreHelper()
                          .addSuggestions(context, currentSongSuggestion);
                      nameController.clear();
                      emailController.clear();
                      songController.clear();
                      lyricsController.clear();
                      otherController.clear();
                      showToast(
                        'ThankYou for suggesting! Song will be updated soon.',
                        toastColor: Colors.green,
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFF54BEE6),
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
