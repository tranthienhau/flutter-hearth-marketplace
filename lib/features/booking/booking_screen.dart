import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_data.dart';
import '../../data/providers.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import 'payment_screen.dart';

/// Pick date & time + location. Calendar is a simple static June 2026 grid.
class BookingScreen extends ConsumerWidget {
  final String listingId;
  const BookingScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = Mock.byId(listingId);
    final session = ref.watch(selectedSessionProvider(listingId));
    final draft = ref.watch(bookingDraftProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Book a session', style: HearthTheme.display(18))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Row(children: [
              Monogram(l.initials, color: l.accent, size: 46),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.pro, style: HearthTheme.body(15.5, w: FontWeight.w700)),
                Text('${session.minutes} min - ${session.name}',
                    style: HearthTheme.body(13, color: HC.muted)),
              ]),
            ]),
            const SizedBox(height: 20),
            Text('June 2026', style: HearthTheme.display(18)),
            const SizedBox(height: 12),
            const _MiniCalendar(selectedDay: 18),
            const SizedBox(height: 22),
            Text('Thursday, June 18', style: HearthTheme.display(18)),
            const SizedBox(height: 12),
            Wrap(spacing: 10, runSpacing: 10, children: [
              for (final slot in Mock.timeSlots)
                _Slot(
                  label: slot,
                  selected: draft.slot == slot,
                  onTap: () => ref
                      .read(bookingDraftProvider.notifier)
                      .update((d) => d.copyWith(slot: slot)),
                ),
            ]),
            const SizedBox(height: 24),
            Text('Where', style: HearthTheme.display(18)),
            const SizedBox(height: 12),
            _Where(
              icon: Icons.home_outlined,
              title: 'At my place',
              subtitle: '24 Elsie St',
              selected: draft.atMyPlace,
              onTap: () => ref
                  .read(bookingDraftProvider.notifier)
                  .update((d) => d.copyWith(atMyPlace: true)),
            ),
            const SizedBox(height: 10),
            _Where(
              icon: Icons.storefront_outlined,
              title: "${l.pro.split(' ').first}'s studio",
              subtitle: l.area,
              selected: !draft.atMyPlace,
              onTap: () => ref
                  .read(bookingDraftProvider.notifier)
                  .update((d) => d.copyWith(atMyPlace: false)),
            ),
            const SizedBox(height: 24),
            HearthButton('Continue to payment',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PaymentScreen(listingId: listingId)))),
          ],
        ),
      ),
    );
  }
}

class _MiniCalendar extends StatelessWidget {
  final int selectedDay;
  const _MiniCalendar({required this.selectedDay});
  @override
  Widget build(BuildContext context) {
    const dow = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    // June 2026 starts on Monday (offset 1).
    const offset = 1;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HC.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HC.hairline),
      ),
      child: Column(children: [
        Row(
          children: dow
              .map((d) => Expanded(
                  child: Center(
                      child: Text(d,
                          style: HearthTheme.body(12, w: FontWeight.w600, color: HC.muted)))))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemCount: 30 + offset,
          itemBuilder: (_, i) {
            if (i < offset) return const SizedBox();
            final day = i - offset + 1;
            final selected = day == selectedDay;
            final past = day < 18;
            return Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: selected ? HC.terracotta : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('$day',
                    style: HearthTheme.body(13.5,
                        w: selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : past
                                ? HC.mutedLight
                                : HC.ink)),
              ),
            );
          },
        ),
      ]),
    );
  }
}

class _Slot extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Slot({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? HC.terracotta : HC.card,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: selected ? HC.terracotta : HC.hairline),
        ),
        child: Text(label,
            style: HearthTheme.body(14,
                w: FontWeight.w600, color: selected ? Colors.white : HC.ink)),
      ),
    );
  }
}

class _Where extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _Where(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.selected,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? HC.terracotta.withValues(alpha: 0.08) : HC.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? HC.terracotta : HC.hairline, width: selected ? 1.6 : 1),
        ),
        child: Row(children: [
          Icon(icon, color: selected ? HC.terracotta : HC.inkSoft, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: HearthTheme.body(15, w: FontWeight.w700)),
              Text(subtitle, style: HearthTheme.body(12.5, color: HC.muted)),
            ]),
          ),
          if (selected) const Icon(Icons.check_circle, color: HC.terracotta, size: 22),
        ]),
      ),
    );
  }
}
