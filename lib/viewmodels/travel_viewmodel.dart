import 'package:flutter/foundation.dart';
import '../models/travel_destination.dart';
import '../models/travel_question.dart';
import '../models/user_profile.dart';

class TravelViewModel extends ChangeNotifier {
  final List<String> _userPreferences = [];
  List<TravelDestination> _recommendations = [];
  String _selectedSeason = 'Yaz';
  bool _surveyCompleted = false;
  int _currentQuestionIndex = 0;
  Map<String, String> _userAnswers = {};
  bool _welcomeScreenCompleted = false;
  UserProfile _userProfile = UserProfile(name: 'Gezgin', email: '');
  String _userName = '';
  String _userSurname = '';
  String? _userPhoneNumber;
  String? _userBirthDate;
  String _userEmail = '';
  String? _profileImagePath;

  List<TravelDestination> get recommendations => _recommendations;
  String get selectedSeason => _selectedSeason;
  bool get surveyCompleted => _surveyCompleted;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get welcomeScreenCompleted => _welcomeScreenCompleted;
  String get userName => _userName;
  String get userSurname => _userSurname;
  String? get userPhoneNumber => _userPhoneNumber;
  String? get userBirthDate => _userBirthDate;
  UserProfile get userProfile => _userProfile;
  String get userEmail => _userEmail;
  String? get profileImagePath => _profileImagePath;

  final List<TravelQuestion> questions = [
    TravelQuestion(
      question: 'Ne tür aktivitelerden hoşlanırsınız?',
      options: [
        'Doğa Sporları',
        'Kültür Gezileri',
        'Plaj Aktiviteleri',
        'Macera Sporları'
      ],
      category: 'activity',
    ),
    TravelQuestion(
      question: 'Seyahat bütçeniz nedir?',
      options: ['Ekonomik', 'Orta', 'Lüks'],
      category: 'budget',
    ),
    TravelQuestion(
      question: 'Tercih ettiğiniz seyahat süresi?',
      options: ['Hafta Sonu', '1 Hafta', '2 Hafta ve Üzeri'],
      category: 'duration',
    ),
  ];

  void setUserPreference(String preference) {
    _userPreferences.add(preference);
    notifyListeners();
  }

  void setSeason(String season) {
    _selectedSeason = season;
    _generateRecommendations();
    notifyListeners();
  }

  void answerQuestion(String answer) {
    _userAnswers[questions[_currentQuestionIndex].category] = answer;

    // Son soruya geldiysek
    if (_currentQuestionIndex == questions.length - 1) {
      _surveyCompleted = true;
      _generateRecommendations();
      notifyListeners();
      return;
    }

    // Sonraki soruya geç
    _currentQuestionIndex++;
    notifyListeners();
  }

  void completeWelcomeScreen() {
    _welcomeScreenCompleted = true;
    notifyListeners();
  }

