import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_data.dart';
import '../../data/providers.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import '../listing/listing_detail_screen.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text('Your bookings', style: HearthTheme.display(26, w: FontWeight.w700)),
          const SizedBox(height: 16),
          _Tabs(),
          const SizedBox(height: 16),
          _BookingCard(
            listingId: 'maya',
            session: '60 min - Full body massage',
            when: 'Thu, June 18 - 11:30 AM',
            status: 'Confirmed',
            statusColor: HC.sage,
            paid: formatPrice(ref, 97, withDecimals: true),
          ),
          const SizedBox(height: 12),
          _BookingCard(
            listingId: 'daniel',
            session: '45 min - Guitar lesson',
            when: 'Sat, June 20 - 2:00 PM',
            status: 'Pending pro',
            statusColor: HC.gold,
            paid: formatPrice(ref, 45, withDecimals: true),
          ),
          const SizedBox(height: 12),
          _BookingCard(
            listingId: 'priya',
            session: '120 min - Cut & colour',
            when: 'Fri, May 30 - 1:00 PM',
            status: 'Completed',
            statusColor: HC.muted,
            paid: formatPrice(ref, 127, withDecimals: true),
            review: true,
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget tab(String t, bool sel) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? HC.card : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: sel ? Border.all(color: HC.hairline) : null,
            ),
            child: Text(t,
                style: HearthTheme.body(14,
                    w: FontWeight.w600, color: sel ? HC.ink : HC.muted)),
          ),
        );
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: HC.surfaceWarm, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [tab('Upcoming', true), tab('Past', false)]),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String listingId;
  final String session;
  final String when;
  final String status;
  final Color statusColor;
  final String paid;
  final bool review;
  const _BookingCard({
    required this.listingId,
    required this.session,
    required this.when,
    required this.status,
    required this.statusColor,
    required this.paid,
    this.review = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = Mock.byId(listingId);
    return SoftCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ListingDetailScreen(listingId: listingId))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Monogram(l.initials, color: l.accent, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.pro, style: HearthTheme.body(15.5, w: FontWeight.w700)),
              Text(session, style: HearthTheme.body(13, color: HC.muted)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(40)),
            child: Text(status,
                style: HearthTheme.body(12, w: FontWeight.w700, color: statusColor)),
          ),
        ]),
        const Divider(height: 24, color: HC.hairline),
        Row(children: [
          const Icon(Icons.event_outlined, size: 16, color: HC.muted),
          const SizedBox(width: 8),
          Text(when, style: HearthTheme.body(13.5, w: FontWeight.w600)),
          const Spacer(),
          Text(paid, style: HearthTheme.body(13.5, w: FontWeight.w700, color: HC.ink)),
        ]),
        if (review) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: HearthButton('Leave a review', filled: false, icon: Icons.star_outline,
                onTap: () {}),
          ),
        ],
      ]),
    );
  }
}
