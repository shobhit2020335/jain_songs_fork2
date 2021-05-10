import 'package:flutter/material.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'custom_widgets/constantWidgets.dart';

class SearchEmpty extends StatelessWidget {
  final nameController = TextEditingController();
  final TextEditingController searchController;

  SearchEmpty(this.searchController);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Couldn't find the Song you are looking for? Try below steps:\n\n",
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Check for any spelling mistakes.\nChange the filters if filters are applied.\nTry typing in HINDI.\nIf you still couldn't find the song or have a suggestion you can submit the song below.",
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                formFieldTitle('Song Name'),
                SizedBox(
                  height: 7,
                ),
                formTextField(
                  null,
                  hint: 'Song name you are trying to find.',
                  editingController: nameController,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                if (nameController != null &&
                    searchController != null &&
                    nameController.text.trim().length > 4) {
                  showToast(
                      'ThankYou for submitting! We will update the song soon.',
                      toastColor: Colors.green);

                  SongSuggestions currentSongSuggestion = SongSuggestions(
                    "Got by search submission",
                    "Got from search submission",
                    nameController.text,
                    "What user tried to search is given in otherDetails.",
                    searchController.text,
                  );
                  FireStoreHelper()
                      .addSuggestions(context, currentSongSuggestion);

                  nameController.clear();
                } else {
                  showToast('Please Enter correct song name.',
                      toastColor: Colors.red);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Color(0xFF54BEE6),
                ),
                width: 150,
                height: 40,
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
