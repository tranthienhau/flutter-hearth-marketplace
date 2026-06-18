import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';

/// Bottom-sheet filter: category, price, distance, verified, instant book.
class FilterSheet {
  static void open(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: HC.bg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => const _FilterBody(),
    );
  }
}

class _FilterBody extends ConsumerWidget {
  const _FilterBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(filtersProvider);
    final results = ref.watch(searchResultsProvider).length;
    void update(SearchFilters Function(SearchFilters) fn) =>
        ref.read(filtersProvider.notifier).update(fn);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: HC.hairline, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 14),
          Row(children: [
            Text('Filters', style: HearthTheme.display(22)),
            const Spacer(),
            GestureDetector(
              onTap: () =>
                  ref.read(filtersProvider.notifier).state = const SearchFilters(),
              child: Text('Reset',
                  style: HearthTheme.body(14, w: FontWeight.w600, color: HC.terracotta)),
            ),
          ]),
          const SizedBox(height: 18),
          _Label('Category'),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final c in ServiceCategory.values)
              _Choice(
                label: c.label,
                selected: f.category == c,
                onTap: () => update((s) => s.category == c
                    ? s.copyWith(clearCategory: true)
                    : s.copyWith(category: c)),
              ),
          ]),
          const SizedBox(height: 22),
          Row(children: [
            _Label('Price per session'),
            const Spacer(),
            Text(
                f.maxPriceUsd >= 80
                    ? '${formatPrice(ref, 0)} - Any'
                    : '${formatPrice(ref, 0)} - ${formatPrice(ref, f.maxPriceUsd)}',
                style: HearthTheme.body(13.5, w: FontWeight.w600, color: HC.muted)),
          ]),
          Slider(
            value: f.maxPriceUsd.clamp(20, 80),
            min: 20,
            max: 80,
            divisions: 6,
            activeColor: HC.terracotta,
            inactiveColor: HC.hairline,
            onChanged: (v) => update((s) => s.copyWith(maxPriceUsd: v)),
          ),
          const SizedBox(height: 8),
          _Label('Distance'),
          const SizedBox(height: 10),
          Row(children: [
            for (final d in [1.0, 5.0, 25.0])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _Choice(
                    label: d >= 25 ? 'Any' : '${d.toInt()} mi',
                    selected: f.radiusMi == d,
                    onTap: () => update((s) => s.copyWith(radiusMi: d)),
                    fill: true,
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 18),
          _Toggle(
            title: 'Verified pros only',
            subtitle: 'ID-checked & background screened',
            value: f.verifiedOnly,
            onChanged: (v) => update((s) => s.copyWith(verifiedOnly: v)),
          ),
          _Toggle(
            title: 'Instant book',
            subtitle: 'No request needed',
            value: f.instantOnly,
            onChanged: (v) => update((s) => s.copyWith(instantOnly: v)),
          ),
          const SizedBox(height: 18),
          HearthButton('Show $results results', onTap: () => Navigator.pop(context)),
        ]),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: HearthTheme.body(15, w: FontWeight.w700)),
      );
}

class _Choice extends StatelessWidget {
  final String label;
  final bool selected;
  final bool fill;
  final VoidCallback onTap;
  const _Choice(
      {required this.label,
      required this.selected,
      required this.onTap,
      this.fill = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fill ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? HC.terracotta : HC.card,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: selected ? HC.terracotta : HC.hairline),
        ),
        child: Text(label,
            style: HearthTheme.body(13.5,
                w: FontWeight.w600, color: selected ? Colors.white : HC.ink)),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle(
      {required this.title,
      required this.subtitle,
      required this.value,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: HearthTheme.body(15, w: FontWeight.w600)),
            Text(subtitle, style: HearthTheme.body(12.5, color: HC.muted)),
          ]),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: HC.sage,
          inactiveTrackColor: HC.hairline,
          onChanged: onChanged,
        ),
      ]),
    );
  }
}
