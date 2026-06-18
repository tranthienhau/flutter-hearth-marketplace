import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import '../shell/home_shell.dart';

/// Identity verification: email confirmed, ID scan, selfie match.
/// The scan is simulated behind a tap so it runs on a bare simulator.
class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool idScanned = false;
  bool selfieDone = false;

  bool get complete => idScanned && selfieDone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identity verification', style: HearthTheme.display(18)),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerifiedPill(
                  label: 'Secure & encrypted', icon: Icons.lock_outline, color: HC.sage),
              const SizedBox(height: 18),
              Text("Let's confirm it's really you",
                  style: HearthTheme.display(28, w: FontWeight.w700)),
              const SizedBox(height: 24),
              _Step(
                done: true,
                icon: Icons.mark_email_read_outlined,
                title: 'Email confirmed',
                subtitle: Mock.memberEmail,
                trailing: 'Now',
              ),
              const SizedBox(height: 12),
              _Step(
                done: idScanned,
                icon: Icons.badge_outlined,
                title: 'Scan your photo ID',
                subtitle: "Driver's licence or passport",
                onTap: () => setState(() => idScanned = true),
                cta: idScanned ? null : 'Scan ID',
              ),
              const SizedBox(height: 12),
              _Step(
                done: selfieDone,
                icon: Icons.face_retouching_natural_outlined,
                title: 'Quick selfie match',
                subtitle: 'Confirms the ID is yours',
                onTap: idScanned ? () => setState(() => selfieDone = true) : null,
                cta: selfieDone ? null : 'Take selfie',
                disabled: !idScanned,
              ),
              const Spacer(),
              Row(children: [
                const Icon(Icons.shield_outlined, size: 16, color: HC.mutedLight),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      'Your ID is encrypted end-to-end and never shown to other members.',
                      style: HearthTheme.body(12.5, color: HC.muted)),
                ),
              ]),
              const SizedBox(height: 16),
              HearthButton(
                complete ? 'Start exploring' : 'Complete verification',
                icon: complete ? Icons.check_circle_outline : null,
                onTap: complete
                    ? () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomeShell()))
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final bool done;
  final bool disabled;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;
  final String? cta;
  final VoidCallback? onTap;
  const _Step({
    required this.done,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.cta,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: SoftCard(
        onTap: disabled ? null : onTap,
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: done ? HC.sage.withValues(alpha: 0.16) : HC.surfaceWarm,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(done ? Icons.check_rounded : icon,
                color: done ? HC.sage : HC.inkSoft, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: HearthTheme.body(15.5, w: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: HearthTheme.body(13, color: HC.muted)),
            ]),
          ),
          if (done && trailing != null)
            Text(trailing!, style: HearthTheme.body(12.5, color: HC.sage, w: FontWeight.w600))
          else if (done)
            const Icon(Icons.verified_rounded, color: HC.sage, size: 22)
          else if (cta != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: HC.terracotta, borderRadius: BorderRadius.circular(40)),
              child: Text(cta!,
                  style: HearthTheme.body(13, w: FontWeight.w700, color: Colors.white)),
            ),
        ]),
      ),
    );
  }
}
