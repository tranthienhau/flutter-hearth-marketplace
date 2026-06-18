import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_data.dart';
import '../../data/providers.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import '../create/create_listing_screen.dart';
import '../admin/admin_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedProvider).length;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Row(children: [
            const Monogram(Mock.memberInitials, color: HC.terracotta, size: 64),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(Mock.memberName, style: HearthTheme.display(22, w: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(children: [
                  const VerifiedPill(label: 'Verified member'),
                  const SizedBox(width: 8),
                  Text('Since ${Mock.memberSince}',
                      style: HearthTheme.body(12.5, color: HC.muted)),
                ]),
              ]),
            ),
          ]),
          const SizedBox(height: 20),
          SoftCard(
            child: Row(children: [
              _Stat('23', 'Bookings'),
              _div(),
              _Stat('4.9', 'As a client'),
              _div(),
              _Stat('$saved', 'Saved pros'),
            ]),
          ),
          const SizedBox(height: 22),
          _GroupCard(rows: [
            _Row(Icons.add_business_outlined, 'Become a pro - create a listing',
                color: HC.terracotta,
                onTap: () => _push(context, const CreateListingScreen())),
            _Row(Icons.credit_card_outlined, 'Payment methods', trailing: 'Mastercard ···· 4242'),
            _Row(Icons.verified_user_outlined, 'Identity', trailing: 'Verified', trailingColor: HC.sage),
            _Row(Icons.public, 'Display currency', trailing: ref.watch(currencyProvider).code),
            _Row(Icons.notifications_none, 'Notifications', trailing: 'On'),
            _Row(Icons.admin_panel_settings_outlined, 'Admin & moderation',
                onTap: () => _push(context, const AdminScreen())),
          ]),
          const SizedBox(height: 22),
          Text('What pros say about you', style: HearthTheme.display(18)),
          const SizedBox(height: 12),
          _ProReview('Maya Rivera', 'Massage therapist',
              'Always prepared and respectful of time. Great communication.'),
          const SizedBox(height: 10),
          _ProReview('Daniel Kwon', 'Guitar teacher',
              'Great energy in every lesson - a pleasure to teach.'),
        ],
      ),
    );
  }

  Widget _div() => Container(width: 1, height: 34, color: HC.hairline);
  void _push(BuildContext c, Widget w) =>
      Navigator.of(c).push(MaterialPageRoute(builder: (_) => w));
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Text(value, style: HearthTheme.display(22)),
          const SizedBox(height: 2),
          Text(label, style: HearthTheme.body(12, color: HC.muted)),
        ]),
      );
}

class _GroupCard extends StatelessWidget {
  final List<Widget> rows;
  const _GroupCard({required this.rows});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HC.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HC.hairline),
      ),
      child: Column(children: [
        for (var i = 0; i < rows.length; i++) ...[
          rows[i],
          if (i < rows.length - 1)
            const Divider(height: 1, indent: 56, color: HC.hairline),
        ],
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color? trailingColor;
  final Color color;
  final VoidCallback? onTap;
  const _Row(this.icon, this.label,
      {this.trailing, this.trailingColor, this.color = HC.inkSoft, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(children: [
          Icon(icon, size: 21, color: color),
          const SizedBox(width: 14),
          Expanded(
              child: Text(label,
                  style: HearthTheme.body(15,
                      w: FontWeight.w600,
                      color: color == HC.terracotta ? HC.terracotta : HC.ink))),
          if (trailing != null)
            Text(trailing!,
                style: HearthTheme.body(13.5,
                    w: FontWeight.w600, color: trailingColor ?? HC.muted)),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, size: 20, color: HC.mutedLight),
        ]),
      ),
    );
  }
}

class _ProReview extends StatelessWidget {
  final String pro;
  final String role;
  final String text;
  const _ProReview(this.pro, this.role, this.text);
  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Monogram(pro.split(' ').map((w) => w[0]).take(2).join(), size: 34, color: HC.sage),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(pro, style: HearthTheme.body(14, w: FontWeight.w700)),
              Text(role, style: HearthTheme.body(12, color: HC.muted)),
            ]),
          ),
          Row(children: List.generate(
              5, (_) => const Icon(Icons.star_rounded, size: 14, color: HC.gold))),
        ]),
        const SizedBox(height: 10),
        Text('"$text"', style: HearthTheme.body(13.5, color: HC.inkSoft, h: 1.45)),
      ]),
    );
  }
}
