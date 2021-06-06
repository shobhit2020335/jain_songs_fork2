import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('PKMJI',
      englishName: '',
      hindiName: '',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'PKMJI',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Diksha',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'हो हो ... हो हो....\nपंचम काल में जो इंसान, साधु बने वो महान् है\nदेवो से राजा से बड़ा जैन मुनि का मान् है २\nहो हो.... हो हो...\n\nसुख और भोग से राग के रोग से,\nमिलन वियोग से रहे पड़े २\nसमता धारे - ममता त्यागे, \nहर परेसाह से कहे सहे २\nमहाव्रत धारी ये अविकारी, \nधन जिनका आगम ज्ञान है\nपंचम काल में जो इंसान साधु बने वो महान है\n\nमैत्री भावना, मंगल कामना\nक्षमापना हर प्राणी से\nतन मन वचन से जैन साधु \nरखे इन्द्रियाँ निगरानी में\nना प्रमाद करें, ना विवाद करें,\nसमकित का देते कान है\nपंचम काल में जो इंसान साधु बने वो महान है\n\nसिद्धशिला को लक्ष्य में रखके \nजयणा का पालन करे २\nतप, जप योग से कर्म खपाते, \nसदा ये पैदल ही चले\nकुदरत के नियम नही तोड़े कभी, \nपर हित जीवन का विधान है\nपंचम काल में जो इंसान, साधु बने वो महान् है\n\nभूख प्यास क्या? सर्दी गर्मी\nया पीड़ा कोई तन मन की\nना आकुल ना व्याकुल होते,\nआनन्द में करते भक्ति\nनाकोड़ा दरबार प्रदीप नमे,\nयह जैन मुनि वरदान है\nपंचम काल में जो इंसान साधु बने वो महान है\n\nदेवो से राजा से बड़ा जैन मुनि का मान् है २\nहो हो.... हो हो... हो हो.... हो हो....\n',
    'englishLyrics':
        'Ohho Oo\nPancham Kal Main Jo Insan\nSadhu Bane Wo Mahan Hain (2)\nDevo Se Raja Se Bada Jain Muni Ka Maan Hain (2)\nOhho Oo ….\n\nSukh Aur Bhog Se\nRaag Keh Rog Se Milan Viyog Se Rahe Pare (2)\nSamta Dhare Mamta Tyage\nHar Paresha Has Keh Sahe\nMahavratdhari Yeh Avikari\nDhan Jinka Aagam Dhyaan Hain\nPancham Kal Main Jo Insan …\n\nMaitri Bhavana Mangal Kaamna\nKshamapana Har Prani Se\nTan Man Vachan Se Jain Sadhu Rakhe Indriya Nigrani Main\nNa Pramad Kare Na Vivaad Kare\nSamkit Ka Dete Daan Hain\nPancham Kal Main Jo Insan …\n\nSiddhashila Ko Laksha Main Rakh Keh\nJin Agnya Palan Kare   (2)\nTap Jap Yog Se Karam Khapate\nSada Yeh Paidal Hi Chale\nKudrat Keh Niyam Nahi Tode Kabhi\nParhit Jivan Ka Vidhan Hain\nPancham Kal Main Jo Insan …\n\nBhukh Pyaas Kya Sardi Garmi\nYa Peeda Koi Tan Man Ki\nNaa Aakul Na Vyakul Hoteh\nAnand Main Karte Bhakti\nNakoda Darbaar Pradeep Name Yeh Jain Muni Vardan Hain\nPancham Kal Main Jo Insan …\n',
    'originalSong': 'Aaj Purani Raahon Se | Mohammed Rafi',
    'popularity': 0,
    'production': 'Ankita Shah',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Pancham Kaal Me Jo Insaan',
    'songNameHindi': 'पंचम काल में जो इंसान',
    'tirthankar': 'Nakoda Bheru',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/bPsEQ_7BSaY',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  String searchKeywords = '';

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void mainSearchKeywords() {
    searchKeywords = searchKeywords +
        currentSongMap['language'] +
        ' ' +
        currentSongMap['genre'] +
        ' ' +
        removeSpecificString(currentSongMap['tirthankar'], ' Swami') +
        ' ' +
        currentSongMap['category'] +
        ' ' +
        currentSongMap['songNameEnglish'] +
        ' ';
    searchKeywords = removeSpecialChars(searchKeywords).toLowerCase();
  }

  void extraSearchKeywords(
    String code, {
    String englishName: '',
    String hindiName: '',
    String tirthankar: '',
    String originalSong: '',
    String album: '',
    String extra1: '',
    String extra2: '',
    String extra3: '',
  }) {
    searchKeywords = searchKeywords.toLowerCase() + englishName + hindiName;
    searchKeywords = searchKeywords +
        currentSongMap['songNameHindi'] +
        ' ' +
        currentSongMap['originalSong'] +
        ' ' +
        currentSongMap['album'] +
        ' ' +
        tirthankar +
        ' ' +
        originalSong +
        ' ' +
        album +
        ' ' +
        extra1 +
        ' ' +
        extra2 +
        ' ' +
        extra3 +
        ' ';
    _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
