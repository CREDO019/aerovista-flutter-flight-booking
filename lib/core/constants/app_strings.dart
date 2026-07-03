/// AeroVista app-wide string constants.
/// Centralising strings makes localisation easy in the future.
class AppStrings {
  AppStrings._();

  // ── App identity ──────────────────────────────────────────────────────────
  static const String appName = 'AeroVista';
  static const String appTagline = 'AeroVista Flight Experience';
  static const String disclaimer =
      'Hayali bir uçuş rezervasyon markası için konsept tasarımdır.';

  // ── Navigation labels ─────────────────────────────────────────────────────
  static const String home = 'Ana Sayfa';
  static const String explore = 'Keşfet';
  static const String results = 'Uygun Uçuşlar';
  static const String boardingPass = 'Biniş Kartı';
  static const String confirmation = 'Rezervasyon Onaylandı';

  // ── CTA labels ────────────────────────────────────────────────────────────
  static const String exploreDestinations = 'Rotaları Keşfet';
  static const String searchFlights = 'Uçuş Ara';
  static const String viewFlights = 'Uçuşları Gör';
  static const String viewBoardingPass = 'Biniş Kartını Gör';
  static const String confirmBooking = 'Rezervasyonu Onayla';
  static const String backToHome = 'Ana Sayfaya Dön';
  static const String back = 'Geri';

  // ── Demo login screen ─────────────────────────────────────────────────────
  static const String loginTitle = 'Yolculuğuna devam et.';
  static const String loginSubtitle =
      'Demo profilin hazır; AeroVista deneyimine kontrollü ve hızlı giriş yap.';
  static const String loginEmailLabel = 'E-posta';
  static const String loginCodeLabel = 'Rezervasyon Kodu';
  static const String loginPrimaryCta = 'Demo Giriş Yap';
  static const String loginFillDemo = 'Demo bilgilerini doldur';
  static const String loginDemoEmail = 'emirhan@aerovista.demo';
  static const String loginDemoCode = 'AV-DEMO';
  static const String loginEmailError = 'Demo e-posta adresini gir.';
  static const String loginCodeError = 'Rezervasyon kodunu gir.';
  static const String loginProfileName = 'Emirhan Özkaya';
  static const String loginProfileTier = 'AeroVista Priority';
  static const String loginStatusReady = 'Demo erişim hazır';

  // ── Home screen ────────────────────────────────────────────────────────────
  static const String homeHeroLine1 = 'Sonraki rotanı';
  static const String homeHeroLine2 = 'gökyüzünde çiz.';
  static const String homeSubtitle =
      'Uçuşunu daha akıcı, sakin ve premium bir deneyimle planla.';

  // ── Explore screen ────────────────────────────────────────────────────────
  static const String exploreTitle = 'Rotaları Keşfet';
  static const String exploreSubtitle = 'Seni nereye götürelim?';
  static const String filterAll = 'Tümü';
  static const String filterDomestic = 'Türkiye';
  static const String filterInternational = 'Yurtdışı';
  static const String filterPopular = 'Popüler';
  static const String filterWeekend = 'Hafta Sonu';

  // ── Results screen ────────────────────────────────────────────────────────
  static const String resultsTitle = 'Uygun Uçuşlar';
  static const String sortRecommended = 'Önerilen';
  static const String sortCheapest = 'En Uygun';
  static const String sortFastest = 'En Hızlı';
  static const String filterMorning = 'Sabah';
  static const String filterEvening = 'Akşam';
  static const String filterDomesticFlights = 'Yurtiçi';
  static const String filterInternationalFlights = 'Yurtdışı';
  static const String filterDirect = 'Direkt';
  static const String emptyStateTitle = 'Uçuş bulunamadı.';
  static const String emptyStateSubtitle =
      'Bu filtreye uygun uçuş bulunamadı.\nFarklı bir filtre deneyebilirsin.';

