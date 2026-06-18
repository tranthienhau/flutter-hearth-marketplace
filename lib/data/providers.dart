import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'mock_data.dart';

/// Selected display currency - drives multi-currency formatting app-wide.
final currencyProvider = StateProvider<Currency>((ref) => Currency.usd);

/// Format a base-USD price into the selected currency.
String formatPrice(WidgetRef ref, double usd, {bool withDecimals = false}) {
  final c = ref.watch(currencyProvider);
  final v = usd * c.rate;
  final s = withDecimals ? v.toStringAsFixed(2) : v.round().toString();
  return '${c.symbol}$s';
}

/// Live search query + filters.
final searchQueryProvider = StateProvider<String>((ref) => 'Yoga near me');
final filtersProvider = StateProvider<SearchFilters>((ref) => const SearchFilters());

/// Saved (favourite) pro ids.
final savedProvider = StateProvider<Set<String>>((ref) => {'priya'});

/// Filtered + sorted search results derived from the catalogue.
final searchResultsProvider = Provider<List<Listing>>((ref) {
  final f = ref.watch(filtersProvider);
  var items = Mock.listings.where((l) {
    if (f.category != null && l.category != f.category) return false;
    if (f.verifiedOnly && !(l.idVerified && l.backgroundChecked)) return false;
    if (f.instantOnly && !l.instantBook) return false;
    if (l.distanceMi > f.radiusMi) return false;
    if (f.maxPriceUsd < 80 && l.fromPriceUsd > f.maxPriceUsd) return false;
    return true;
  }).toList();
  items.sort((a, b) => b.rating.compareTo(a.rating));
  return items;
});

/// Currently selected session option per listing (for the booking flow).
final selectedSessionProvider =
    StateProvider.family<SessionOption, String>((ref, listingId) {
  return Mock.byId(listingId).sessions.first;
});

/// Booking draft state.
class BookingDraft {
  final String slot;
  final bool atMyPlace;
  const BookingDraft({this.slot = '11:30 AM', this.atMyPlace = true});

  BookingDraft copyWith({String? slot, bool? atMyPlace}) =>
      BookingDraft(slot: slot ?? this.slot, atMyPlace: atMyPlace ?? this.atMyPlace);
}

final bookingDraftProvider = StateProvider<BookingDraft>((ref) => const BookingDraft());

/// Moderation queue (admin) - items can be resolved.
final moderationQueueProvider =
    StateNotifierProvider<ModerationQueue, List<ModerationItem>>(
        (ref) => ModerationQueue());

class ModerationQueue extends StateNotifier<List<ModerationItem>> {
  ModerationQueue() : super(List.of(Mock.moderation));
  void resolve(String id) =>
      state = state.where((m) => m.id != id).toList();
}
