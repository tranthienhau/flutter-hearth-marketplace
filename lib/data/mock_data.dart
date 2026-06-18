import '../theme/hearth_theme.dart';
import 'models.dart';

/// All marketplace content is realistic mockup data - no backend required.
class Mock {
  static const memberName = 'Jordan Avery';
  static const memberInitials = 'JA';
  static const memberEmail = 'jordan@email.com';
  static const memberSince = '2024';

  static final listings = <Listing>[
    Listing(
      id: 'maya',
      pro: 'Maya Rivera',
      initials: 'MR',
      title: 'Deep-tissue & sports massage',
      category: ServiceCategory.wellness,
      area: 'Bernal Heights - travels to you',
      distanceMi: 1.2,
      rating: 4.96,
      reviewCount: 213,
      sessionsDone: 1240,
      yearsExp: 6,
      idVerified: true,
      backgroundChecked: true,
      instantBook: true,
      accent: HC.terracotta,
      about:
          'Licensed massage therapist focused on deep-tissue and sports recovery. '
          'I bring the table, oils and fresh linens to you - all you need is a quiet corner.',
      included: [
        '60 minutes hands-on therapy',
        'Table, oils & fresh linens',
        'Free cancellation up to 24h',
      ],
      sessions: [
        SessionOption('m60', 60, 'Full body', 90, note: 'Most popular'),
        SessionOption('m90', 90, 'Deep recovery', 130, note: 'Best for athletes'),
        SessionOption('m120', 120, 'Full reset', 165),
      ],
      reviews: [
        Review('Daniel K.', 'Client', 5,
            'Maya completely loosened up my lower back. Professional and on time.'),
        Review('Priya S.', 'Client', 5,
            'Best mobile massage I have booked. Brought everything, zero fuss.'),
      ],
    ),
    Listing(
      id: 'daniel',
      pro: 'Daniel Kwon',
      initials: 'DK',
      title: 'Guitar lessons - all levels',
      category: ServiceCategory.lessons,
      area: 'Mission District - online or in person',
      distanceMi: 0.9,
      rating: 4.9,
      reviewCount: 88,
      sessionsDone: 640,
      yearsExp: 9,
      idVerified: true,
      backgroundChecked: true,
      instantBook: false,
      accent: HC.sage,
      about:
          'Berklee-trained guitarist teaching everything from first chords to gigging '
          'confidence. Lessons tailored to the songs you actually want to play.',
      included: [
        '60 minutes one-to-one coaching',
        'Personalised practice plan',
        'Recording of key parts',
      ],
      sessions: [
        SessionOption('d45', 45, 'Single lesson', 45, note: 'Most booked'),
        SessionOption('d60', 60, 'Deep dive', 60),
      ],
      reviews: [
        Review('Aria L.', 'Client', 5,
            'Always prepared and respectful of time. Great energy in every lesson.'),
      ],
    ),
    Listing(
      id: 'priya',
      pro: 'Priya Sharma',
      initials: 'PS',
      title: 'Hair & colour studio',
      category: ServiceCategory.beauty,
      area: 'Hayes Valley studio',
      distanceMi: 2.1,
      rating: 5.0,
      reviewCount: 156,
      sessionsDone: 980,
      yearsExp: 8,
      idVerified: true,
      backgroundChecked: true,
      instantBook: true,
      accent: HC.gold,
      about:
          'Balayage and colour specialist. Quiet, unhurried studio sessions with a '
          'tailored toner and a finish that grows out beautifully.',
      included: [
        'Consultation & colour map',
        'Cut, colour & gloss',
        'Aftercare kit',
      ],
      sessions: [
        SessionOption('p120', 120, 'Cut & colour', 120, note: 'Most popular'),
        SessionOption('p180', 180, 'Full transformation', 210),
      ],
      reviews: [
        Review('Sofia G.', 'Client', 5, 'Exactly the colour I asked for. Studio is gorgeous.'),
      ],
    ),
    Listing(
      id: 'aria',
      pro: 'Aria Lindqvist',
      initials: 'AL',
      title: 'Vinyasa & restorative yoga',
      category: ServiceCategory.wellness,
      area: 'Dolores Park - 0.8 mi',
      distanceMi: 0.8,
      rating: 4.95,
      reviewCount: 102,
      sessionsDone: 720,
      yearsExp: 7,
      idVerified: true,
      backgroundChecked: true,
      instantBook: true,
      accent: HC.forest,
      about:
          'Slow, breath-led vinyasa and restorative sessions for every body. '
          'Mats and props provided - just bring yourself.',
      included: [
        '60 minutes guided practice',
        'Mat, blocks & bolster',
        'Free cancellation up to 24h',
      ],
      sessions: [
        SessionOption('a60', 60, 'Vinyasa flow', 55, note: 'Most popular'),
        SessionOption('a75', 75, 'Restorative', 70),
      ],
      reviews: [
        Review('Marcus B.', 'Client', 5, 'Calm, clear cues. Left feeling brand new.'),
      ],
    ),
    Listing(
      id: 'marcus',
      pro: 'Marcus Bell',
      initials: 'MB',
      title: 'Power yoga & mobility',
      category: ServiceCategory.wellness,
      area: 'Noe Valley - 1.4 mi',
      distanceMi: 1.4,
      rating: 4.88,
      reviewCount: 64,
      sessionsDone: 410,
      yearsExp: 5,
      idVerified: true,
      backgroundChecked: false,
      instantBook: false,
      accent: HC.terracottaDeep,
      about:
          'Strength-focused power yoga and mobility work for athletes and desk-bound '
          'bodies alike. Expect to sweat and to move better.',
      included: [
        '60 minutes guided session',
        'Mobility assessment',
        'Take-home mobility plan',
      ],
      sessions: [
        SessionOption('mb60', 60, 'Power flow', 60, note: '2 slots today'),
        SessionOption('mb90', 90, 'Mobility intensive', 85),
      ],
      reviews: [
        Review('Jordan A.', 'Client', 5, 'Tough but exactly what my hips needed.'),
      ],
    ),
    Listing(
      id: 'sofia',
      pro: 'Sofia Greco',
      initials: 'SG',
      title: 'Prenatal & gentle flow',
      category: ServiceCategory.wellness,
      area: 'Bernal Heights - 2.0 mi',
      distanceMi: 2.0,
      rating: 4.99,
      reviewCount: 47,
      sessionsDone: 320,
      yearsExp: 6,
      idVerified: true,
      backgroundChecked: true,
      instantBook: false,
      accent: HC.peach,
      about:
          'Specialised prenatal and gentle flow sessions, trimester-aware and always '
          'unrushed. A calm hour that meets you where your body is today.',
      included: [
        '60 minutes gentle practice',
        'Props & bolsters provided',
        'Trimester-aware sequencing',
      ],
      sessions: [
        SessionOption('s60', 60, 'Gentle flow', 65, note: 'Most popular'),
      ],
      reviews: [
        Review('Priya S.', 'Client', 5, 'So gentle and reassuring through my third trimester.'),
      ],
    ),
  ];

  static Listing byId(String id) => listings.firstWhere((l) => l.id == id);

  static const conversation = <ChatMessage>[
    ChatMessage('Hi Jordan! Looking forward to Thursday. Any areas you would like me to focus on?'),
    ChatMessage('Mostly lower back and shoulders - I have been at the desk a lot lately!',
        mine: true),
    ChatMessage('Got it - I will bring a heat pack too. We will get that loosened up.'),
    ChatMessage('Booking confirmed - Thu Jun 18, 11:30 AM', system: true),
    ChatMessage('Perfect, thank you! See you then.', mine: true),
  ];

  static const moderation = <ModerationItem>[
    ModerationItem('rep1', 'Listing report', 'Untitled bootcamp - Sand Hill',
        'Off-platform payment request', 'auto-flag'),
    ModerationItem('rep2', 'Review flagged', 'Review on "Power yoga & mobility"',
        'Possible spam / promo link', 'Marcus B.'),
    ModerationItem('rep3', 'ID re-check', 'Provider: T. Okafor',
        'Selfie match below threshold', 'verification'),
  ];

  static const timeSlots = ['9:00 AM', '11:30 AM', '2:00 PM', '4:00 PM', '6:30 PM'];
}
