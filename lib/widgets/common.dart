import 'package:flutter/material.dart';
import '../theme/hearth_theme.dart';

/// Round monogram avatar (no network images needed for the demo).
class Monogram extends StatelessWidget {
  final String initials;
  final double size;
  final Color color;
  const Monogram(this.initials, {super.key, this.size = 48, this.color = HC.sage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(initials,
          style: HearthTheme.display(size * 0.34, color: color, w: FontWeight.w600)),
    );
  }
}

/// Photo-hero placeholder using a warm gradient + category glyph.
class HeroSwatch extends StatelessWidget {
  final Color accent;
  final IconData icon;
  final double height;
  final BorderRadius? radius;
  const HeroSwatch({
    super.key,
    required this.accent,
    required this.icon,
    this.height = 180,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius ?? BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.85),
            accent.withValues(alpha: 0.55),
            HC.surfaceSand,
          ],
        ),
      ),
      child: Center(
        child: Icon(icon, size: height * 0.34, color: Colors.white.withValues(alpha: 0.9)),
      ),
    );
  }
}

class VerifiedPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const VerifiedPill(
      {super.key,
      this.label = 'ID verified',
      this.icon = Icons.verified_user_outlined,
      this.color = HC.sage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(label, style: HearthTheme.body(12.5, w: FontWeight.w600, color: color)),
      ]),
    );
  }
}

class RatingChip extends StatelessWidget {
  final double rating;
  final String? trailing;
  const RatingChip(this.rating, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.star_rounded, size: 17, color: HC.gold),
      const SizedBox(width: 3),
      Text(rating.toStringAsFixed(2),
          style: HearthTheme.body(13.5, w: FontWeight.w700)),
      if (trailing != null) ...[
        const SizedBox(width: 4),
        Text(trailing!, style: HearthTheme.body(13, color: HC.muted)),
      ],
    ]);
  }
}

/// Full-width terracotta action button.
class HearthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool filled;
  const HearthButton(this.label,
      {super.key, this.onTap, this.icon, this.filled = true});

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : HC.ink;
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 19, color: fg), const SizedBox(width: 8)],
        Text(label, style: HearthTheme.body(16, w: FontWeight.w700, color: fg)),
      ],
    );
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: filled ? HC.terracotta : HC.surfaceWarm,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: HearthTheme.display(20)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: HearthTheme.body(14, w: FontWeight.w600, color: HC.terracotta)),
          ),
      ],
    );
  }
}

/// Soft white card wrapper.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const SoftCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16),
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HC.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: HC.hairline),
          ),
          child: child,
        ),
      ),
    );
  }
}
