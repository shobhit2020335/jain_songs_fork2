import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();

  AddSong currentSong = AddSong(app);

  // currentSong.deleteSuggestion('chalomanagangs C0ww80');

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('BSRJ',
      englishName:
          'baktambar bhaktamber bhaktambar bhakanbar bhkatamar bhaktamar ravindar',
      hindiName: '',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  // pajushan parushan paryusan pajyushan bhairav parasnath parshwanath
  //शत्रुंजय shatrunjay siddhgiri siddhagiri पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment below to add song in realtimeDB.
  await currentSong.addToRealtimeDB().catchError((error) {
    print('Error: ' + error);
  }).then((value) {
    print('Added song to realtimeDB successfully');
  });
}

class AddSong {
  final FirebaseApp app;

  AddSong(this.app);

  Map<String, dynamic> currentSongMap = {
    'code': 'BSRJ',
    'album': '',
    'aaa': 'valid',
    'category': 'Stotra',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Sanskrit',
    'likes': 0,
    'lyrics':
        'भक्तामर प्रणत मौलिमणि प्रभाणा। मुद्योतकं दलित पाप तमोवितानम् ॥\nसम्यक् प्रणम्य जिन पादयुगं युगादा। वालंबनं भवजले पततां जनानाम् ॥१॥\n\nयः संस्तुतः सकल वाङ्मय तत्वबोधा। द् उद्भूत बुद्धिपटुभिः सुरलोकनाथैः ॥\nस्तोत्रैर्जगत्त्रितय चित्त हरैरुदरैः। स्तोष्ये किलाहमपि तं प्रथमं जिनेन्द्रम् ॥२॥\n\nबुद्ध्या विनाऽपि विबुधार्चित पादपीठ। स्तोतुं समुद्यत मतिर्विगतत्रपोऽहम् ॥\nबालं विहाय जलसंस्थितमिन्दु बिम्ब। मन्यः क इच्छति जनः सहसा ग्रहीतुम् ॥३॥\n\nवक्तुं गुणान् गुणसमुद्र शशाङ्क्कान्तान्। कस्ते क्षमः सुरगुरुप्रतिमोऽपि बुद्ध्या ॥\nकल्पान्त काल् पवनोद्धत नक्रचक्रं। को वा तरीतुमलमम्बुनिधिं भुजाभ्याम् ॥४॥\n\nसोऽहं तथापि तव भक्ति वशान्मुनीश। कर्तुं स्तवं विगतशक्तिरपि प्रवृत्तः ॥\nप्रीत्यऽऽत्मवीर्यमविचार्य मृगो मृगेन्द्रं। नाभ्येति किं निजशिशोः परिपालनार्थम् ॥५॥\n\nअल्पश्रुतं श्रुतवतां परिहासधाम्। त्वद्भक्तिरेव मुखरीकुरुते बलान्माम् ॥\nयत्कोकिलः किल मधौ मधुरं विरौति। तच्चाम्र-चारु-कलिका-निकरैक-हेतु ॥६॥\n\nत्वत्संस्तवेन भवसंतति सन्निबद्धं। पापं क्षणात् क्षयमुपैति शरीर भाजाम् ॥\nआक्रान्त लोकमलिनीलमशेषमाशु। सूर्यांशुभिन्नमिव शार्वरमन्धकारम् ॥७॥\n\nमत्वेति नाथ्! तव् संस्तवनं मयेद। मारभ्यते तनुधियापि तव प्रभावात् ॥\nचेतो हरिष्यति सतां नलिनीदलेषु। मुक्ताफल द्युतिमुपैति ननूदबिन्दुः ॥८॥\n\nआस्तां तव स्तवनमस्तसमस्त दोषं। त्वत्संकथाऽपि जगतां दुरितानि हन्ति ॥\nदूरे सहस्त्रकिरणः कुरुते प्रभैव। पद्माकरेषु जलजानि विकाशभांजि ॥९॥\n\nनात्यद् भूतं भुवन भुषण भूतनाथ। भूतैर् गुणैर् भुवि भवन्तमभिष्टुवन्तः ॥\nतुल्या भवन्ति भवतो ननु तेन किं वा। भूत्याश्रितं य इह नात्मसमं करोति ॥१०॥\n\nदृष्टवा भवन्तमनिमेष विलोकनीयं। नान्यत्र तोषमुपयाति जनस्य चक्षुः ॥\nपीत्वा पयः शशिकरद्युति दुग्ध सिन्धोः। क्षारं जलं जलनिधेरसितुं क इच्छेत् ॥११॥\n\nयैः शान्तरागरुचिभिः परमाणुभिस्तवं। निर्मापितस्त्रिभुवनैक ललाम भूत ॥\nतावन्त एव खलु तेऽप्यणवः पृथिव्यां। यत्ते समानमपरं न हि रूपमस्ति ॥१२॥\n\nवक्त्रं क्व ते सुरनरोरगनेत्रहारि। निःशेष निर्जित जगत् त्रितयोपमानम् ॥\nबिम्बं कलङ्क मलिनं क्व निशाकरस्य। यद्वासरे भवति पांडुपलाशकल्पम् ॥१३॥\n\nसम्पूर्णमण्ङल शशाङ्ककलाकलाप्। शुभ्रा गुणास्त्रिभुवनं तव लंघयन्ति ॥\nये संश्रितास् त्रिजगदीश्वर नाथमेकं। कस्तान् निवारयति संचरतो यथेष्टम् ॥१४॥\n\nचित्रं किमत्र यदि ते त्रिदशांगनाभिर्। नीतं मनागपि मनो न विकार मार्गम् ॥\nकल्पान्तकालमरुता चलिताचलेन। किं मन्दराद्रिशिखिरं चलितं कदाचित् ॥१५॥\n\nनिर्धूमवर्तिपवर्जित तैलपूरः। कृत्स्नं जगत्त्रयमिदं प्रकटी करोषि ॥\nगम्यो न जातु मरुतां चलिताचलानां। दीपोऽपरस्त्वमसि नाथ् जगत्प्रकाशः ॥१६॥\n\nनास्तं कादाचिदुपयासि न राहुगम्यः। स्पष्टीकरोषि सहसा युगपज्जगन्ति ॥\nनाम्भोधरोदर निरुद्धमहाप्रभावः। सूर्यातिशायिमहिमासि मुनीन्द्र! लोके ॥१७॥\n\nनित्योदयं दलितमोहमहान्धकारं। गम्यं न राहुवदनस्य न वारिदानाम् ॥\nविभ्राजते तव मुखाब्जमनल्प कान्ति। विद्योतयज्जगदपूर्व शशाङ्कबिम्बम् ॥१८॥\n\nकिं शर्वरीषु शशिनाऽह्नि विवस्वता वा। युष्मन्मुखेन्दु दलितेषु तमस्सु नाथ ॥\nनिष्मन्न शालिवनशालिनि जीव लोके। कार्यं कियज्जलधरैर् जलभार नम्रैः ॥१९॥\n\nज्ञानं यथा त्वयि विभाति कृतावकाशं। नैवं तथा हरिहरादिषु नायकेषु ॥\nतेजः स्फुरन्मणिषु याति यथा महत्वं। नैवं तु काच शकले किरणाकुलेऽपि ॥२०॥\n\nमन्ये वरं हरि हरादय एव दृष्टा। दृष्टेषु येषु हृदयं त्वयि तोषमेति ॥\nकिं वीक्षितेन भवता भुवि येन नान्यः। कश्चिन्मनो हरति नाथ! भवान्तरेऽपि ॥२१॥\n\nस्त्रीणां शतानि शतशो जनयन्ति पुत्रान्। नान्या सुतं त्वदुपमं जननी प्रसूता ॥\nसर्वा दिशो दधति भानि सहस्त्ररश्मिं। प्राच्येव दिग् जनयति स्फुरदंशुजालं ॥२२॥\n\nत्वामामनन्ति मुनयः परमं पुमांस। मादित्यवर्णममलं तमसः परस्तात् ॥\nत्वामेव सम्यगुपलभ्य जयंति मृत्युं। नान्यः शिवः शिवपदस्य मुनीन्द्र! पन्थाः ॥२३॥\n\nत्वामव्ययं विभुमचिन्त्यमसंख्यमाद्यं। ब्रह्माणमीश्वरम् अनंतमनंगकेतुम् ॥\nयोगीश्वरं विदितयोगमनेकमेकं। ज्ञानस्वरूपममलं प्रवदन्ति सन्तः ॥२४॥\n\nबुद्धस्त्वमेव विबुधार्चित बुद्धि बोधात्। त्वं शंकरोऽसि भुवनत्रय शंकरत्वात् ॥\nधाताऽसि धीर! शिवमार्ग विधेर्विधानात्। व्यक्तं त्वमेव भगवन्! पुरुषोत्तमोऽसि ॥२५॥\n\nतुभ्यं नमस्त्रिभुवनार्तिहराय नाथ। तुभ्यं नमः क्षितितलामलभूषणाय ॥\nतुभ्यं नमस्त्रिजगतः परमेश्वराय। तुभ्यं नमो जिन! भवोदधि शोषणाय ॥२६॥\n\nको विस्मयोऽत्र यदि नाम गुणैरशेषैस्। त्वं संश्रितो निरवकाशतया मुनीश! ॥\nदोषैरूपात्त विविधाश्रय जातगर्वैः। स्वप्नान्तरेऽपि न कदाचिदपीक्षितोऽसि ॥२७॥\n\nउच्चैरशोक तरुसंश्रितमुन्मयूख। माभाति रूपममलं भवतो नितान्तम् ॥\nस्पष्टोल्लसत्किरणमस्त तमोवितानं। बिम्बं रवेरिव पयोधर पार्श्ववर्ति ॥२८॥\n\nसिंहासने मणिमयूखशिखाविचित्रे। विभ्राजते तव वपुः कनकावदातम् ॥\nबिम्बं वियद्विलसदंशुलता वितानं। तुंगोदयाद्रि शिरसीव सहस्त्ररश्मेः ॥२९॥\n\nकुन्दावदात चलचामर चारुशोभं। विभ्राजते तव वपुः कलधौतकान्तम् ॥\nउद्यच्छशांक शुचिनिर्झर वारिधार। मुच्चैस्तटं सुर गिरेरिव शातकौम्भम् ॥३०॥\n\nछत्रत्रयं तव विभाति शशांककान्त। मुच्चैः स्थितं स्थगित भानुकर प्रतापम् ॥\nमुक्ताफल प्रकरजाल विवृद्धशोभं। प्रख्यापयत्त्रिजगतः परमेश्वरत्वम् ॥३१॥\n\nगम्भीरतारवपूरित दिग्विभागस्। त्रैलोक्यलोक शुभसंगम भूतिदक्षः ॥\nसद्धर्मराजजयघोषण घोषकः सन्। खे दुन्दुभिर्ध्वनति ते यशसः प्रवादी ॥३२॥\n\nमन्दार सुन्दरनमेरू सुपारिजात। सन्तानकादिकुसुमोत्कर- वृष्टिरुद्धा ॥\nगन्धोदबिन्दु शुभमन्द मरुत्प्रपाता। दिव्या दिवः पतित ते वचसां ततिर्वा ॥३३॥\n\nशुम्भत्प्रभावलय भूरिविभा विभोस्ते। लोकत्रये द्युतिमतां द्युतिमाक्षिपन्ती ॥\nप्रोद्यद् दिवाकर निरन्तर भूरिसंख्या। दीप्त्या जयत्यपि निशामपि सोम सौम्याम् ॥३४॥\n\nस्वर्गापवर्गगममार्ग विमार्गणेष्टः। सद्धर्मतत्वकथनैक पटुस्त्रिलोक्याः ॥\nदिव्यध्वनिर्भवति ते विशदार्थसत्व। भाषास्वभाव परिणामगुणैः प्रयोज्यः ॥३५॥\n\nउन्निद्रहेम नवपंकज पुंजकान्ती। पर्युल्लसन्नखमयूख शिखाभिरामौ ॥\nपादौ पदानि तव यत्र जिनेन्द्र! धत्तः। पद्मानि तत्र विबुधाः परिकल्पयन्ति ॥३६॥\n\nइत्थं यथा तव विभूतिरभूज्जिनेन्द्र। धर्मोपदेशनविधौ न तथा परस्य ॥\nयादृक् प्रभा दिनकृतः प्रहतान्धकारा। तादृक् कुतो ग्रहगणस्य विकाशिनोऽपि ॥३७॥\n\nश्च्योतन्मदाविलविलोल कपोलमूल। मत्तभ्रमद् भ्रमरनाद विवृद्धकोपम् ॥\nऐरावताभमिभमुद्धतमापतन्तं। दृष्ट्वा भयं भवति नो भवदाश्रितानाम् ॥३८॥\n\nभिन्नेभ कुम्भ गलदुज्जवल शोणिताक्त। मुक्ताफल प्रकर भूषित भुमिभागः ॥\nबद्धक्रमः क्रमगतं हरिणाधिपोऽपि। नाक्रामति क्रमयुगाचलसंश्रितं ते ॥३९॥\n\nकल्पांतकाल पवनोद्धत वह्निकल्पं। दावानलं ज्वलितमुज्जवलमुत्स्फुलिंगम् ॥\nविश्वं जिघत्सुमिव सम्मुखमापतन्तं। त्वन्नामकीर्तनजलं शमयत्यशेषम् ॥४०॥\n\nरक्तेक्षणं समदकोकिल कण्ठनीलं। क्रोधोद्धतं फणिनमुत्फणमापतन्तम् ॥\nआक्रामति क्रमयुगेन निरस्तशंकस्। त्वन्नाम नागदमनी हृदि यस्य पुंसः ॥४१॥\n\nवल्गत्तुरंग गजगर्जित भीमनाद। माजौ बलं बलवतामपि भूपतिनाम्! ॥\nउद्यद्दिवाकर मयूख शिखापविद्धं। त्वत्- कीर्तनात् तम इवाशु भिदामुपैति ॥४२॥\n\nकुन्ताग्रभिन्नगज शोणितवारिवाह। वेगावतार तरणातुरयोध भीमे ॥\nयुद्धे जयं विजितदुर्जयजेयपक्षास्। त्वत्पाद पंकजवनाश्रयिणो लभन्ते ॥४३॥\n\nअम्भौनिधौ क्षुभितभीषणनक्रचक्र। पाठीन पीठभयदोल्बणवाडवाग्नौ ॥\nरंगत्तरंग शिखरस्थित यानपात्रास्। त्रासं विहाय भवतःस्मरणाद् व्रजन्ति ॥४४॥\n\nउद्भूतभीषणजलोदर भारभुग्नाः। शोच्यां दशामुपगताश्च्युतजीविताशाः ॥\nत्वत्पादपंकज रजोऽमृतदिग्धदेहा। मर्त्या भवन्ति मकरध्वजतुल्यरूपाः ॥४५॥\n\nआपाद कण्ठमुरूश्रृंखल वेष्टितांगा। गाढं बृहन्निगडकोटिनिघृष्टजंघाः ॥\nत्वन्नाममंत्रमनिशं मनुजाः स्मरन्तः। सद्यः स्वयं विगत बन्धभया भवन्ति ॥४६॥\n\nमत्तद्विपेन्द्र मृगराज दवानलाहि। संग्राम वारिधि महोदर बन्धनोत्थम् ॥\nतस्याशु नाशमुपयाति भयं भियेव। यस्तावकं स्तवमिमं मतिमानधीते ॥४७॥\n\nस्तोत्रस्त्रजं तव जिनेन्द्र! गुणैर्निबद्धां। भक्त्या मया विविधवर्णविचित्रपुष्पाम् ॥\nधत्ते जनो य इह कंठगतामजस्रं। तं मानतुंगमवशा समुपैति लक्ष्मीः ॥४८॥\n',
    'englishLyrics':
        'Bhaktamara-pranata-maulimani-prabhana - Mudyotakam Dalita-papa-tamovitanam \n Samyak Pranamya Jina Padayugam Yugadavalambanam Bhavajale Patatam Jananam 1\n\n Yah Sanstutah Sakala-vangaya- Tatva-bodhad -ud Bhuta- Buddhipatubhih Suralokanathaih\n Stotrairjagattritaya Chitta-harairudaraih Stoshye Kilahamapi Tam Prathamam Jinendram 2\n\n Buddhya Vinaapi Vibudharchita Padapitha Stotum Samudyata Matirvigatatrapoaham \n Balam Vihaya Jalasansthitamindu Bimba - Manyah Ka Ichchhati Janah Sahasa Grahitum 3\n\n Vaktum Gunan Gunasamudra Shashankkantan Kaste Kshamah Suragurupratimoapi Buddhya \n Kalpanta - Kal - Pavanoddhata - Nakrachakram Ko Va Taritumalamambunidhim Bhujabhyam 4\n\n Soaham Tathapi Tava Bhakti Vashanmunisha Kartum Stavam Vigatashaktirapi Pravrittah \nprityaaatmaviryamavicharya Mrigo Mrigendram Nabhyeti Kim Nijashishoh Paripalanartham 5\n\nalpashrutam Shrutavatam Parihasadham Tvad Bhaktireva Mukharikurute Balanmam \n Yatkokilah Kila Madhau Madhuram Virauti Tachcharuchuta - Kalikanikaraikahetu 6\n\n Tvatsanstavena Bhavasantati - Sannibaddham Papam Kshanat Kshayamupaiti Sharira Bhajam \n Akranta - Lokamalinilamasheshamashu Suryanshubhinnamiva Sharvaramandhakaram 7\n\n Matveti Nath! Tav Sanstavanam Mayeda - Marabhyate Tanudhiyapi Tava Prabhavat \n Cheto Harishyati Satam Nalinidaleshu Muktaphala - Dyutimupaiti Nanudabinduh 8\n\nastam Tava Stavanamastasamasta - Dosham Tvatsankathaapi Jagatam Duritani Hanti \n Dure Sahastrakiranah Kurute Prabhaiva Padmakareshu Jalajani Vikashabhanji 9\n\n Natyad -bhutam Bhuvana-bhushana Bhutanatha Bhutaira Gunair -bhuvi Bhavantamabhishtuvantah Tulya Bhavanti Bhavato Nanu Tena Kim Va Bhutyashritam Ya Iha Natmasamam Karoti 10\n\n Drishtava Bhavantamanimesha-vilokaniyam Nanyatra Toshamupayati Janasya Chakshuh \n Pitva Payah Shashikaradyuti Dugdha Sindhoh Ksharam Jalam Jalanidherasitum Ka Ichchhet 11\n\n Yaih Shantaragaruchibhih Paramanubhistavam Nirmapitastribhuvanaika Lalama-bhuta\n Tavanta Eva Khalu Teapyanavah Prithivyam Yatte Samanamaparam Na Hi Rupamasti 12\n\n Vaktram Kva Te Suranaroraganetrahari Nihshesha - Nirjita-jagat Tritayopamanam \n Bimbam Kalanka-malinam Kva Nishakarasya Yad Vasare Bhavati Pandupalashakalpam 13\n\n Sampurnamannala - Shashankakalakalap Shubhra Gunastribhuvanam Tava Langhayanti \n Ye Sanshritas -trijagadishvara Nathamekam Kastan -nivarayati Sancharato Yatheshtam 14\n\n Chitram Kimatra Yadi Te Tridashanganabhir - Nitam Managapi Mano Na Vikara - Margam \n Kalpantakalamaruta Chalitachalena Kim Mandaradrishikhiram Chalitam Kadachit 15\n\n Nirdhumavartipavarjita - Tailapurah Kritsnam Jagattrayamidam Prakati-karoshi \n Gamyo Na Jatu Marutam Chalitachalanam Dipoaparastvamasi Nath Jagatprakashah 16\n\nnastam Kadachidupayasi Na Rahugamyah Spashtikaroshi Sahasa Yugapajjaganti \n Nambhodharodara - Niruddhamahaprabhavah Suryatishayimahimasi Munindra! Loke 17\n\n Nityodayam Dalitamohamahandhakaram Gamyam Na Rahuvadanasya Na Varidanam \n Vibhrajate Tava Mukhabjamanalpa Kanti Vidyotayajjagadapurva - Shashankabimbam 18\n\n Kim Sharvarishu Shashinaahni Vivasvata Va Yushmanmukhendu - Daliteshu Tamassu Natha Nishmanna Shalivanashalini Jiva Loke Karyam Kiyajjaladharair - Jalabhara Namraih 19\n\n Gyanam Yatha Tvayi Vibhati Kritavakasham Naivam Tatha Hariharadishu Nayakeshu Tejah Sphuranmanishu Yati Yatha Mahatvam Naivam Tu Kacha - Shakale Kiranakuleapi 20\n\n Manye Varam Hari-haradaya Eva Drishta Drishteshu Yeshu Hridayam Tvayi Toshameti \n Kim Vikshitena Bhavata Bhuvi Yena Nanyah Kashchinmano Harati Natha! Bhavantareapi 21\n\n Strinam Shatani Shatasho Janayanti Putran Nanya Sutam Tvadupamam Janani Prasuta\n Sarva Disho Dadhati Bhani Sahastrarashmim Prachyeva Dig Janayati Sphuradanshujalam 22\n\n Tvamamananti Munayah Paramam Pumansamadityavarnamamalam Tamasah Parastat \n Tvameva Samyagupalabhya Jayanti Mrityum Nanyah Shivah Shivapadasya Munindra! Panthah 23\n\n Tvamavyayam Vibhumachintyamasankhyamadyam Brahmanamishvaramanantamanangaketum Yogishvaram Viditayogamanekamekam Gyanasvarupamamalam Pravadanti Santah 24\n\nbuddhastvameva Vibudharchita Buddhi Bodhat , Tvam Shankaroasi Bhuvanatraya Shankaratvat \n Dhataasi Dhira ! Shivamarga-vidhervidhanat , Vyaktam Tvameva Bhagavan ! Purushottamoasi 25\n\n Tubhyam Namastribhuvanartiharaya Natha \n Tubhyam Namah Kshititalamalabhushanaya \n Tubhyam Namastrijagatah Parameshvaraya, Tubhyam Namo Jina ! Bhavodadhi Shoshanaya 26\n\n Ko Vismayoatra Yadi Nama Gunairasheshais - Tvam Sanshrito Niravakashataya Munisha! Doshairupatta Vividhashraya Jatagarvaih, Svapnantareapi Na Kadachidapikshitoasi 27\n\n Uchchairashoka-tarusanshritamunmayukhamabhati Rupamamalam Bhavato Nitantam \n Spashtollasatkiranamasta-tamovitanam Bimbam Raveriva Payodhara Parshvavarti 28\n\n\n Simhasane Manimayukhashikhavichitre, Vibhrajate Tava Vapuh Kanakavadatam \n Bimbam Viyadvilasadanshulata - Vitanam, Tungodayadri - Shirasiva Sahastrarashmeh 29\n\n Kundavadata - Chalachamara - Charushobham, Vibhrajate Tava Vapuh Kaladhautakantam \n Udyachchhashanka - Shuchinirjhara - Varidhara-, Muchchaistatam Sura Gireriva Shatakaumbham 30\n\n Chhatratrayam Tava Vibhati Shashankakantamuchchaih Sthitam Sthagita Bhanukara - Pratapam \n Muktaphala - Prakarajala - Vivriddhashobham, Prakhyapayattrijagatah Parameshvaratvam 31\n\n Gambhirataravapurita - Digvibhagas - Trailokyaloka - Shubhasangama Bhutidakshah \n Saddharmarajajayaghoshana - Ghoshakah San , Khe Dundubhirdhvanati Te Yashasah Pravadi 32\n\nmandara - Sundaranameru - Suparijata Santanakadikusumotkara-vrishtiruddha \n Gandhodabindu - Shubhamanda - Marutprapata, Divya Divah Patita Te Vachasam Tatirva 33\n\n Shumbhatprabhavalaya - Bhurivibha Vibhoste, Lokatraye Dyutimatam Dyutimakshipanti \n Prodyad -divakara - Nirantara Bhurisankhya Diptya Jayatyapi Nishamapi Soma-saumyam 34\n\n Svargapavargagamamarga - Vimarganeshtah, Saddharmatatvakathanaika - Patustrilokyah \n Divyadhvanirbhavati Te Vishadarthasatva Bhashasvabhava - Parinamagunaih Prayojyah 35\n\n Unnidrahema - Navapankaja - Punjakanti, Paryullasannakhamayukha-shikhabhiramau \n Padau Padani Tava Yatra Jinendra ! Dhattah Padmani Tatra Vibudhah Parikalpayanti 36\n\n Ittham Yatha Tava Vibhutirabhujjinendra, Dharmopadeshanavidhau Na Tatha Parasya \n Yadrik Prabha Dinakritah Prahatandhakara, Tadrik -kuto Grahaganasya Vikashinoapi 37\n\n Shchyotanmadavilavilola-kapolamula Mattabhramad -bhramaranada - Vivriddhakopam\nairavatabhamibhamuddhatamapatantan Drisht Va Bhayam Bhavati No Bhavadashritanam 38\n\n Bhinnebha - Kumbha - Galadujjavala - Shonitakta, Muktaphala Prakara - Bhushita Bhumibhagah \n Baddhakramah Kramagatam Harinadhipoapi, Nakramati Kramayugachalasanshritam Te 39\n\n Kalpantakala - Pavanoddhata - Vahnikalpam, Davanalam Jvalitamujjavalamutsphulingam \n Vishvam Jighatsumiva Sammukhamapatantam, Tvannamakirtanajalam Shamayatyashesham 40\n\nraktekshanam Samadakokila - Kanthanilam, Krodhoddhatam Phaninamutphanamapatantam \n Akramati Kramayugena Nirastashankas - Tvannama Nagadamani Hridi Yasya Punsah 41\n\n Valgatturanga Gajagarjita - Bhimanadamajau Balam Balavatamapi Bhupatinam ! Udyaddivakara Mayukha - Shikhapaviddham, Tvat -kirtanat Tama Ivashu Bhidamupaiti 42\n\n Kuntagrabhinnagaja - Shonitavarivaha Vegavatara - Taranaturayodha - Bhime \n Yuddhe Jayam Vijitadurjayajeyapakshas - Tvatpada Pankajavanashrayino Labhante 43\n\n Ambhaunidhau Kshubhitabhishananakrachakrapathina Pithabhayadolbanavadavagnau Rangattaranga - Shikharasthita - Yanapatras - Trasam Vihaya Bhavatahsmaranad Vrajanti 44\n\n Ud Bhutabhishanajalodara - Bharabhugnah Shochyam Dashamupagatashchyutajivitashah \n Tvatpadapankaja-rajoamritadigdhadeha, Martya Bhavanti Makaradhvajatulyarupah 45\n\n Apada - Kanthamurushrrinkhala - Veshtitanga, Gadham Brihannigadakotinighrishtajanghah \n Tvannamamantramanisham Manujah Smarantah, Sadyah Svayam Vigata-bandhabhaya Bhavanti 46\n\n Mattadvipendra - Mrigaraja - Davanalahi Sangrama - Varidhi - Mahodara-bandhanottham \n Tasyashu Nashamupayati Bhayam Bhiyeva, Yastavakam Stavamimam Matimanadhite 47\n\n Stotrastrajam Tava Jinendra ! Gunairnibaddham, Bhaktya Maya Vividhavarnavichitrapushpam \n Dhatte Jano Ya Iha Kanthagatamajasram, Tam Manatungamavasha Samupaiti Lakshmih 48\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Ravindra Jain',
    'share': 0,
    'singer': 'Ravindra Jain',
    'songNameEnglish': 'Bhaktamar Stotra Ravindra Jain',
    'songNameHindi': 'भक्तामर स्तोत्र रविंद्र जैन',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/nm-tQGPx2N8',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  CollectionReference suggestion =
      FirebaseFirestore.instance.collection('suggestions');

  String searchKeywords = '';

  Future<void> deleteSuggestion(String uid) async {
    return suggestion.doc(uid).delete().then((value) {
      print('Deleted Successfully');
    });
  }

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
    searchKeywords =
        searchKeywords.toLowerCase() + ' ' + englishName + ' ' + hindiName;
    searchKeywords = searchKeywords +
        ' ' +
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
    List<String> searchWordsList = searchKeywords.toLowerCase().split(' ');
    searchKeywords = "";
    for (int i = 0; i < searchWordsList.length; i++) {
      if (searchWordsList[i].length > 0) {
        searchKeywords += ' ' + searchWordsList[i];
      }
    }
    currentSongMap['searchKeywords'] = searchKeywords;
    // _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  //Directly writing search keywords so not required now.
  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }

  Future<void> addToRealtimeDB() async {
    FirebaseDatabase(app: this.app)
        .reference()
        .child('songs')
        .child(currentSongMap['code'])
        .set(currentSongMap);
  }
}
