import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
<<<<<<< HEAD
  currentSong.makestringSearchKeyword('PMC',
      englishName: 'Prabhu Parshwa Mitha Che',
      hindiName: 'प्रभु पार्श्व मीठा छे',
      originalSong: 'Prabhu Parshva Mitha Che',
      album: 'Parshwanath Parasnath',
      tirthankar: 'पारसनाथ पार्श्वनाथ',
      extra1: 'Jainam Variya',
=======
  currentSong.makestringSearchKeyword('AMPHC',
      englishName: 'Ankhadi mari prabhu harkhaay che',
      hindiName: 'આંખડી મારી પ્રભુ હરખાય છે',
      originalSong: 'आंखडी मारी प्रभु हरखाय छे',
      album: 'Aankhadi mari prabhu harkhaay che',
      tirthankar: 'Aankhdi mari prabhu harkhay che',
      extra1: '',
>>>>>>> 0f03ec6784d42e02a4af668d341819f84680f6c7
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
<<<<<<< HEAD
    'code': 'PMC',
=======
    'code': 'AMPHC',
>>>>>>> 0f03ec6784d42e02a4af668d341819f84680f6c7
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Posh Dashmi',
    'language': 'Gujarati',
    'likes': 0,
<<<<<<< HEAD
    'lyrics':
        'Suggested by:- Raxit Tated\n\nवामादेवीना कुखे जनम्या नाना राजकुमार ,\nअश्वसेनृयना हैए आनंद नो नहीं पार (2)\nकाशी देशे वाराणसी मा लोक गाए गीत-गान,\nआखा विश्वानि लाज तरनतारणे जहाज छे \nपार्श्व मीठा छे, प्रभु पार्श्व मीठा छे (2)\n\nजन्म समाए साते ग्रहो,\nउच्छा कक्षाए पहोच्या,\nसारी श्रुष्टिमा नवो रोमांच छवायो\nपाणीथी छल्काय नदीओ,\nरणमा पण वादळ वरस्या,\nआनंदित प्रजा पाथवे सुभेच्छाओ \nपार्श्व मीठा…(2)\n\nहस्ता खिलता बाल प्रभुना,\nखंजन पड़ता गाल\nचंदा जेवुं मुखड़ू ऐनु,\nतेजप्रतापी भाल\nपितानी इच्छाथी प्रभावती साथे,\nमांड्या संसारे पगला \nपण संसार नाब होगमा हता,\nअनासक्ति ना ढगला\nभौतिक सुखनो त्याग करीने\nआत्मसुख तरफ दाग मांडने\nपार्श्व प्रभुजी परम वैराग्यानी,\nभूमिकामा आव्या\nउपसर्गोने सहन करि भरे,\nकरमोने बाल्या\nकामठ जेवाने पण माफ़ करि एने तरया\nकरुणा जोइने सहुना  मुखेथी शब्दों सर्या\nपार्श्व मीठा…(2)\n\nपार्श्वजी तो छे कृपालु,\nएनी आज्ञा हु पालू,\nआज्ञा पालन थी मारु जीवन मधुरु\nपार्श्वजी अंधेरे दिवो,\nऐना वचने तरता जीवो,\nपार्श्व  प्रेम ने घूंट घूंट भरी पीवो\nपार्श्व मीठा…(2)\n',
    'englishLyrics':
        'Suggested by:- Raxit Tated\n\nVamadevi na kukhe janamya nana rajkumar,\nAshvasenraya na haiye anand no nahi par(2)\nKashi deshe Varanasi ma lok gae geet-gaan,\nAakhha vishwani laaj tarantaaran e jahaj Chhe\nParshva mitha chhe, prabhu parshva mitha chhe (2)\n\nJanma samaye saate graho,\nUchcha kakshae pahochya,\nSaari shrushtima navo romanch chhavayo\nPanni thi chhalkaay nadio,\nRann ma pan vaadal varasya,\nAnandit praja paathve subhechhao\nParshwa mitha…(2)\n\nHasta khilta baal prabhu na,\nKhanjan padata gaal\nChanda jevu mukhdu enu,\nTejpratapi bhaal\nPitani ichchha thi prabhavati sathe,\nMandya sansare pagala\nPan sansaar nab hog ma hata,\nAnasakti na dhagla\nBhautik such no tyag karine\nAatamsukh taraf dag maadine\nParshva prabhuji param vairagyani,\nBhumikama aavya\nUpsargo ne sahan kari bhare,\nKarmone balya\nKamath jeva ne pan maaf kari Ene tarya\nKaruna joine sahuna mukhe thi shabdo sarya\nParshwa mitha…(2)\n\nParshvaji to che kripalu,\nEni agya hu palu,\nAgya palan thi maaru jeevan madhuru\nParshvaji andhare divo,\nEna vachane tarata jivo,\nPrashva prem ne ghunt ghunt bhari pivo\nParshva mitha…(2)\n',
=======
    'lyrics':'આંખડી મારી પ્રભુ હરખાય છે\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ…\n\nપગ અધીરા દોડતા દેરાસરે, (૨)\nદ્વારે પહોચું ત્યાં અજંપો જાય છે\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n\nદેવનું વિમાન જાણે ઉતર્યું, (૨)\nએવું મંદિર આપનું સોહાય છે\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n\nચાંદની જેવી પ્રતિમા આપની, (૨)\nતેજ એનું ચોતરફ ફેલાય છે.\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n\nમુખડું જાણે પૂનમનો ચંદ્ર મા, (૨)\nચિત્તમાં ઠંડક અનેરી થાય છે.\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n\nબસ! તમારા રૂપને નીરખ્યા કરું, (૨)\nલાગણી એવી હૃદયમાં થાય છે\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n',
    'englishLyrics':'Ankhadi mari prabhu harkhaay che...\nJya tamara muk na darshan thay che ..(2)\nAnkhadi mari…\n\nPag  adhiru dodtu derasare..(2)\nDware paho chu tyaa ajam khoi-jai che..\nJya tamara muk na darshan thay che ..(2)\nAnkhadi mari prabhu harkhaay che..(2)\n\nDeva nu vimaan jyaare utaryu..(2)\nEvu mandir aapnu sohay che..\nJya tamara muk na darshan thay che ..(2)\nAnkhadi mari prabhu harkhaay che..(2)\n\nBas tamara rup ne nirkhay karu..(2)\nLagni evi hraday ma thay che..\nJya tamara muk na darshan thay che ..(2)\nAnkhadi mari prabhu harkhaay che..(2)\n',
>>>>>>> 0f03ec6784d42e02a4af668d341819f84680f6c7
    'originalSong': '',
    'popularity': 0,
    'production': 'Jinshasanam',
    'share': 0,
<<<<<<< HEAD
    'singer': 'Jainam Variya',
    'songNameEnglish': 'Parshwa Mitha Chhe',
    'songNameHindi': 'पार्श्व मीठा छे',
    'tirthankar': 'Parshwanath Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/pZ3YqvnViNk',
=======
    'singer': 'Rupal Doshi | Kishore Manraja',
    'songNameEnglish': 'Ankhadi Mari Prabhu Harkhaay Che',
    'songNameHindi': 'આંખડી મારી પ્રભુ હરખાય છે' ,
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/R2Z_oH7d_oU',
>>>>>>> 0f03ec6784d42e02a4af668d341819f84680f6c7
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void makestringSearchKeyword(
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
    String currentString;
    currentString = englishName.toLowerCase() + ' ' + hindiName.toLowerCase();
    currentString = currentString +
        ' ' +
        tirthankar.toLowerCase() +
        ' ' +
        originalSong.toLowerCase() +
        ' ' +
        album.toLowerCase() +
        ' ' +
        extra1.toLowerCase() +
        ' ' +
        extra2.toLowerCase() +
        ' ' +
        extra3.toLowerCase();
    _addSearchKeywords(code, currentString);
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
