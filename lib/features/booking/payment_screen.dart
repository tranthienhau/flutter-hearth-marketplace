import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_data.dart';
import '../../data/providers.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';

const _serviceFeeUsd = 7.0;

/// Confirm & pay: price breakdown + simulated Face ID payment + confirmation.
class PaymentScreen extends ConsumerWidget {
  final String listingId;
  const PaymentScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = Mock.byId(listingId);
    final session = ref.watch(selectedSessionProvider(listingId));
    final draft = ref.watch(bookingDraftProvider);
    final total = session.priceUsd + _serviceFeeUsd;

    return Scaffold(
      appBar: AppBar(title: Text('Confirm & pay', style: HearthTheme.display(18))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            SoftCard(
              child: Row(children: [
                Monogram(l.initials, color: l.accent, size: 50),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.pro, style: HearthTheme.body(15.5, w: FontWeight.w700)),
                    Text('${l.title.split(' & ').first} - ${session.minutes} min',
                        style: HearthTheme.body(13, color: HC.muted)),
                    const SizedBox(height: 4),
                    Text('Thu, June 18 - ${draft.slot}',
                        style: HearthTheme.body(13, w: FontWeight.w600, color: HC.terracotta)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 18, color: HC.muted),
              const SizedBox(width: 8),
              Text(draft.atMyPlace ? 'At my place - 24 Elsie St' : "${l.pro.split(' ').first}'s studio",
                  style: HearthTheme.body(13.5, color: HC.inkSoft)),
            ]),
            const SizedBox(height: 22),
            Text('Price details', style: HearthTheme.display(18)),
            const SizedBox(height: 12),
            _Line('${session.minutes} min session', formatPrice(ref, session.priceUsd, withDecimals: true)),
            _Line('Service fee', formatPrice(ref, _serviceFeeUsd, withDecimals: true)),
            _Line('Travel to you', 'Free', muted: true),
            const Divider(height: 28, color: HC.hairline),
            _Line('Total', formatPrice(ref, total, withDecimals: true), bold: true),
            const SizedBox(height: 22),
            Text('Payment', style: HearthTheme.display(18)),
            const SizedBox(height: 12),
            SoftCard(
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: HC.surfaceWarm, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.credit_card, color: HC.inkSoft, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Mastercard ···· 4242', style: HearthTheme.body(14.5, w: FontWeight.w700)),
                    Text('Default', style: HearthTheme.body(12.5, color: HC.muted)),
                  ]),
                ),
                Text('Change',
                    style: HearthTheme.body(13.5, w: FontWeight.w600, color: HC.terracotta)),
              ]),
            ),
            const SizedBox(height: 14),
            Row(children: [
              const Icon(Icons.lock_outline, size: 15, color: HC.sage),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Payment is held securely and released to the pro after your session.',
                    style: HearthTheme.body(12.5, color: HC.muted)),
              ),
            ]),
            const SizedBox(height: 18),
            HearthButton('Pay ${formatPrice(ref, total)} with Face ID',
                icon: Icons.face, onTap: () => _confirm(context, ref, l.pro, draft.slot)),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context, WidgetRef ref, String pro, String slot) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: HC.bg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  color: HC.sage.withValues(alpha: 0.16), shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: HC.sage, size: 38),
            ),
            const SizedBox(height: 18),
            Text('Booking confirmed', style: HearthTheme.display(24, w: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('$pro - Thu, June 18 at $slot',
                style: HearthTheme.body(14.5, color: HC.muted), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: HC.goldTint, borderRadius: BorderRadius.circular(40)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.notifications_active_outlined, size: 15, color: HC.gold),
                const SizedBox(width: 6),
                Text('Push reminder set for 1h before',
                    style: HearthTheme.body(12.5, w: FontWeight.w600, color: HC.terracottaDeep)),
              ]),
            ),
            const SizedBox(height: 22),
            HearthButton('Done', onTap: () {
              Navigator.popUntil(context, (r) => r.isFirst);
            }),
          ]),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool muted;
  const _Line(this.label, this.value, {this.bold = false, this.muted = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: bold
                ? HearthTheme.display(18)
                : HearthTheme.body(14.5, color: muted ? HC.muted : HC.inkSoft)),
        Text(value,
            style: bold
                ? HearthTheme.display(18, color: HC.terracotta)
                : HearthTheme.body(14.5,
                    w: FontWeight.w600, color: muted ? HC.sage : HC.ink)),
      ]),
    );
  }
}
