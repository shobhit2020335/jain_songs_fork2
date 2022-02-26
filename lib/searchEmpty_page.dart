import 'package:flutter/material.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'custom_widgets/constantWidgets.dart';

class SearchEmpty extends StatelessWidget {
  final nameController = TextEditingController();
  final TextEditingController searchController;

  SearchEmpty(this.searchController, {Key? key}) : super(key: key);

  Widget formTextField(int? lines,
      {String? hint, required TextEditingController editingController}) {
    return TextField(
      controller: editingController,
      keyboardType: lines == 1 ? TextInputType.name : TextInputType.multiline,
      maxLines: lines,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "✔ Check for any spelling mistakes.\n✔ Change the filters if applied.\n",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(
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
                        ConstWidget.showSimpleToast(
                          context,
                          'ThankYou for submitting! We will update the song soon.',
                        );

                        SongSuggestions currentSongSuggestion = SongSuggestions(
                          nameController.text,
                          "User filled it after not finding the song.",
                        );
                        FireStoreHelper()
                            .addSuggestions(currentSongSuggestion, []);

                        nameController.clear();
                      } else {
                        ConstWidget.showSimpleToast(
                          context,
                          'Please Enter correct song name.',
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: ConstWidget.signatureColors(),
                      ),
                      height: 40,
                      child: const Center(
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
