import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../data/providers.dart';
import '../theme/hearth_theme.dart';
import '../features/listing/listing_detail_screen.dart';
import 'common.dart';

/// Large featured card with hero, verified pill, price + Book.
class FeaturedCard extends ConsumerWidget {
  final Listing listing;
  const FeaturedCard(this.listing, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SoftCard(
      padding: EdgeInsets.zero,
      onTap: () => _openDetail(context, listing),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          HeroSwatch(
            accent: listing.accent,
            icon: listing.category.icon,
            height: 168,
            radius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          const Positioned(
              top: 12, left: 12, child: VerifiedPill(label: 'Verified pro')),
        ]),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(listing.pro, style: HearthTheme.display(18)),
              ),
              RatingChip(listing.rating),
            ]),
            const SizedBox(height: 4),
            Text('${listing.title} - ${listing.distanceMi} mi',
                style: HearthTheme.body(13.5, color: HC.muted)),
            const SizedBox(height: 14),
            Row(children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: formatPrice(ref, listing.fromPriceUsd),
                      style: HearthTheme.display(20, color: HC.ink)),
                  TextSpan(
                      text: ' / ${listing.sessions.first.minutes} min',
                      style: HearthTheme.body(13, color: HC.muted)),
                ]),
              ),
              const Spacer(),
              SizedBox(
                width: 110,
                height: 44,
                child: HearthButton('Book',
                    onTap: () => _openDetail(context, listing)),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }
}

/// Compact row used in "Top rated" lists.
class ListingRow extends ConsumerWidget {
  final Listing listing;
  const ListingRow(this.listing, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SoftCard(
      onTap: () => _openDetail(context, listing),
      child: Row(children: [
        Monogram(listing.initials, color: listing.accent, size: 52),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(listing.pro, style: HearthTheme.body(15.5, w: FontWeight.w700))),
              if (listing.idVerified) ...[
                const SizedBox(width: 6),
                const Icon(Icons.verified, size: 15, color: HC.sage),
              ],
            ]),
            const SizedBox(height: 2),
            Text(listing.title, style: HearthTheme.body(13, color: HC.muted)),
            const SizedBox(height: 6),
            Row(children: [
              RatingChip(listing.rating),
              const SizedBox(width: 10),
              Text('from ${formatPrice(ref, listing.fromPriceUsd)}',
                  style: HearthTheme.body(13, w: FontWeight.w600, color: HC.terracotta)),
              if (listing.instantBook) ...[
                const SizedBox(width: 10),
                const Icon(Icons.bolt, size: 14, color: HC.gold),
                Text(' Instant', style: HearthTheme.body(12, color: HC.gold, w: FontWeight.w600)),
              ],
            ]),
          ]),
        ),
      ]),
    );
  }
}

void _openDetail(BuildContext context, Listing l) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ListingDetailScreen(listingId: l.id)));
}
