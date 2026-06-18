import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models.dart';
import '../../data/mock_data.dart';
import '../../data/providers.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import '../booking/booking_screen.dart';
import '../messages/conversation_screen.dart';

class ListingDetailScreen extends ConsumerWidget {
  final String listingId;
  const ListingDetailScreen({super.key, required this.listingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = Mock.byId(listingId);
    final selected = ref.watch(selectedSessionProvider(listingId));
    final saved = ref.watch(savedProvider).contains(l.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.pro, style: HearthTheme.display(18)),
        actions: [
          IconButton(
            onPressed: () => ref.read(savedProvider.notifier).update((s) {
              final n = Set<String>.from(s);
              saved ? n.remove(l.id) : n.add(l.id);
              return n;
            }),
            icon: Icon(saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? HC.terracotta : HC.ink),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: HeroSwatch(accent: l.accent, icon: l.category.icon, height: 180),
            ),
            const SizedBox(height: 16),
            Text('${l.category.label} - ${l.title.split(' & ').first}',
                style: HearthTheme.body(13, w: FontWeight.w600, color: HC.terracotta)),
            const SizedBox(height: 6),
            Text(l.title, style: HearthTheme.display(26, w: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              RatingChip(l.rating, trailing: '${l.reviewCount} reviews'),
              const SizedBox(width: 8),
              Expanded(
                child: Text('- ${l.area}',
                    style: HearthTheme.body(13, color: HC.muted),
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: [
              const VerifiedPill(label: 'ID verified'),
              if (l.backgroundChecked)
                const VerifiedPill(
                    label: 'Background check',
                    icon: Icons.shield_outlined,
                    color: HC.forest),
              VerifiedPill(
                  label: '${l.yearsExp} yrs experience',
                  icon: Icons.workspace_premium_outlined,
                  color: HC.gold),
            ]),
            const SizedBox(height: 18),
            _StatStrip(l: l),
            const SizedBox(height: 22),
            Text('About ${l.pro.split(' ').first}', style: HearthTheme.display(19)),
            const SizedBox(height: 8),
            Text(l.about, style: HearthTheme.body(14.5, color: HC.inkSoft, h: 1.5)),
            const SizedBox(height: 22),
            Text("What's included", style: HearthTheme.display(19)),
            const SizedBox(height: 10),
            ...l.included.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    const Icon(Icons.check_circle_outline, size: 18, color: HC.sage),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s, style: HearthTheme.body(14.5))),
                  ]),
                )),
            const SizedBox(height: 22),
            Text('Choose your session', style: HearthTheme.display(19)),
            const SizedBox(height: 12),
            ...l.sessions.map((s) => _SessionTile(
                  option: s,
                  selected: selected.id == s.id,
                  price: formatPrice(ref, s.priceUsd),
                  onTap: () =>
                      ref.read(selectedSessionProvider(listingId).notifier).state = s,
                )),
            const SizedBox(height: 22),
            Text('Reviews', style: HearthTheme.display(19)),
            const SizedBox(height: 12),
            ...l.reviews.map((r) => _ReviewTile(r)),
            const SizedBox(height: 8),
            Row(children: [
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ConversationScreen(pro: l.pro, initials: l.initials))),
                icon: const Icon(Icons.chat_bubble_outline, color: HC.ink),
                style: IconButton.styleFrom(
                  backgroundColor: HC.surfaceWarm,
                  padding: const EdgeInsets.all(15),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HearthButton(
                    'Check availability - ${formatPrice(ref, selected.priceUsd)}',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BookingScreen(listingId: l.id)))),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _StatStrip extends StatelessWidget {
  final Listing l;
  const _StatStrip({required this.l});
  @override
  Widget build(BuildContext context) {
    Widget cell(String value, String label) => Expanded(
          child: Column(children: [
            Text(value, style: HearthTheme.display(20, color: HC.ink)),
            const SizedBox(height: 2),
            Text(label, style: HearthTheme.body(12, color: HC.muted)),
          ]),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: HC.surfaceWarm,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [
        cell(l.rating.toStringAsFixed(2), 'Rating'),
        _div(),
        cell('${(l.sessionsDone / 1000).toStringAsFixed(1)}k', 'Sessions'),
        _div(),
        cell('~1h', 'Replies'),
      ]),
    );
  }

  Widget _div() => Container(width: 1, height: 34, color: HC.hairline);
}

class _SessionTile extends StatelessWidget {
  final SessionOption option;
  final bool selected;
  final String price;
  final VoidCallback onTap;
  const _SessionTile(
      {required this.option,
      required this.selected,
      required this.price,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: selected ? HC.terracotta.withValues(alpha: 0.08) : HC.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: selected ? HC.terracotta : HC.hairline,
                width: selected ? 1.6 : 1),
          ),
          child: Row(children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? HC.terracotta : HC.mutedLight, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${option.minutes} min - ${option.name}',
                    style: HearthTheme.body(15, w: FontWeight.w700)),
                if (option.note != null)
                  Text(option.note!, style: HearthTheme.body(12.5, color: HC.muted)),
              ]),
            ),
            Text(price, style: HearthTheme.display(18)),
          ]),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review r;
  const _ReviewTile(this.r);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SoftCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Monogram(r.author.split(' ').map((w) => w[0]).take(2).join(),
                size: 36, color: HC.sage),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.author, style: HearthTheme.body(14, w: FontWeight.w700)),
                Text(r.role, style: HearthTheme.body(12, color: HC.muted)),
              ]),
            ),
            Row(
                children: List.generate(
                    r.stars,
                    (_) => const Icon(Icons.star_rounded, size: 15, color: HC.gold))),
          ]),
          const SizedBox(height: 10),
          Text(r.text, style: HearthTheme.body(13.5, color: HC.inkSoft, h: 1.45)),
        ]),
      ),
    );
  }
}
