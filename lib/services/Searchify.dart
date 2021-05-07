import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:sortedmap/sortedmap.dart';

class Searchify {
  var _map = SortedMap(Ordering.byValue());

  void wordWiseSearch(String query) {
    listToShow.clear();
    query = query.toLowerCase().trim();

    //This condition is added because if query was equal to '' then no songs were shown previously.
    if (query == '') {
      for (int i = 0; i < sortedSongList.length; i++) {
        listToShow.add(sortedSongList[i]);
      }
    } else {
      List<String> words = query.split(' ');

      for (int i = 0; i < sortedSongList.length; i++) {
        int songScore = 0;
        if (_map.containsKey(i)) {
          songScore = _map[i];
        }

        for (int j = 0; j < words.length; j++) {
          String word = words[j].trim();
          if (word.length > 0 &&
              sortedSongList[i].searchKeywords.contains(word)) {
            songScore++;
          }
        }

        if (songScore > 0) {
          _map[i] = songScore;
        }
      }

      _map.forEach((key, value) {
        // print('Info= $key : $value');
        int keyInt = int.parse(key.toString());
        listToShow.add(sortedSongList[keyInt]);
      });
      listToShow = List.from(listToShow.reversed);
    }
  }

  void basicSearch(String query) {
    listToShow.clear();
    query = query.toLowerCase();
    String tempquery = removeWhiteSpaces(query);

    //This condition is added because if query was equal to '' then no songs were shown.
    if (query == '' || tempquery == '') {
      for (int i = 0; i < sortedSongList.length; i++) {
        listToShow.add(sortedSongList[i]);
      }
    } else {
      int noOfWords = query.split(' ').length;
      for (int i = 0; i < sortedSongList.length; i++) {
        sortedSongList[i].searchKeywords =
            removeWhiteSpaces(sortedSongList[i].searchKeywords);
        if (sortedSongList[i].searchKeywords.contains(tempquery)) {
          _map[i] = noOfWords;
        }
      }
      wordWiseSearch(query);
    }
  }
}
