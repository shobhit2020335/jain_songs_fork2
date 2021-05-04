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
  currentSong.makestringSearchKeyword('SS',
      englishName: 'Saiyam Sargam mashup Diksha Mashup saiyam mashup',
      hindiName: 'सैयाम सरगम मैशप दीक्षा मैशप',
      originalSong: 'सैयाम मैशप',
      album: 'saiyyam sargam saiyyam mashup saiyyiam mashup saiyyiam sargam',
      tirthankar: 'diksa mashup',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'SS',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Diksha',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'हे वितराग तुज पाए,  हु करु विनंती एटली\nसाधु नो वेश क्यारे मळे, मांगु प्रभु बस एटलु\nकुमकुम तणा ते छाटणा, केशर तणा ते साथीया\nरजोहरण क्यारे मळे, मांगु प्रभु बस एटलु\n\nविरती धर नो वेश प्यारो प्यारो लागे रे\nसंसारी नो संग खारो, खारो लागे रे\nरजोहरण मेळववा ने हवे मन मारु लोभायु\nगुरुकुल मा वसवाने काजे दिल मारु ललचायु\nमहावीर तारो मार्ग कामणगारो लागे रे... संसारी...., \nएक मनोरथ एवो छे, वेश श्रमण नो लेवो छे\nअंतरनी ए प्यास छे, संयम नी अभीलाष छे\nमारा जीवन नो एकज सार, संयम लई करवो उद्धार\nवीर प्रभु नो अंश मळे, गुरु गौतम नो वंश मळे\n\nपतित पावन प्रभुजी उगारो, \nरात्रत्रयी नो याचक तारो\nक्यारे मळशे मने निग्रंथ पंथ, \nक्यारे थशे मारा भवनों रेअंत\nक्यारे बनीश... \n\nलागी रे लागी रे लागी रे, संयम नी लगन लागी\nजागी रे जागी रे जागी रे, संयम नी अगन जागी\nत्यागी रे लागी रे लागी रे, मारे बनवु छे त्यागी\nलागी रे लागी रे.... \n\nघेल्यु लाग्यु मुजने, हु तारा पंथे चालु\nतारा पंथे चाली, हु कर्मो सगळा बाळु\nदेवो पण, झंखे रे, वंदे रे जेवा जीवन ने\nलगनी लागी रे, अग्री जागी रे, संयम जीवन नी प्रभु\n\nसाधना ना पंथे मारा, जेवो पामर क्यारे जाए\nआज मारा मनमा जागे छे आ रुडो अंतर्नाद\nवहेली वहेली मळजो रे मने मुक्ति नी मंजील\n\nमारा जेवा लोको फ़क्त सुखना साधना मांगे छे ने दुखाई छेता भागे छे\nविरला कोइ निकळे छे जे सुख सामग्री त्याग छे ने कष्ट कसोटी मांगे छे\nआ जगनी मोह मायाथी मारी मुक्ति क्यारे थाए\nआज मारे मनमा..... \n\nसिद्धि माटे गावी पडे, साधना नी सरगम\nआखरे तो लीधु संयम, स्वामी ऐवी स्वयं ऐ सय्यम क्यारे मळशे. \n\nजो सुख पावु वीर वचन में, वो सुख नाही अमीरी में\nमन लागो मेरो यार विरति में\nधन्य समझ लु खुदके जीवन को जीनशासन की फकीरी में\nमन लागो मेरो यार विरति में\n\nमळजो रे मने वेश श्रमण नौ मळजो\nआठ प्रहर नी साधना काजे, वहेली परोडे जागु\nश्वासो लेवा माटे पण हु, गुरु नी आणा मांगु\nप्रभुजी मारो साद आजे सांभळजो मळजो रे मने.... \n\nमारे बनवु अणगार, मारे बनवु अणगार, \nमारे तरवो संसार, मारे बनवु अणगार, \nप्रभु पंथ ने पामी करु, हु आतमने उजमाळ\nगुरु चरण ही ने मारे, थावो छे भवपार\nमानव जीवन नो सार ... .मारे बनवु अणगार\nसंयम संयम मारे लेवो संयम\n',
    'englishLyrics':
        'Vitaraag tuj paaye padi..Hu karu vinanti etli..\nSadhu no vesh khyare male..Maangu prabhu bas etlu..\nKumkum tana te chatna..Kesar tana te saathiya..\nRajoharan khyare male..Maangu prabhu bas etlu\nAree..Maangu prabhu bas etlu...\n\nVirtih dhar no vesh pyaaro pyaaro laage re\nSansari no sang khaaro khaaro laage re\nVirtih dhar no vesh pyaaro pyaaro laage re\nRajoharan medavava ne have man maaru lubhayu\nGurukal ma vasavaane kaaje dil maaru lalchaayu\nMahaveer tharo maarg kamangaaro re\nSansari no sang khaaro khaaro laage re\nVirtih dhar no vesh pyaaro pyaaro laage re\n\nEk manorath evo che, vesh shraman no levo che[2] \nAntar ni ae pyaas che, saiyam ni abhilash che[2] \nMhara jeevan no ekaj saar, saiyam lai karvo udhaar[2] \nVeer prabhu no ansh made, guru gautham no vansh made[2] \n\nPateet paawan prabhuji ugaaro, \nRatnatrai no hu yaachak taaro[2] \nKhyare malshe mujhne nirgranth panth? \nKhyare tashe mhara bhavno re anth.. \nKhyare banish hu vairagya vant.. \nKhyare tashe mhara bhav no re ant? \n\nLaagi re laagi re laagi re, saiyam ni lagan laagi[2] \nJaagi re jaagi re jaagi re, saiyam ni agan jaagi\nTyaagi re tyaagi re tyaagi re, mhare vanvu che tyaagi.. \nLaagi re laagi re laagi re, saiyam ni lagan laagi[2] \n\nGhelu laagyu mujhne, hu thara panthe chaalu.. \nThara panthe chali hu karmo sagda bhaadu.. \nDevo pan..Jankhe re.. Vande re.. Jeva jeevan ne\nLagni laagi re, agni jaagi re\nSaiyam jeevan ne prabhu... \n\nSaadhna na panthe mhara jevo paamar khyare ja.. \nAaj maara manma jaage che aarudo antarnaad.. \nVehli vehli madajo re mhane mukti ni manzil\nVehli vehli madajo mujhne mukti ni manzil\n\nHoo..Mhara jeva loko fakt sukh na saadhan maange che ne\nDukhti che ta bhaage che\nVirla koi nikde che, je sukh saamagri tyaage che nekasth kasauti maange che.. \nAa jagni moh-maaya thi.. \nAa jagni moh-maaya thi..Maari mukhti khyare thaay\nAaj maara manma jaage che aarudo antarnaad.. \nVehli vehli madajo re mhane mukti ni manzil\nVehli vehli madajo mujhne mukti ni manzil\n\nSiddhi maate gaavi pade, saadhna ni sargam\nAakhare toh lidhu saiyam, swami ye bhi swayam\nKe saiyam khyare madshe? O khyare khyare madshe? \nO mujhne khayre madshe? O saiyam khyare madshe? \n\nJo sukh paau veer vachan mei[2] \nVo sukh naahi ameeri mei[2] \nMan laago mero yaar virtih mei[3] \nDhanya samaj lu khud ke jeevan ko[2] \nJin shasan ki fakeeri mei..Ho ho jin shasan ki fakeeri mei\nMan laago mero yaar virtih mei[3] \n\nMadjo re mhane vesh shraman no madjo[4] \nAat prahar ni saadhna kaaje, vehli parodhe hu jaagu\nShwaso leva maate pan hu guru ni aana maangu\nPrabhuji mharo saad aaje sambhaljo[2] \nMadjo re mhane vesh shraman no madjo[2] \nMhare banvu angaar[2] \nMhare taravo sansaar\nMhare banavu angaar\n\nMhare banvu angaar[2] \nMhare taravo sansaar\nMhare banavu angaar\n\nPrabhu panth ne paami karu hu aatam ne ujamaad\nGuru charan grahi ne maare thavo che bhavpaar\nMaanav jeevan no saar, mhare banvu angaar[2] \nMhare banvu angaar[2] \nMhare taravo sansaar\nMhare banavu angaar\n\nSaiyam..Saiyam.. \nSaiyam..Saiyam.. \nMhare levo saiyam[2] \nMhare levo saiyam[3] \n',
    'originalSong':
        'Jaydeep Swadia, Jatin Bid, Kethan Dedhia, Bhavik Shah, Gautham Shah, Piyush Shah, Jainam Variya, Prashant Shah, Viral Surana, Paras Gada & Devansh Shah',
    'popularity': 0,
    'production': 'Tattva Tarang',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Saiyam Sargam (Diksha Mashup)',
    'songNameHindi': 'सैयाम मैशप (दीक्षा मैशप)',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/S5pOhGqP-JE',
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
