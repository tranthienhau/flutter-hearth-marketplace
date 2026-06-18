import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../data/providers.dart';
import '../theme/hearth_theme.dart';

/// Compact currency switcher - opens a sheet to change display currency.
class CurrencyButton extends ConsumerWidget {
  const CurrencyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(currencyProvider);
    return GestureDetector(
      onTap: () => _open(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: HC.surfaceWarm,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.public, size: 15, color: HC.inkSoft),
          const SizedBox(width: 6),
          Text(c.code, style: HearthTheme.body(13, w: FontWeight.w700)),
          const Icon(Icons.expand_more, size: 16, color: HC.inkSoft),
        ]),
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: HC.bg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Display currency', style: HearthTheme.display(19)),
            const SizedBox(height: 4),
            Text('Prices update across the whole app',
                style: HearthTheme.body(13, color: HC.muted)),
            const SizedBox(height: 14),
            ...Currency.all.map((cur) {
              final sel = ref.watch(currencyProvider).code == cur.code;
              return ListTile(
                onTap: () {
                  ref.read(currencyProvider.notifier).state = cur;
                  Navigator.pop(context);
                },
                leading: Text(cur.symbol,
                    style: HearthTheme.display(18, color: HC.terracotta)),
                title: Text(cur.code, style: HearthTheme.body(15, w: FontWeight.w600)),
                trailing: sel
                    ? const Icon(Icons.check_circle, color: HC.terracotta)
                    : const Icon(Icons.circle_outlined, color: HC.hairline),
              );
            }),
          ]),
        ),
      ),
    );
  }
}