  // ── Flight badges ─────────────────────────────────────────────────────────
  static const String badgeDirect = 'Direkt';
  static const String badgeDomestic = 'Yurtiçi';
  static const String badgeInternational = 'Yurtdışı';
  static const String badgeRecommended = 'Önerilen';
  static const String badgeMorning = 'Sabah';
  static const String badgeEvening = 'Akşam';

  // ── Flight detail labels ──────────────────────────────────────────────────
  static const String cabin = 'Kabin';
  static const String duration = 'Süre';
  static const String gate = 'Kapı';
  static const String seat = 'Koltuk';
  static const String flightNumber = 'Uçuş';
  static const String price = 'Fiyat';
  static const String passenger = 'Yolcu';
  static const String departure = 'Kalkış';
  static const String arrival = 'Varış';
  static const String baggage = 'Bagaj';
  static const String bookingReference = 'Rezervasyon Kodu';
  static const String conceptTicket =
      'Konsept bilettir. Seyahat için geçerli değildir.';
  static const String conceptBoardingPass =
      'Konsept biniş kartıdır. Seyahat için geçerli değildir.';

  // ── Boarding pass ─────────────────────────────────────────────────────────
  static const String boardingPassReady = 'Yolculuğun\nhazır.';
  static const String boardingPassSubtitle = 'Uçuş detaylarını kontrol et.';
  static const String domesticFlight = 'Yurtiçi Uçuş';
  static const String internationalFlight = 'Yurtdışı Uçuş';

  // ── Confirmation screen ───────────────────────────────────────────────────
  static const String bookingConfirmed = 'Rezervasyon Onaylandı';

  // ── Onboarding screen ───────────────────────────────────────────────────────
  static const String onboardingSkip = 'Atla';
  static const String onboardingNext = 'Devam';
  static const String onboardingStart = 'Başla';
  static const String onboardingPage1Title = 'Rotanı dünyada seç.';
  static const String onboardingPage1Subtitle =
      'AeroVista ile uçuşunu küre üzerinde keşfet, rotanı sinematik bir deneyimle gör.';
  static const String onboardingPage2Title = 'Uçuşunu akıcı planla.';
  static const String onboardingPage2Subtitle =
      'Filtreler, rota kartları ve premium uçuş detayları tek akışta birleşir.';
  static const String onboardingPage3Title = 'Yolculuğun hazır.';
  static const String onboardingPage3Subtitle =
      'Dijital biniş kartı ve rezervasyon onayı sade, hızlı ve etkileyici.';

  // ── Dynamic Turkish sentence helpers ─────────────────────────────────────
  static String journeyReady(String fromCity, String toCity) {
    return '${_fromAblative(fromCity)} ${_toDative(toCity)} yolculuğun hazır.';
  }

  static String flightCount(int count) => '$count uçuş bulundu';

  static String _fromAblative(String city) {
    const map = {
      'İstanbul': 'İstanbul\'dan',
      'Istanbul': 'İstanbul\'dan',
      'Ankara': 'Ankara\'dan',
      'İzmir': 'İzmir\'den',
      'Antalya': 'Antalya\'dan',
      'Trabzon': 'Trabzon\'dan',
      'Kayseri': 'Kayseri\'den',
      'Kapadokya': 'Kapadokya\'dan',
    };
    return map[city] ?? '$city\'dan';
  }

  static String _toDative(String city) {
    const map = {
      'Paris': 'Paris\'e',
      'Tokyo': 'Tokyo\'ya',
      'New York': 'New York\'a',
      'Londra': 'Londra\'ya',
      'London': 'Londra\'ya',
      'Dubai': 'Dubai\'ye',
      'Ankara': 'Ankara\'ya',
      'İzmir': 'İzmir\'e',
      'Antalya': 'Antalya\'ya',
      'Trabzon': 'Trabzon\'a',
      'Kayseri': 'Kayseri\'ye',
      'Kapadokya': 'Kapadokya\'ya',
      'Cappadocia': 'Kapadokya\'ya',
    };
    return map[city] ?? '$city\'e';
  }
}
