import 'package:flutter/material.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "✔ Check for any spelling mistakes.\n✔ Change the filters if applied.\n",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: formTextField(
                    null,
                    hint: 'Song you are searching',
                    editingController: nameController,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      if (nameController.text.trim().length > 4) {
                        showSimpleToast(
                          context,
                          'ThankYou for submitting! We will update the song soon.',
                        );

                        SongSuggestions currentSongSuggestion = SongSuggestions(
                          "Got by search submission",
                          "Got from search submission",
                          nameController.text,
                          "What user tried to search is given in otherDetails.",
                          searchController.text,
                        );
                        FireStoreHelper().addSuggestions(currentSongSuggestion);

                        nameController.clear();
                      } else {
                        showSimpleToast(
                          context,
                          'Please Enter correct song name.',
                        );
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
                        color: Colors.indigo,
                      ),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
