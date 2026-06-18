import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models.dart';
import '../../data/mock_data.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/currency_selector.dart';
import '../../widgets/listing_card.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = Mock.byId('maya');
    final topRated = [Mock.byId('daniel'), Mock.byId('priya'), Mock.byId('aria')];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Good morning', style: HearthTheme.body(14, color: HC.muted)),
                Text(Mock.memberName, style: HearthTheme.display(26, w: FontWeight.w700)),
              ]),
            ),
            const CurrencyButton(),
            const SizedBox(width: 10),
            const Monogram(Mock.memberInitials, color: HC.terracotta, size: 44),
          ]),
          const SizedBox(height: 18),
          const _SearchBar(),
          const SizedBox(height: 20),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ServiceCategory.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _CategoryPill(ServiceCategory.values[i]),
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader('Featured this week', action: 'See all'),
          const SizedBox(height: 12),
          FeaturedCard(featured),
          const SizedBox(height: 24),
          SectionHeader('Top rated near you', action: 'See all'),
          const SizedBox(height: 12),
          ...topRated.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListingRow(l),
              )),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: HC.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HC.hairline),
      ),
      child: Row(children: [
        const Icon(Icons.search, color: HC.muted, size: 21),
        const SizedBox(width: 10),
        Text('Find a massage, tutor, stylist...',
            style: HearthTheme.body(15, color: HC.mutedLight)),
      ]),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final ServiceCategory category;
  const _CategoryPill(this.category);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: HC.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HC.hairline),
        ),
        child: Icon(category.icon, color: HC.terracotta, size: 26),
      ),
      const SizedBox(height: 7),
      Text(category.label, style: HearthTheme.body(12.5, w: FontWeight.w600)),
    ]);
  }
}
