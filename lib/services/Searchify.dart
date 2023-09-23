import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:sortedmap/sortedmap.dart';

class Searchify {
  final _map = SortedMap(const Ordering.byValue());

  void wordWiseSearch(String query) {
    ListFunctions.listToShow.clear();
    query = query.toLowerCase().trim();

    //This condition is added because if query was equal to '' then no songs were shown previously.
    if (query == '') {
      for (int i = 0; i < ListFunctions.sortedSongList.length; i++) {
        ListFunctions.listToShow.add(ListFunctions.sortedSongList[i]);
      }
    } else {
      List<String> words = query.split(' ');

      for (int i = 0; i < ListFunctions.sortedSongList.length; i++) {
        int? songScore = 0;
        String searchKeywords =
            removeWhiteSpaces(ListFunctions.sortedSongList[i]!.searchKeywords!);

        if (_map.containsKey(i)) {
          songScore = _map[i];
        }

        for (int j = 0; j < words.length; j++) {
          String word = words[j].trim();
          if (word.isNotEmpty && searchKeywords.contains(word)) {
            songScore = songScore! + 1;
          }
        }

        if (songScore! > 0) {
          _map[i] = songScore;
        }
      }

      _map.forEach((key, value) {
        int keyInt = int.parse(key.toString());
        ListFunctions.listToShow
            .insert(0, ListFunctions.sortedSongList[keyInt]);
      });
    }
  }

  bool basicSearch(String query) {
    bool isBasicSearchEmpty = true;
    ListFunctions.listToShow.clear();
    query = query.toLowerCase();
    String tempquery = removeWhiteSpaces(query);

    //This condition is added because if query was equal to '' then no songs were shown.
    if (query == '' || tempquery == '') {
      isBasicSearchEmpty = false;
      for (int i = 0; i < ListFunctions.sortedSongList.length; i++) {
        ListFunctions.listToShow.add(ListFunctions.sortedSongList[i]);
      }
    } else {
      int noOfWords = query.split(' ').length;
      for (int i = 0; i < ListFunctions.sortedSongList.length; i++) {
        // sortedSongList[i].searchKeywords =
        //     removeWhiteSpaces(sortedSongList[i].searchKeywords);
        if (ListFunctions.sortedSongList[i]!.searchKeywords!.contains(query)) {
          isBasicSearchEmpty = false;
          _map[i] = noOfWords * 2;
        }
      }
      wordWiseSearch(query);
    }

    return isBasicSearchEmpty;
  }
}
