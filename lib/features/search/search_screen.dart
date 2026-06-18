import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/listing_card.dart';
import 'filter_sheet.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final filters = ref.watch(filtersProvider);
    final results = ref.watch(searchResultsProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: HC.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: HC.hairline),
                ),
                child: Row(children: [
                  const Icon(Icons.search, color: HC.muted, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(query, style: HearthTheme.body(15, w: FontWeight.w600))),
                  Text('Cancel', style: HearthTheme.body(14, color: HC.terracotta)),
                ]),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(
                      label: 'Filters - ${filters.activeCount}',
                      icon: Icons.tune,
                      active: true,
                      onTap: () => FilterSheet.open(context, ref),
                    ),
                    _FilterChip(
                      label: 'Under ${formatPrice(ref, 80)}',
                      active: filters.maxPriceUsd < 80,
                      onTap: () => ref.read(filtersProvider.notifier).update(
                          (f) => f.copyWith(maxPriceUsd: f.maxPriceUsd < 80 ? 999 : 80)),
                    ),
                    _FilterChip(
                      label: 'Today',
                      active: false,
                      onTap: () {},
                    ),
                    _FilterChip(
                      label: 'Verified',
                      active: filters.verifiedOnly,
                      onTap: () => ref.read(filtersProvider.notifier).update(
                          (f) => f.copyWith(verifiedOnly: !f.verifiedOnly)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Text('${results.length} ', style: HearthTheme.display(20)),
                Text('sessions near you', style: HearthTheme.body(15, color: HC.muted)),
                const Spacer(),
                Text('Top rated',
                    style: HearthTheme.body(13.5, w: FontWeight.w600, color: HC.terracotta)),
                const Icon(Icons.expand_more, size: 18, color: HC.terracotta),
              ]),
              const SizedBox(height: 8),
            ]),
          ),
          Expanded(
            child: results.isEmpty
                ? _Empty(onReset: () =>
                    ref.read(filtersProvider.notifier).state = const SearchFilters())
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => ListingRow(results[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fg = active ? Colors.white : HC.ink;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? HC.ink : HC.card,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: active ? HC.ink : HC.hairline),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[Icon(icon, size: 15, color: fg), const SizedBox(width: 6)],
            Text(label, style: HearthTheme.body(13.5, w: FontWeight.w600, color: fg)),
          ]),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final VoidCallback onReset;
  const _Empty({required this.onReset});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.travel_explore, size: 48, color: HC.mutedLight),
          const SizedBox(height: 12),
          Text('No pros match those filters',
              style: HearthTheme.display(18), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text('Try widening your distance or price.',
              style: HearthTheme.body(14, color: HC.muted), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          SizedBox(width: 180, child: HearthButton('Reset filters', filled: false, onTap: onReset)),
        ]),
      ),
    );
  }
}
