import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';

/// Admin dashboard + reporting / moderation queue.
class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(moderationQueueProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Admin & moderation', style: HearthTheme.display(18))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Text('Marketplace health', style: HearthTheme.display(18)),
            const SizedBox(height: 12),
            Row(children: [
              _Kpi('1,284', 'Active pros', HC.sage, Icons.workspace_premium_outlined),
              const SizedBox(width: 12),
              _Kpi('312', 'Bookings today', HC.terracotta, Icons.event_available_outlined),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              _Kpi('98.2%', 'ID-verified', HC.forest, Icons.verified_user_outlined),
              const SizedBox(width: 12),
              _Kpi('${queue.length}', 'Open reports', HC.gold, Icons.flag_outlined),
            ]),
            const SizedBox(height: 24),
            Row(children: [
              Text('Moderation queue', style: HearthTheme.display(18)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                    color: HC.terracotta, borderRadius: BorderRadius.circular(40)),
                child: Text('${queue.length}',
                    style: HearthTheme.body(12, w: FontWeight.w700, color: Colors.white)),
              ),
            ]),
            const SizedBox(height: 12),
            if (queue.isEmpty)
              SoftCard(
                child: Row(children: [
                  const Icon(Icons.check_circle_outline, color: HC.sage),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text('Queue clear - nothing to review.',
                          style: HearthTheme.body(14.5, w: FontWeight.w600))),
                ]),
              )
            else
              ...queue.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SoftCard(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                                color: HC.goldTint, borderRadius: BorderRadius.circular(40)),
                            child: Text(m.kind,
                                style: HearthTheme.body(11.5,
                                    w: FontWeight.w700, color: HC.terracottaDeep)),
                          ),
                          const Spacer(),
                          Text('by ${m.reporter}',
                              style: HearthTheme.body(12, color: HC.mutedLight)),
                        ]),
                        const SizedBox(height: 10),
                        Text(m.subject, style: HearthTheme.body(15, w: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Row(children: [
                          const Icon(Icons.report_problem_outlined, size: 14, color: HC.muted),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(m.reason,
                                  style: HearthTheme.body(13, color: HC.muted))),
                        ]),
                        const SizedBox(height: 14),
                        Row(children: [
                          Expanded(
                            child: _ActionBtn('Dismiss', HC.surfaceWarm, HC.ink,
                                () => ref.read(moderationQueueProvider.notifier).resolve(m.id)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ActionBtn('Suspend', HC.terracotta, Colors.white,
                                () => ref.read(moderationQueueProvider.notifier).resolve(m.id)),
                          ),
                        ]),
                      ]),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;
  const _Kpi(this.value, this.label, this.color, this.icon);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HC.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HC.hairline),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 12),
          Text(value, style: HearthTheme.display(24, w: FontWeight.w700)),
          Text(label, style: HearthTheme.body(12.5, color: HC.muted)),
        ]),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;
  const _ActionBtn(this.label, this.bg, this.fg, this.onTap);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
              child: Text(label,
                  style: HearthTheme.body(14, w: FontWeight.w700, color: fg))),
        ),
      ),
    );
  }
}
