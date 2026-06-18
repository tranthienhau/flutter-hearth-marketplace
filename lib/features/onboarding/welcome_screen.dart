import 'package:flutter/material.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import 'verify_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [HC.surfaceSand, HC.bg],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: HC.terracotta, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.local_fire_department_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text('Hearth', style: HearthTheme.display(24)),
                ]),
                const Spacer(),
                Text('Book trusted\npros near you.',
                    style: HearthTheme.display(44, w: FontWeight.w700)),
                const SizedBox(height: 16),
                Text(
                    'Massage, lessons, beauty and home services - '
                    'from members who are verified before anyone books.',
                    style: HearthTheme.body(16.5, color: HC.inkSoft, h: 1.4)),
                const Spacer(),
                const _TrustNote(),
                const SizedBox(height: 20),
                HearthButton('Continue with Apple',
                    icon: Icons.apple, onTap: () => _go(context)),
                const SizedBox(height: 12),
                HearthButton('Continue with email',
                    filled: false, onTap: () => _go(context)),
                const SizedBox(height: 16),
                Center(
                  child: Text('By continuing you agree to our Terms & Privacy Policy',
                      style: HearthTheme.body(12, color: HC.mutedLight)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context) => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VerifyScreen()));
}

class _TrustNote extends StatelessWidget {
  const _TrustNote();
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.verified_user_rounded, color: HC.sage, size: 20),
      const SizedBox(width: 10),
      Expanded(
        child: Text('Every member is ID-verified before booking',
            style: HearthTheme.body(14, w: FontWeight.w600, color: HC.sage)),
      ),
    ]);
  }
}
