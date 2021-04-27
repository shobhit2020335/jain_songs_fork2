import 'package:flutter/material.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'custom_widgets/constantWidgets.dart';

class SearchEmpty extends StatefulWidget {
  final TextEditingController searchController;
  SearchEmpty(this.searchController);

  @override
  _SearchEmptyState createState() => _SearchEmptyState();
}

class _SearchEmptyState extends State<SearchEmpty> {
  var nameController = TextEditingController();
  TextEditingController searchController;
  //If shwForm is true then the user has clicked to suggest what was he trying to search.
  bool showForm = false;
  String buttonString = "Search";

  @override
  void initState() {
    super.initState();
    searchController = widget.searchController;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

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
              "No results found for your search terms.\n",
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "You can try typing HINDI.\nIf you could find the song you can click below button.",
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Visibility(
              visible: showForm,
              child: Column(
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
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                setState(
                  () {
                    if (buttonString == 'Submit') {
                      showToast(
                          'ThankYou for submitting! We will update the song soon.',
                          toastColor: Colors.green);
                    }
                    SongSuggestions currentSongSuggestion = SongSuggestions(
                      "Got from search",
                      "Got from search",
                      nameController.text,
                      "What user tried to search is given in otherDetails.",
                      searchController.text,
                    );
                    FireStoreHelper()
                        .addSuggestions(context, currentSongSuggestion);
                    showForm = true;
                    buttonString = "Submit";
                    nameController.clear();
                  },
                );
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
                    buttonString,
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