  void _generateRecommendations() {
    final activity = _userAnswers['activity']?.toLowerCase() ?? '';
    final budget = _userAnswers['budget']?.toLowerCase() ?? '';
    final duration = _userAnswers['duration']?.toLowerCase() ?? '';

    if (activity.isEmpty) {
      _recommendations = [];
      return;
    }

    // DOĞA SPORLARI KOMBİNASYONLARI

    // 1. Ekonomik + Hafta Sonu
    if (activity == 'doğa sporları' &&
        budget == 'ekonomik' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Uludağ Milli Parkı',
          description:
              'İstanbul\'a yakın, hafta sonu kaçamağı için ideal. Doğa yürüyüşü ve kamp imkanları.',
          imageUrl:
              'https://images.unsplash.com/photo-1604537466158-719b1972feb8',
          activities: [
            'Doğa Yürüyüşü',
            'Kamp',
            'Fotoğrafçılık',
            'Dağ Bisikleti'
          ],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Sapanca Gölü',
          description:
              'Doğayla iç içe bir hafta sonu. Göl kenarında yürüyüş ve bisiklet rotaları.',
          imageUrl:
              'https://images.unsplash.com/photo-1565708097881-bbf4ecf47cc1',
          activities: ['Bisiklet', 'Yürüyüş', 'Piknik', 'Fotoğrafçılık'],
          season: selectedSeason,
          rating: 4.5,
        ),
        TravelDestination(
          name: 'Belgrad Ormanı',
          description:
              'İstanbul\'un oksijen deposu. Hafta sonu yürüyüşleri için mükemmel rotalar.',
          imageUrl:
              'https://images.unsplash.com/photo-1448375240586-882707db888b',
          activities: ['Yürüyüş', 'Koşu', 'Piknik', 'Doğa Fotoğrafçılığı'],
          season: selectedSeason,
          rating: 4.4,
        ),
        // ... 7 tane daha öneri eklenecek
      ];
    }

    // 2. Ekonomik + 1 Hafta
    else if (activity == 'doğa sporları' &&
        budget == 'ekonomik' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Yenice Ormanları',
          description:
              'Karabük\'ün saklı cenneti. Yürüyüş ve bisiklet rotalarıyla dolu bakir ormanlar.',
          imageUrl:
              'https://images.unsplash.com/photo-1473448912268-2022ce9509d8',
          activities: [
            'Trekking',
            'Dağ Bisikleti',
            'Kamp',
            'Yaban Hayatı Gözlemi'
          ],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Küre Dağları',
          description:
              'Kastamonu\'nun eşsiz doğası. Şelaleler, kanyonlar ve yürüyüş parkurları.',
          imageUrl:
              'https://images.unsplash.com/photo-1486870591958-9b9d0d1dda99',
          activities: [
            'Kanyon Yürüyüşü',
            'Kamp',
            'Şelale Turu',
            'Doğa Fotoğrafçılığı'
          ],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Ilgaz Dağı',
          description:
              'Dört mevsim doğa sporları. Ekonomik konaklama ve aktivite seçenekleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1454496522488-7a8e488e8606',
          activities: ['Yürüyüş', 'Kamp', 'Dağcılık', 'Kayak'],
          season: selectedSeason,
          rating: 4.5,
        ),
        // ... 7 tane daha öneri eklenecek
      ];
    }

    // 3. Ekonomik + 2 Hafta ve Üzeri
    else if (activity == 'doğa sporları' &&
        budget == 'ekonomik' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Via Egnatia Yürüyüş Yolu',
          description:
              'Antik Roma yolunda uzun mesafe yürüyüşü. Edirne\'den İstanbul\'a tarihi bir rota.',
          imageUrl:
              'https://images.unsplash.com/photo-1533240332313-0db49b459ad6',
          activities: [
            'Uzun Mesafe Yürüyüş',
            'Kamp',
            'Tarihi Keşif',
            'Kültür Turu'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Likya Yolu',
          description:
              'Fethiye\'den Antalya\'ya uzanan antik patika. Deniz manzaralı 540km\'lik rota.',
          imageUrl:
              'https://images.unsplash.com/photo-1526491109672-74740652b963',
          activities: ['Trekking', 'Kamp', 'Antik Kent Gezisi', 'Deniz'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Kars - Sarıkamış',
          description:
              'Doğu Anadolu\'nun eşsiz doğası. Sarıçam ormanları ve kayak imkanları.',
          imageUrl:
              'https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22',
          activities: ['Kayak', 'Kamp', 'Doğa Yürüyüşü', 'Fotoğrafçılık'],
          season: selectedSeason,
          rating: 4.6,
        ),
        // ... 7 tane daha öneri eklenecek
      ];
    }

    // 4. Orta + Hafta Sonu
    else if (activity == 'doğa sporları' &&
        budget == 'orta' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Abant Gölü',
          description:
              'Bolu\'nun doğa harikası. Göl çevresi yürüyüşü ve at binme imkanları.',
          imageUrl:
              'https://images.unsplash.com/photo-1502786129293-79981df4e689',
          activities: [
            'At Binme',
            'Yürüyüş',
            'Göl Turu',
            'Doğa Fotoğrafçılığı'
          ],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Kartepe',
          description:
              'İstanbul\'a yakın kış sporları merkezi. Kayak ve snowboard imkanları.',
          imageUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256',
          activities: ['Kayak', 'Snowboard', 'Doğa Yürüyüşü', 'Manzara Seyri'],
          season: selectedSeason,
          rating: 4.5,
        ),
        TravelDestination(
          name: 'Yedigöller',
          description:
              'Bolu\'nun yedi gölü. Sonbahar renkleri ve doğa fotoğrafçılığı.',
          imageUrl:
              'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1',
          activities: ['Fotoğrafçılık', 'Yürüyüş', 'Kamp', 'Göl Turu'],
          season: selectedSeason,
          rating: 4.7,
        ),
        // ... 7 tane daha öneri eklenecek
      ];
    }

    // 5. Orta + 1 Hafta (devam)
    else if (activity == 'doğa sporları' &&
        budget == 'orta' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Kaçkar Dağları',
          description:
              'Rize\'nin eşsiz yaylaları. Profesyonel rehberli trekking turları.',
          imageUrl:
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b',
          activities: ['Trekking', 'Yayla Gezisi', 'Kamp', 'Fotoğrafçılık'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Aladağlar',
          description:
              'Niğde\'nin görkemli dağları. Dağcılık ve tırmanış rotaları.',
          imageUrl:
              'https://images.unsplash.com/photo-1483728642387-6c3bdd6c93e5',
          activities: ['Dağcılık', 'Tırmanış', 'Kamp', 'Manzara'],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Fethiye - Ölüdeniz',
          description:
              'Yamaç paraşütü ve doğa sporları merkezi. Profesyonel eğitmenler eşliğinde.',
          imageUrl:
              'https://images.unsplash.com/photo-1528127269322-539801943592',
          activities: ['Yamaç Paraşütü', 'Trekking', 'Deniz', 'Dalış'],
          season: selectedSeason,
          rating: 4.9,
        ),
        // ... 7 tane daha öneri eklenecek
      ];
    }

    // 6. Orta + 2 Hafta ve Üzeri
    else if (activity == 'doğa sporları' &&
        budget == 'orta' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'İsviçre Alpleri',
          description:
              'Avrupa\'nın çatısında doğa sporları. Rehberli turlar ve konforlu konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1531366936337-7c912a4589a7',
          activities: ['Dağcılık', 'Kayak', 'Hiking', 'Bisiklet'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Nepal - Annapurna',
          description:
              'Himalayalar\'da unutulmaz bir deneyim. Tecrübeli rehberler eşliğinde.',
          imageUrl: 'https://images.unsplash.com/photo-1544735716-392fe2489ffa',
          activities: [
            'Trekking',
            'Kültür Turu',
            'Fotoğrafçılık',
            'Meditasyon'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Norveç Fiyortları',
          description:
              'Kuzey Avrupa\'nın doğa harikaları. Fiyort tırmanışı ve kayak imkanları.',
          imageUrl:
              'https://images.unsplash.com/photo-1513519245088-0e12902e5a38',
          activities: ['Kayak', 'Tırmanış', 'Fiyort Turu', 'Kamp'],
          season: selectedSeason,
          rating: 4.7,
        ),
        // ... 7 tane daha öneri eklenecek
      ];
    }

    // 7. Lüks + Hafta Sonu
    else if (activity == 'doğa sporları' &&
        budget == 'lüks' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Pamukkale Termal',
          description:
              'Özel termal otel deneyimi. Spa, masaj ve doğal terapi imkanları.',
          imageUrl:
              'https://images.unsplash.com/photo-1585068026984-52c8cb27ed5d',
          activities: [
            'Termal Havuz',
            'Spa',
            'Doğa Yürüyüşü',
            'Antik Kent Turu'
          ],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Cappadocia Cave Suites',
          description:
              'Lüks mağara otel deneyimi. Özel balon turları ve şarap tadımı.',
          imageUrl:
              'https://images.unsplash.com/photo-1585637071663-ce4c3c281b24',
          activities: ['Balon Turu', 'Şarap Tadımı', 'ATV Safari', 'At Binme'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Bodrum Mandarin Oriental',
          description:
              'Özel plajlı lüks resort. Yat turları ve su sporları aktiviteleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1582719508461-905c673771fd',
          activities: ['Yat Turu', 'Su Sporları', 'Spa', 'Gurme Restoran'],
          season: selectedSeason,
          rating: 4.8,
        ),
      ];
    }

    // 8. Lüks + 1 Hafta
    else if (activity == 'doğa sporları' &&
        budget == 'lüks' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Courchevel - Fransa',
          description:
              'Fransız Alplerinde lüks kayak deneyimi. Michelin yıldızlı restoranlar.',
          imageUrl: 'https://images.unsplash.com/photo-1551867633-194f125bddfa',
          activities: ['Kayak', 'Helikopter Turu', 'Spa', 'Gurme Deneyimi'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Seychelles Adaları',
          description:
              'Özel plajlı villa deneyimi. Kişisel şef ve butler hizmeti.',
          imageUrl: 'https://images.unsplash.com/photo-1553603227-2358aabe821f',
          activities: ['Özel Plaj', 'Dalış', 'Spa', 'Yat Turu'],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'Banff Springs Hotel',
          description:
              'Kanada Rockies\'de şato benzeri otel. Özel doğa turları ve spa.',
          imageUrl:
              'https://images.unsplash.com/photo-1609825488888-3a766db05542',
          activities: ['Golf', 'Spa', 'Helikopter Turu', 'Kayak'],
          season: selectedSeason,
          rating: 4.8,
        ),
      ];
    }

    // 9. Lüks + 2 Hafta ve Üzeri
    else if (activity == 'doğa sporları' &&
        budget == 'lüks' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Yeni Zelanda Özel Tur',
          description:
              'Lord of the Rings film lokasyonları. Özel helikopter ve rehber.',
          imageUrl:
              'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800',
          activities: [
            'Helikopter Turu',
            'Yürüyüş',
            'Rafting',
            'Film Lokasyonları'
          ],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Safari & Zanzibar',
          description: 'Özel safari deneyimi ve lüks plaj tatili kombinasyonu.',
          imageUrl:
              'https://images.unsplash.com/photo-1516426122078-c23e76319801',
          activities: ['Safari', 'Plaj', 'Spa', 'Yerel Kültür'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Patagonya Ekspedisyonu',
          description:
              'Lüks lodge\'larda konaklama. Özel rehber ve ekipman desteği.',
          imageUrl:
              'https://images.unsplash.com/photo-1531794506823-8f8b56144f65',
          activities: [
            'Trekking',
            'Buzul Turu',
            'Fotoğrafçılık',
            'Doğa Gözlemi'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
      ];
    }

    // PLAJ AKTİVİTELERİ KOMBİNASYONLARI

    // 1. Plaj - Ekonomik + Hafta Sonu
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'ekonomik' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Şile Plajları',
          description:
              'İstanbul\'a yakın mavi bayraklı plajlar. Ekonomik pansiyon seçenekleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Plaj', 'Yüzme', 'Balık Restoranları', 'Sahil Yürüyüşü'],
          season: selectedSeason,
          rating: 4.3,
        ),
        TravelDestination(
          name: 'Ayvalık Plajları',
          description:
              'Ege\'nin berrak suları. Ekonomik butik oteller ve kamp alanları.',
          imageUrl:
              'https://images.unsplash.com/photo-1519046904884-53103b34b206',
          activities: ['Plaj', 'Kamp', 'Dalış', 'Tekne Turu'],
          season: selectedSeason,
          rating: 4.4,
        ),
        TravelDestination(
          name: 'Akçakoca',
          description:
              'Karadeniz\'in sakin plajları. Aile pansiyonları ve yerel lezzetler.',
          imageUrl:
              'https://images.unsplash.com/photo-1520942702018-0862200e6873',
          activities: ['Plaj', 'Balık Tutma', 'Yürüyüş', 'Yerel Pazarlar'],
          season: selectedSeason,
          rating: 4.2,
        ),
      ];
    }

    // 2. Plaj - Ekonomik + 1 Hafta
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'ekonomik' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Olimpos',
          description:
              'Antik kent içinde kamp ve bungalov. Doğal plajlar ve tarihi atmosfer.',
          imageUrl:
              'https://images.unsplash.com/photo-1509233725247-49e657c54213',
          activities: ['Plaj', 'Kamp', 'Antik Kent', 'Doğa Yürüyüşü'],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Datça',
          description:
              'Bakir koylar ve sakin plajlar. Apart oteller ve pansiyon seçenekleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1519861531473-9200262188bf',
          activities: ['Plaj', 'Yüzme', 'Köy Pazarı', 'Antik Kent'],
          season: selectedSeason,
          rating: 4.5,
        ),
        TravelDestination(
          name: 'Gökçeada',
          description:
              'Organik ada yaşamı. Sörf ve kamp imkanları, ekonomik konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1506929562872-bb421503ef21',
          activities: ['Plaj', 'Sörf', 'Kamp', 'Bisiklet'],
          season: selectedSeason,
          rating: 4.4,
        ),
      ];
    }

    // 3. Plaj - Ekonomik + 2 Hafta ve Üzeri
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'ekonomik' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Kaş - Kalkan Rotası',
          description:
              'Akdeniz\'in en güzel koyları. Ekonomik apart ve pansiyon seçenekleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1519046904884-53103b34b206',
          activities: ['Plaj', 'Dalış', 'Tekne Turu', 'Antik Kent'],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Kuzey Ege Turu',
          description:
              'Assos\'tan Ayvalık\'a uzanan rota. Kamp ve pansiyon konaklamalı.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Plaj', 'Kamp', 'Antik Kentler', 'Yerel Pazarlar'],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Fethiye - Ölüdeniz',
          description:
              'Mavi bayraklı plajlar ve lagün. Ekonomik apart ve pansiyon seçenekleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1519861531473-9200262188bf',
          activities: ['Plaj', 'Paraşüt', 'Tekne Turu', 'Doğa Yürüyüşü'],
          season: selectedSeason,
          rating: 4.8,
        ),
      ];
    }

    // 4. Plaj - Orta + Hafta Sonu
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'orta' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Çeşme Plajları',
          description:
              'Butik otellerde konforlu konaklama. Rüzgar sörfü ve plaj kulüpleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1520942702018-0862200e6873',
          activities: ['Plaj', 'Sörf', 'Su Sporları', 'Gece Hayatı'],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Bodrum Yarımadası',
          description:
              'Özel plajlı butik oteller. Yat turları ve su sporları aktiviteleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1506929562872-bb421503ef21',
          activities: ['Plaj', 'Yat Turu', 'Su Sporları', 'Gece Hayatı'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Alanya Sahilleri',
          description:
              'Resort otellerde yarım pansiyon konaklama. Su sporları ve eğlence.',
          imageUrl:
              'https://images.unsplash.com/photo-1509233725247-49e657c54213',
          activities: ['Plaj', 'Su Sporları', 'Kale Turu', 'Gece Hayatı'],
          season: selectedSeason,
          rating: 4.6,
        ),
      ];
    }

    // 5. Plaj - Orta + 1 Hafta
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'orta' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Kıbrıs Bafra',
          description:
              'Her şey dahil resort oteller. Casino ve eğlence merkezleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1540541338287-41700207dee6',
          activities: ['Plaj', 'Casino', 'Su Sporları', 'Spa'],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Side Antik Kent',
          description:
              'Tarihi atmosferde plaj tatili. Butik oteller ve su sporları.',
          imageUrl:
              'https://images.unsplash.com/photo-1519046904884-53103b34b206',
          activities: ['Plaj', 'Antik Kent', 'Su Sporları', 'Gece Hayatı'],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Kuşadası',
          description:
              'Marina manzaralı oteller. Cruise gemileri ve eğlence mekanları.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Plaj', 'Marina Turu', 'Alışveriş', 'Gece Hayatı'],
          season: selectedSeason,
          rating: 4.5,
        ),
      ];
    }

    // 6. Plaj - Orta + 2 Hafta ve Üzeri
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'orta' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Yunan Adaları Turu',
          description: 'Santorini, Mykonos ve Rodos. Feribot geçişli ada turu.',
          imageUrl:
              'https://images.unsplash.com/photo-1533104816931-20fa691ff6ca',
          activities: ['Plaj', 'Ada Turu', 'Tekne', 'Taverna'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Hırvatistan Sahilleri',
          description:
              'Split ve Dubrovnik rotası. Tarihi şehirler ve mavi yolculuk.',
          imageUrl: 'https://images.unsplash.com/photo-1555990538-17392d5e576a',
          activities: ['Plaj', 'Şehir Turu', 'Yat', 'Dalış'],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'İtalyan Rivierası',
          description: 'Cinque Terre köyleri. Renkli evler ve gizli koylar.',
          imageUrl:
              'https://images.unsplash.com/photo-1498503182468-3b51cbb6cb24',
          activities: ['Plaj', 'Köy Turu', 'Trekking', 'Gastronomi'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 7. Plaj - Lüks + Hafta Sonu
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'lüks' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'D-Maris Bay',
          description:
              'Datça\'nın lüks resort oteli. Özel plajlar ve gurme restoranlar.',
          imageUrl:
              'https://images.unsplash.com/photo-1582719508461-905c673771fd',
          activities: ['Özel Plaj', 'Spa', 'Su Sporları', 'Fine Dining'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Six Senses Kaplankaya',
          description:
              'Bodrum\'un ultra lüks oteli. Wellness ve detoks programları.',
          imageUrl:
              'https://images.unsplash.com/photo-1571896349842-33c89424de2d',
          activities: ['Plaj', 'Wellness', 'Yoga', 'Spa'],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'AMANRUYA',
          description: 'Özel villalı butik otel. Kişiselleştirilmiş hizmetler.',
          imageUrl:
              'https://images.unsplash.com/photo-1540541338287-41700207dee6',
          activities: ['Özel Plaj', 'Butler', 'Yoga', 'Tekne Turu'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 8. Plaj - Lüks + 1 Hafta
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'lüks' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Maldivler',
          description:
              'Su üstü villalarda lüks tatil. Özel butler ve şef hizmeti.',
          imageUrl:
              'https://images.unsplash.com/photo-1514282401047-d79a71a590e8',
          activities: ['Özel Plaj', 'Dalış', 'Spa', 'Gurme Restoran'],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'Four Seasons Bora Bora',
          description:
              'Fransız Polinezyası\'nın incisi. Mercan resiflerinde dalış.',
          imageUrl:
              'https://images.unsplash.com/photo-1500375592092-40eb2168fd21',
          activities: ['Su Villaları', 'Dalış', 'Spa', 'Romantik Akşam Yemeği'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'One&Only Reethi Rah',
          description: 'Hint Okyanusu\'nun lüks adası. Özel plaj ve villa.',
          imageUrl:
              'https://images.unsplash.com/photo-1439066615861-d1af74d74000',
          activities: ['Özel Plaj', 'Su Sporları', 'Spa', 'Yoga'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 9. Plaj - Lüks + 2 Hafta ve Üzeri
    else if (activity == 'plaj aktiviteleri' &&
        budget == 'lüks' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Karayipler Yat Turu',
          description: 'Özel yatla ada ada gezinti. Kişisel mürettebat.',
          imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5',
          activities: ['Yat Turu', 'Dalış', 'Ada Keşfi', 'Su Sporları'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Seyşeller Adaları',
          description:
              'Özel ada deneyimi. Helikopter transferli lüks konaklama.',
          imageUrl: 'https://images.unsplash.com/photo-1553603227-2358aabe821f',
          activities: ['Özel Ada', 'Dalış', 'Spa', 'Helikopter Turu'],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'Fiji Adaları',
          description: 'Güney Pasifik\'in cennet adaları. Ultra lüks resort.',
          imageUrl:
              'https://images.unsplash.com/photo-1506929562872-bb421503ef21',
          activities: ['Özel Plaj', 'Dalış', 'Spa', 'Yerel Kültür'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // KÜLTÜR GEZİLERİ KOMBİNASYONLARI

    // 1. Kültür - Ekonomik + Hafta Sonu
    else if (activity == 'kültür gezileri' &&
        budget == 'ekonomik' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Safranbolu',
          description:
              'UNESCO mirası Osmanlı evleri. Yerel pansiyonlarda konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200',
          activities: [
            'Tarihi Evler',
            'Çarşı',
            'Yerel Mutfak',
            'Fotoğrafçılık'
          ],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Assos Antik Kenti',
          description: 'Antik liman kenti. Ekonomik pansiyon ve kamp alanları.',
          imageUrl: 'https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b',
          activities: ['Antik Kent', 'Deniz', 'Tarih', 'Gün Batımı'],
          season: selectedSeason,
          rating: 4.5,
        ),
        TravelDestination(
          name: 'Amasya',
          description:
              'Pontus kaya mezarları. Yalıboyu evleri ve yerel lezzetler.',
          imageUrl:
              'https://images.unsplash.com/photo-1541432901042-2d8bd64b4a9b',
          activities: [
            'Kaya Mezarları',
            'Şehzadeler Müzesi',
            'Yerel Mutfak',
            'Fotoğraf'
          ],
          season: selectedSeason,
          rating: 4.4,
        ),
      ];
    }

    // 2. Kültür - Ekonomik + 1 Hafta
    else if (activity == 'kültür gezileri' &&
        budget == 'ekonomik' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Kapadokya Turu',
          description:
              'Peri bacaları ve yeraltı şehirleri. Ekonomik butik oteller.',
          imageUrl:
              'https://images.unsplash.com/photo-1527838832700-5059252407fa',
          activities: [
            'Yeraltı Şehirleri',
            'Vadiler',
            'Kiliseler',
            'Balon İzleme'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Mardin',
          description: 'Taş evler ve manastırlar. Yerel aile pansiyonları.',
          imageUrl:
              'https://images.unsplash.com/photo-1596306499317-8490982711b0',
          activities: [
            'Tarihi Yapılar',
            'Yerel Mutfak',
            'El Sanatları',
            'Fotoğraf'
          ],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Antik Likya Yolu',
          description: 'Antik kentler rotası. Pansiyon ve kamp konaklamalı.',
          imageUrl:
              'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200',
          activities: ['Antik Kentler', 'Yürüyüş', 'Deniz', 'Tarih'],
          season: selectedSeason,
          rating: 4.6,
        ),
      ];
    }

    // 3. Kültür - Ekonomik + 2 Hafta ve Üzeri
    else if (activity == 'kültür gezileri' &&
        budget == 'ekonomik' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Balkan Turu',
          description: 'Otobüsle 6 ülke. Hostel ve ekonomik otel konaklamalı.',
          imageUrl: 'https://images.unsplash.com/photo-1555990538-17392d5e576a',
          activities: ['Şehir Turları', 'Müzeler', 'Yerel Mutfak', 'Tarih'],
          season: selectedSeason,
          rating: 4.5,
        ),
        TravelDestination(
          name: 'Gürcistan - Ermenistan',
          description: 'Kafkasya kültür turu. Yerel aile yanı konaklamalı.',
          imageUrl:
              'https://images.unsplash.com/photo-1565708097881-bbf4ecf47cc1',
          activities: [
            'Manastırlar',
            'Şarap Tadımı',
            'Dağ Köyleri',
            'Gastronomi'
          ],
          season: selectedSeason,
          rating: 4.4,
        ),
        TravelDestination(
          name: 'İran Turu',
          description: 'Antik Pers rotası. Geleneksel misafirhane konaklamalı.',
          imageUrl:
              'https://images.unsplash.com/photo-1570168007204-dfb528c6958f',
          activities: ['Antik Kentler', 'Çarşılar', 'Mimari', 'Yerel Yaşam'],
          season: selectedSeason,
          rating: 4.6,
        ),
      ];
    }

    // 4. Kültür - Orta + Hafta Sonu
    else if (activity == 'kültür gezileri' &&
        budget == 'orta' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Efes Antik Kenti',
          description:
              'Dünya mirası antik kent. Butik otel konaklamalı kültür turu.',
          imageUrl:
              'https://images.unsplash.com/photo-1564594026330-6256b4e7e25e',
          activities: [
            'Antik Kent',
            'Arkeoloji Müzesi',
            'Şarap Tadımı',
            'Rehberli Tur'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Kapadokya Premium',
          description:
              'Butik mağara otelde konaklama. Özel rehberli kültür turları.',
          imageUrl:
              'https://images.unsplash.com/photo-1641128324972-af3212f0f6bd',
          activities: [
            'Yeraltı Şehirleri',
            'Balon Turu',
            'Şarap Tadımı',
            'Seramik Atölyesi'
          ],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Gaziantep Lezzet Turu',
          description:
              'Gastronomi şehrinde butik otel. Yerel mutfak workshop\'ları.',
          imageUrl:
              'https://images.unsplash.com/photo-1588683209069-7a61c247d248',
          activities: [
            'Mutfak Müzesi',
            'Yemek Atölyesi',
            'Çarşı Turu',
            'Zeugma Müzesi'
          ],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 5. Kültür - Orta + 1 Hafta
    else if (activity == 'kültür gezileri' &&
        budget == 'orta' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'İstanbul Tarihi Yarımada',
          description:
              'Butik otelde konaklama. Özel rehberli Bizans ve Osmanlı turu.',
          imageUrl:
              'https://images.unsplash.com/photo-1541432901042-2d8bd64b4a9b',
          activities: [
            'Ayasofya',
            'Topkapı Sarayı',
            'Kapalıçarşı',
            'Boğaz Turu'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Göbeklitepe & Urfa',
          description:
              'Tarihin sıfır noktası. Konforlu otel ve yerel gastronomi deneyimi.',
          imageUrl:
              'https://images.unsplash.com/photo-1589405858862-2ac9cbb41321',
          activities: [
            'Arkeoloji',
            'Mutfak Kültürü',
            'Tarihi Mekanlar',
            'Müzeler'
          ],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Hatay Kültür Turu',
          description:
              'Medeniyetler şehrinde butik otel. Antik kent ve gastronomi turu.',
          imageUrl:
              'https://images.unsplash.com/photo-1584646098378-0874589d76b1',
          activities: [
            'Antik Kentler',
            'Mozaik Müzesi',
            'Gastronomi',
            'El Sanatları'
          ],
          season: selectedSeason,
          rating: 4.6,
        ),
      ];
    }

    // 6. Kültür - Orta + 2 Hafta ve Üzeri
    else if (activity == 'kültür gezileri' &&
        budget == 'orta' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'İtalya Kültür Turu',
          description:
              'Roma, Floransa, Venedik rotası. Butik otellerde konaklama.',
          imageUrl: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5',
          activities: [
            'Tarihi Merkezler',
            'Müzeler',
            'Sanat Galerileri',
            'Gastronomi'
          ],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'İspanya Turu',
          description:
              'Madrid, Barselona, Granada rotası. Flamenko ve tapas deneyimi.',
          imageUrl:
              'https://images.unsplash.com/photo-1539037116277-4db20889f2d4',
          activities: ['Mimari', 'Müzeler', 'Dans Gösterileri', 'Yerel Mutfak'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Portekiz Keşfi',
          description:
              'Porto\'dan Lizbon\'a kültür rotası. Fado müziği ve şarap tadımı.',
          imageUrl: 'https://images.unsplash.com/photo-1555881400-74d7acaacd8b',
          activities: ['Tarihi Merkezler', 'Şarap Tadımı', 'Müzik', 'Okyanus'],
          season: selectedSeason,
          rating: 4.7,
        ),
      ];
    }

    // 7. Kültür - Lüks + Hafta Sonu
    else if (activity == 'kültür gezileri' &&
        budget == 'lüks' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Four Seasons Sultanahmet',
          description:
              'Tarihi yarımadada lüks konaklama. Özel rehberli saray turları.',
          imageUrl:
              'https://images.unsplash.com/photo-1578912996078-30c6acc8967f',
          activities: [
            'Özel Saray Turu',
            'Gurme Restoran',
            'Hamam Ritüeli',
            'Boğaz Yatı'
          ],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Museum Hotel Kapadokya',
          description:
              'Tarihi mağara otelde lüks deneyim. Özel şef ve balon turu.',
          imageUrl:
              'https://images.unsplash.com/photo-1570214476695-19bd467e6f7a',
          activities: ['Özel Balon Turu', 'Şef Masası', 'Şarap Mahzeni', 'Spa'],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'Alavya Alaçatı',
          description:
              'Butik taş evlerde lüks hizmet. Özel gastronomi deneyimleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1582719508461-905c673771fd',
          activities: [
            'Gurme Restoran',
            'Şarap Tadımı',
            'Sanat Galerileri',
            'Yoga'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
      ];
    }

    // 8. Kültür - Lüks + 1 Hafta
    else if (activity == 'kültür gezileri' &&
        budget == 'lüks' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Paris Kültür Turu',
          description:
              'Ritz Paris\'te konaklama. VIP müze turları ve Michelin restoranlar.',
          imageUrl: 'https://images.unsplash.com/photo-1543349689-9a4d426bee8e',
          activities: [
            'Özel Müze Turu',
            'Michelin Restoranlar',
            'Opera',
            'Alışveriş'
          ],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Viyana Sanat Turu',
          description:
              'Imperial Hotel\'de konaklama. Özel klasik müzik konserleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1516550893923-42d28e5677af',
          activities: [
            'Opera',
            'Saray Turları',
            'Klasik Müzik',
            'Cafe Kültürü'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Floransa Sanat',
          description:
              'Portrait Firenze\'de konaklama. Özel galeri ve atölye ziyaretleri.',
          imageUrl: 'https://images.unsplash.com/photo-1543429833-22db2e66a091',
          activities: [
            'Özel Galeri',
            'Sanat Atölyeleri',
            'Gurme Tur',
            'Şarap Tadımı'
          ],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 9. Kültür - Lüks + 2 Hafta ve Üzeri
    else if (activity == 'kültür gezileri' &&
        budget == 'lüks' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Japonya Lüks Turu',
          description:
              'Aman Tokyo ve Ritz Kyoto. Özel çay seremonisi ve samuray dersleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1528360983277-13d401cdc186',
          activities: [
            'Çay Seremonisi',
            'Samuray Dersi',
            'Zen Bahçeleri',
            'Kaiseki'
          ],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'Hindistan Saray Turu',
          description:
              'Taj otellerde konaklama. Özel fil safarisi ve saray ziyaretleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1524492412937-b28074a5d7da',
          activities: ['Saray Turları', 'Fil Safarisi', 'Yoga', 'Ayurveda'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Mısır Nil Cruise',
          description:
              'Özel yatla Nil seyahati. VIP piramit ve tapınak ziyaretleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1539768942893-daf53e448371',
          activities: [
            'Nil Cruise',
            'Piramit Turu',
            'Arkeoloji',
            'Çöl Safarisi'
          ],
          season: selectedSeason,
          rating: 4.8,
        ),
      ];
    }

    // MACERA SPORLARI KOMBİNASYONLARI

    // 1. Macera - Ekonomik + Hafta Sonu
    else if (activity == 'macera sporları' &&
        budget == 'ekonomik' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Kamp Alanı - Kazdağları',
          description:
              'Doğayla iç içe kamp deneyimi. Yürüyüş ve doğa aktiviteleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Kamp', 'Doğa Yürüyüşü', 'Yüzme', 'Balık Tutma'],
          season: selectedSeason,
          rating: 4.5,
        ),
        TravelDestination(
          name: 'Rafting - Fırtına Deresi',
          description:
              'Karadeniz\'de rafting heyecanı. Ekonomik konaklama seçenekleri.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Rafting', 'Kamp', 'Doğa Yürüyüşü', 'Yüzme'],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Yamaç Paraşütü - Ölüdeniz',
          description:
              'Dünyaca ünlü yamaç paraşütü merkezi. Ekonomik konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1528127269322-539801943592',
          activities: ['Yamaç Paraşütü', 'Kamp', 'Deniz', 'Dalış'],
          season: selectedSeason,
          rating: 4.8,
        ),
      ];
    }

    // 2. Macera - Ekonomik + 1 Hafta
    else if (activity == 'macera sporları' &&
        budget == 'ekonomik' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Kamp ve Trekking - Kaçkar Dağları',
          description:
              'Rize\'nin eşsiz doğası. Profesyonel rehberli trekking turları.',
          imageUrl:
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b',
          activities: ['Trekking', 'Kamp', 'Doğa Yürüyüşü', 'Fotoğrafçılık'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Kanyon Geçişi - Saklıkent',
          description:
              'Benzersiz kanyon deneyimi. Ekonomik konaklama ve rehberli turlar.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Kanyon Yürüyüşü', 'Kamp', 'Doğa Fotoğrafçılığı'],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Dalış - Kaş',
          description:
              'Akdeniz\'in en güzel dalış noktaları. Ekonomik dalış okulları.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Dalış', 'Kamp', 'Deniz', 'Su Sporları'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 3. Macera - Ekonomik + 2 Hafta ve Üzeri
    else if (activity == 'macera sporları' &&
        budget == 'ekonomik' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Balkan Dağları Turu',
          description:
              'Balkanlar\'da trekking ve dağcılık. Ekonomik konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Trekking', 'Dağcılık', 'Kamp', 'Doğa Gözlemi'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Alpler Kayak Turu',
          description: 'Fransa ve İtalya Alpleri. Ekonomik kayak okulları.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Kayak', 'Kamp', 'Kış Sporları'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Sahara Çölü Turu',
          description: 'Çöl safarisi ve kamp deneyimi. Ekonomik konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Çöl Safari', 'Kamp', 'Yıldız Gözlemi'],
          season: selectedSeason,
          rating: 4.7,
        ),
      ];
    }

    // 4. Macera - Orta + Hafta Sonu
    else if (activity == 'macera sporları' &&
        budget == 'orta' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'Kamp ve Rafting - Fırtına Deresi',
          description:
              'Karadeniz\'de rafting ve kamp deneyimi. Orta bütçeli konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Rafting', 'Kamp', 'Doğa Yürüyüşü'],
          season: selectedSeason,
          rating: 4.6,
        ),
        TravelDestination(
          name: 'Yamaç Paraşütü - Babadağ',
          description: 'Fethiye\'de yamaç paraşütü. Orta bütçeli konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1528127269322-539801943592',
          activities: ['Yamaç Paraşütü', 'Kamp', 'Deniz'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Kamp ve Trekking - Kazdağları',
          description: 'Doğayla iç içe kamp deneyimi. Orta bütçeli konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Kamp', 'Doğa Yürüyüşü', 'Yüzme'],
          season: selectedSeason,
          rating: 4.5,
        ),
      ];
    }

    // 5. Macera - Orta + 1 Hafta
    else if (activity == 'macera sporları' &&
        budget == 'orta' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Kamp ve Trekking - Kaçkar Dağları',
          description:
              'Rize\'nin eşsiz doğası. Profesyonel rehberli trekking turları.',
          imageUrl:
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b',
          activities: ['Trekking', 'Kamp', 'Doğa Yürüyüşü', 'Fotoğrafçılık'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Kanyon Geçişi - Saklıkent',
          description:
              'Benzersiz kanyon deneyimi. Orta bütçeli konaklama ve rehberli turlar.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Kanyon Yürüyüşü', 'Kamp', 'Doğa Fotoğrafçılığı'],
          season: selectedSeason,
          rating: 4.7,
        ),
        TravelDestination(
          name: 'Dalış - Kaş',
          description:
              'Akdeniz\'in en güzel dalış noktaları. Orta bütçeli dalış okulları.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Dalış', 'Kamp', 'Deniz', 'Su Sporları'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 6. Macera - Orta + 2 Hafta ve Üzeri
    else if (activity == 'macera sporları' &&
        budget == 'orta' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Balkan Dağları Turu',
          description:
              'Balkanlar\'da trekking ve dağcılık. Orta bütçeli konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Trekking', 'Dağcılık', 'Kamp', 'Doğa Gözlemi'],
          season: selectedSeason,
          rating: 4.8,
        ),
        TravelDestination(
          name: 'Alpler Kayak Turu',
          description: 'Fransa ve İtalya Alpleri. Orta bütçeli kayak okulları.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Kayak', 'Kamp', 'Kış Sporları'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Sahara Çölü Turu',
          description: 'Çöl safarisi ve kamp deneyimi. Orta bütçeli konaklama.',
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          activities: ['Çöl Safari', 'Kamp', 'Yıldız Gözlemi'],
          season: selectedSeason,
          rating: 4.7,
        ),
      ];
    }

    // 7. Macera - Lüks + Hafta Sonu
    else if (activity == 'macera sporları' &&
        budget == 'lüks' &&
        duration == 'hafta sonu') {
      _recommendations = [
        TravelDestination(
          name: 'D-Maris Bay',
          description:
              'Datça\'nın lüks resort oteli. Özel plajlar ve gurme restoranlar.',
          imageUrl:
              'https://images.unsplash.com/photo-1582719508461-905c673771fd',
          activities: ['Özel Plaj', 'Spa', 'Su Sporları', 'Fine Dining'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Six Senses Kaplankaya',
          description:
              'Bodrum\'un ultra lüks oteli. Wellness ve detoks programları.',
          imageUrl:
              'https://images.unsplash.com/photo-1571896349842-33c89424de2d',
          activities: ['Plaj', 'Wellness', 'Yoga', 'Spa'],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'AMANRUYA',
          description: 'Özel villalı butik otel. Kişiselleştirilmiş hizmetler.',
          imageUrl:
              'https://images.unsplash.com/photo-1540541338287-41700207dee6',
          activities: ['Özel Plaj', 'Butler', 'Yoga', 'Tekne Turu'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 8. Macera - Lüks + 1 Hafta
    else if (activity == 'macera sporları' &&
        budget == 'lüks' &&
        duration == '1 hafta') {
      _recommendations = [
        TravelDestination(
          name: 'Maldivler',
          description:
              'Su üstü villalarda lüks tatil. Özel butler ve şef hizmeti.',
          imageUrl:
              'https://images.unsplash.com/photo-1514282401047-d79a71a590e8',
          activities: ['Özel Plaj', 'Dalış', 'Spa', 'Gurme Restoran'],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'Four Seasons Bora Bora',
          description:
              'Fransız Polinezyası\'nın incisi. Mercan resiflerinde dalış.',
          imageUrl:
              'https://images.unsplash.com/photo-1500375592092-40eb2168fd21',
          activities: ['Su Villaları', 'Dalış', 'Spa', 'Romantik Akşam Yemeği'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'One&Only Reethi Rah',
          description: 'Hint Okyanusu\'nun lüks adası. Özel plaj ve villa.',
          imageUrl:
              'https://images.unsplash.com/photo-1439066615861-d1af74d74000',
          activities: ['Özel Plaj', 'Su Sporları', 'Spa', 'Yoga'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // 9. Macera - Lüks + 2 Hafta ve Üzeri
    else if (activity == 'macera sporları' &&
        budget == 'lüks' &&
        duration == '2 hafta ve üzeri') {
      _recommendations = [
        TravelDestination(
          name: 'Karayipler Yat Turu',
          description: 'Özel yatla ada ada gezinti. Kişisel mürettebat.',
          imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5',
          activities: ['Yat Turu', 'Dalış', 'Ada Keşfi', 'Su Sporları'],
          season: selectedSeason,
          rating: 4.9,
        ),
        TravelDestination(
          name: 'Seyşeller Adaları',
          description:
              'Özel ada deneyimi. Helikopter transferli lüks konaklama.',
          imageUrl: 'https://images.unsplash.com/photo-1553603227-2358aabe821f',
          activities: ['Özel Ada', 'Dalış', 'Spa', 'Helikopter Turu'],
          season: selectedSeason,
          rating: 5.0,
        ),
        TravelDestination(
          name: 'Fiji Adaları',
          description: 'Güney Pasifik\'in cennet adaları. Ultra lüks resort.',
          imageUrl:
              'https://images.unsplash.com/photo-1506929562872-bb421503ef21',
          activities: ['Özel Plaj', 'Dalış', 'Spa', 'Yerel Kültür'],
          season: selectedSeason,
          rating: 4.9,
        ),
      ];
    }

    // Tüm kombinasyonlar tamamlandı.
  }

  void resetPreferences() {
    _userAnswers = {};
    _recommendations = [];
    _surveyCompleted = false;
    _currentQuestionIndex = 0;
    _welcomeScreenCompleted = true;
    _userName = '';
    _userSurname = '';
    _userPhoneNumber = null;
    _userBirthDate = null;
    _userEmail = '';
    _profileImagePath = null;
    _userProfile = UserProfile(name: 'Gezgin', email: '');
    notifyListeners();
  }

  void updateUserProfile(String name, String surname, String? phoneNumber,
      String? birthDate, String email) {
    _userName = name;
    _userSurname = surname;
    _userPhoneNumber = phoneNumber;
    _userBirthDate = birthDate;
    _userEmail = email;
    _userProfile = UserProfile(name: name, email: email);
    notifyListeners();
  }

  void setUserName(String name) {
    _userAnswers['name'] = name;
    notifyListeners();
  }

  void updateProfileImage(String path) {
    _profileImagePath = path;
    notifyListeners();
  }
}
