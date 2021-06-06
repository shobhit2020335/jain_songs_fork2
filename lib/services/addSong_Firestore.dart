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
  currentSong.extraSearchKeywords('NBC',
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
    'code': 'NBC',
    'album': '',
    'aaa': 'valid',
    'category': 'Chalisa',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        '॥ दोहा ॥\nपाश्वर्नाथ भगवान की, मूरत चित बसाए ॥\nभैरव चालीसा लखू, गाता मन हरसाए ॥\n\n।। चौपाई ।।\nनाकोडा भैरव सुखकारी, गुण गाये ये दुनिया सारी ॥\nभैरव की महिमा अति भारी, भैरव नाम जपे नर – नारी ॥\nजिनवर के हैं आज्ञाकारी, श्रद्धा रखते समकित धारी ॥\nप्रातः उठ जो भैरव ध्याता, ऋद्धि सिद्धि सब संपत्ति पाता ॥\nभैरव नाम जपे जो कोई, उस घर में निज मंगल होई ॥\nनाकोडा लाखों नर आवे, श्रद्धा से परसाद चढावे ॥\nभैरव – भैरव आन पुकारे, भक्तों के सब कष्ट निवारे ॥\nभैरव दर्शन शक्ति – शाली, दर से कोई न जावे खाली ॥\nजो नर नित उठ तुमको ध्यावे, भूत पास आने नहीं पावे ॥\nडाकण छूमंतर हो जावे, दुष्ट देव आडे नहीं आवे ॥\nमारवाड की दिव्य मणि हैं, हम सब के तो आप धणी हैं ॥\nकल्पतरु है परतिख भैरव, इच्छित देता सबको भैरव ॥\nआधि व्याधि सब दोष मिटावे, सुमिरत भैरव शान्ति पावे ॥\nबाहर परदेशे जावे नर, नाम मंत्र भैरव का लेकर ॥\nचोघडिया दूषण मिट जावे, काल राहु सब नाठा जावे ॥\nपरदेशा में नाम कमावे, धन बोरा में भरकर लावे ॥\nतन में साता मन में साता, जो भैरव को नित्य मनाता ॥\nमोटा डूंगर रा रहवासी, अर्ज सुणन्ता दौड्या आसी ॥\nजो नर भक्ति से गुण गासी, पावें नव रत्नों की राशि ॥\nश्रद्धा से जो शीष झुकावे, भैरव अमृत रस बरसावे ॥\nमिल जुल सब नर फेरे माला, दौड्या आवे बादल – काला ॥\nवर्षा री झडिया बरसावे, धरती माँ री प्यास बुझावे ॥\nअन्न – संपदा भर भर पावे, चारों ओर सुकाल बनावे ॥\nभैरव है सच्चा रखवाला, दुश्मन मित्र बनाने वाला ॥\nदेश – देश में भैरव गाजे, खूटँ – खूटँ में डंका बाजे ॥\nहो नहीं अपना जिनके कोई, भैरव सहायक उनके होई ॥\nनाभि केन्द्र से तुम्हें बुलावे, भैरव झट – पट दौडे आवे ॥\nभूख्या नर की भूख मिटावे, प्यासे नर को नीर पिलावे ॥\nइधर – उधर अब नहीं भटकना, भैरव के नित पाँव पकडना ॥\nइच्छित संपदा आप मिलेगी, सुख की कलियाँ नित्य खिलेंगी ॥\nभैरव गण खरतर के देवा, सेवा से पाते नर मेवा ॥\nकीर्तिरत्न की आज्ञा पाते, हुक्म – हाजिरी सदा बजाते ॥\nऊँ ह्रीं भैरव बं बं भैरव, कष्ट निवारक भोला भैरव ॥\nनैन मूँद धुन रात लगावे, सपने में वो दर्शन पावे ॥\nप्रश्नों के उत्तर झट मिलते, रस्ते के संकट सब मिटते ॥\nनाकोडा भैरव नित ध्यावो, संकट मेटो मंगल पावो ॥\nभैरव जपन्ता मालम – माला, बुझ जाती दुःखों की ज्वाला ॥\nनित उठे जो चालीसा गावे, धन सुत से घर स्वर्ग बनावे ॥\n\n॥ दोहा ॥\nभैरु चालीसा पढे, मन में श्रद्धा धार ।\nकष्ट कटे महिमा बढे, संपदा होत अपार ॥\nजिन कान्ति गुरुराज के,शिष्य मणिप्रभ राय ।\nभैरव के सानिध्य में,ये चालीसा गाय ॥\n॥ श्री भैरवाय शरणम् ॥\n',
    'englishLyrics':
        '॥ Doha ॥\nPaashvarnaath Bhagavaan Kee, Moorat Chit Basae\nBhairav Chaaleesa Lakhoo, Gaata Man Harasae\n\n॥ Chaupai ॥\nNaakoda Bhairav Sukhakaaree, Gun Gaaye Ye Duniya Saaree\nBhairav Kee Mahima Ati Bhaaree, Bhairav Naam Jape Nar – Naaree\nJinavar Ke Hain Aagyaakaaree, Shraddha Rakhate Samakit Dhaaree\nPraatah Uth Jo Bhairav Dhyaata, Rddhi Siddhi Sab Sampatti Paata\nBhairav Naam Jape Jo Koee, Us Ghar Mein Nij Mangal Hoee\nNaakoda Laakhon Nar Aave, Shraddha Se Parasaad Chadhaave\nBhairav – Bhairav Aan Pukaare, Bhakton Ke Sab Kasht Nivaare\nBhairav Darshan Shakti – Shaalee, Dar Se Koee Na Jaave Khaalee\nJo Nar Nit Uth Tumako Dhyaave, Bhoot Paas Aane Nahin Paave .\nDaakan Chhoomantar Ho Jaave, Dusht Dev Aade Nahin Aave .\nMaaravaad Kee Divy Mani Hain, Ham Sab Ke To Aap Dhanee Hain .\nKalpataru Hai Paratikh Bhairav, Ichchhit Deta Sabako Bhairav .\nAadhi Vyaadhi Sab Dosh Mitaave, Sumirat Bhairav Shaanti Paave .\nBaahar Paradeshe Jaave Nar, Naam Mantr Bhairav Ka Lekar .\nChoghadiya Dooshan Mit Jaave, Kaal Raahu Sab Naatha Jaave .\nParadesha Mein Naam Kamaave, Dhan Bora Mein Bharakar Laave .\nTan Mein Saata Man Mein Saata, Jo Bhairav Ko Nity Manaata .\nMota Doongar Ra Rahavaasee, Arj Sunanta Daudya Aasee .\nJo Nar Bhakti Se Gun Gaasee, Paaven Nav Ratnon Kee Raashi .\nShraddha Se Jo Sheesh Jhukaave, Bhairav Amrt Ras Barasaave .\nMil Jul Sab Nar Phere Maala, Daudya Aave Baadal – Kaala .\nVarsha Ree Jhadiya Barasaave, Dharatee Maan Ree Pyaas Bujhaave .\nAnn – Sampada Bhar Bhar Paave, Chaaron Or Sukaal Banaave .\nBhairav Hai Sachcha Rakhavaala, Dushman Mitr Banaane Vaala .\nDesh – Desh Mein Bhairav Gaaje, Khootan – Khootan Mein Danka Baaje .\nHo Nahin Apana Jinake Koee, Bhairav Sahaayak Unake Hoee .\nNaabhi Kendr Se Tumhen Bulaave, Bhairav Jhat – Pat Daude Aave .\nBhookhya Nar Kee Bhookh Mitaave, Pyaase Nar Ko Neer Pilaave .\nIdhar – Udhar Ab Nahin Bhatakana, Bhairav Ke Nit Paanv Pakadana .\nIchchhit Sampada Aap Milegee, Sukh Kee Kaliyaan Nity Khilengee .\nBhairav Gan Kharatar Ke Deva, Seva Se Paate Nar Meva .\nKeertiratn Kee Aagya Paate, Hukm – Haajiree Sada Bajaate .\nOon Hreen Bhairav Ban Ban Bhairav, Kasht Nivaarak Bhola Bhairav .\nNain Moond Dhun Raat Lagaave, Sapane Mein Vo Darshan Paave .\nPrashnon Ke Uttar Jhat Milate, Raste Ke Sankat Sab Mitate .\nNaakoda Bhairav Nit Dhyaavo, Sankat Meto Mangal Paavo .\nBhairav Japanta Maalam – Maala, Bujh Jaatee Duhkhon Kee Jvaala .\nNit Uthe Jo Chaalisa Gaave, Dhan Sut Se Ghar Svarg Banaave .\n\n॥ Doha ॥\nBhairu Chaalisa Padhe, Man Mein Shraddha Dhaar .\nKasht Kate Mahima Badhe, Sampada Hot Apaar .\nJin Kaanti Gururaaj Ke,Shishy Maniprabh Raay .\nBhairav Ke Saanidhy Mein,Ye Chaaleesa Gaay .\n॥ Shree Bhairavaay Sharanam ॥\n',
    'originalSong': '',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Shri Nakoda Bhairav Chalisa',
    'songNameHindi': 'श्री नाकोड़ा भैरव चालीसा',
    'tirthankar': 'Nakoda Bheru',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/OYGGL6Ofk5U',
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
