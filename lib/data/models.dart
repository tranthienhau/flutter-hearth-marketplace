import 'package:flutter/material.dart';

/// Supported display currencies for the multi-currency marketplace.
class Currency {
  final String code;
  final String symbol;
  final double rate; // multiplier from base USD
  const Currency(this.code, this.symbol, this.rate);

  static const usd = Currency('USD', r'$', 1.0);
  static const eur = Currency('EUR', '€', 0.92);
  static const gbp = Currency('GBP', '£', 0.79);
  static const sgd = Currency('SGD', r'S$', 1.35);

  static const all = [usd, eur, gbp, sgd];
}

enum ServiceCategory { wellness, lessons, beauty, home, creative }

extension CategoryX on ServiceCategory {
  String get label => switch (this) {
        ServiceCategory.wellness => 'Wellness',
        ServiceCategory.lessons => 'Lessons',
        ServiceCategory.beauty => 'Beauty',
        ServiceCategory.home => 'Home',
        ServiceCategory.creative => 'Creative',
      };

  IconData get icon => switch (this) {
        ServiceCategory.wellness => Icons.spa_outlined,
        ServiceCategory.lessons => Icons.school_outlined,
        ServiceCategory.beauty => Icons.content_cut_outlined,
        ServiceCategory.home => Icons.chair_outlined,
        ServiceCategory.creative => Icons.palette_outlined,
      };
}

/// A bookable session option on a listing.
class SessionOption {
  final String id;
  final int minutes;
  final String name; // "Full body"
  final String? note; // "Most popular"
  final double priceUsd;
  const SessionOption(this.id, this.minutes, this.name, this.priceUsd, {this.note});
}

class Review {
  final String author;
  final String role;
  final int stars;
  final String text;
  const Review(this.author, this.role, this.stars, this.text);
}

/// A verified service provider / listing.
class Listing {
  final String id;
  final String pro; // "Maya Rivera"
  final String initials;
  final String title; // "Deep-tissue & sports massage"
  final ServiceCategory category;
  final String area; // "Bernal Heights - travels to you"
  final double distanceMi;
  final double rating;
  final int reviewCount;
  final int sessionsDone;
  final int yearsExp;
  final bool idVerified;
  final bool backgroundChecked;
  final bool instantBook;
  final Color accent;
  final String about;
  final List<String> included;
  final List<SessionOption> sessions;
  final List<Review> reviews;

  const Listing({
    required this.id,
    required this.pro,
    required this.initials,
    required this.title,
    required this.category,
    required this.area,
    required this.distanceMi,
    required this.rating,
    required this.reviewCount,
    required this.sessionsDone,
    required this.yearsExp,
    required this.idVerified,
    required this.backgroundChecked,
    required this.instantBook,
    required this.accent,
    required this.about,
    required this.included,
    required this.sessions,
    required this.reviews,
  });

  double get fromPriceUsd =>
      sessions.map((s) => s.priceUsd).reduce((a, b) => a < b ? a : b);
}

class ChatMessage {
  final String text;
  final bool mine;
  final bool system; // booking confirmed pill
  const ChatMessage(this.text, {this.mine = false, this.system = false});
}

/// Filter state for the search screen.
class SearchFilters {
  final ServiceCategory? category;
  final double maxPriceUsd; // 0..80 in base, 999 = any
  final double radiusMi;
  final bool verifiedOnly;
  final bool instantOnly;

  const SearchFilters({
    this.category,
    this.maxPriceUsd = 80,
    this.radiusMi = 5,
    this.verifiedOnly = false,
    this.instantOnly = false,
  });

  int get activeCount {
    var n = 0;
    if (category != null) n++;
    if (maxPriceUsd < 80) n++;
    if (radiusMi < 25) n++;
    if (verifiedOnly) n++;
    if (instantOnly) n++;
    return n;
  }

  SearchFilters copyWith({
    ServiceCategory? category,
    bool clearCategory = false,
    double? maxPriceUsd,
    double? radiusMi,
    bool? verifiedOnly,
    bool? instantOnly,
  }) =>
      SearchFilters(
        category: clearCategory ? null : (category ?? this.category),
        maxPriceUsd: maxPriceUsd ?? this.maxPriceUsd,
        radiusMi: radiusMi ?? this.radiusMi,
        verifiedOnly: verifiedOnly ?? this.verifiedOnly,
        instantOnly: instantOnly ?? this.instantOnly,
      );
}

/// An item the admin/moderation queue can act on.
class ModerationItem {
  final String id;
  final String kind; // "Listing report", "Review flagged"
  final String subject;
  final String reason;
  final String reporter;
  const ModerationItem(this.id, this.kind, this.subject, this.reason, this.reporter);
}
