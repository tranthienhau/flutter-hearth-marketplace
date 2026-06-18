import 'package:flutter/material.dart';
import '../../data/models.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';

/// Create a listing - pro onboarding form (mockup, no persistence).
class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});
  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  ServiceCategory category = ServiceCategory.wellness;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New listing', style: HearthTheme.display(18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
                child: Text('Draft',
                    style: HearthTheme.body(13.5, w: FontWeight.w600, color: HC.muted))),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            _Label('Cover photos'),
            const SizedBox(height: 10),
            Row(children: [
              _AddPhoto(),
              const SizedBox(width: 10),
              _AddPhoto(),
              const SizedBox(width: 10),
              _AddPhoto(filled: true),
            ]),
            const SizedBox(height: 22),
            _Label('Title'),
            const SizedBox(height: 8),
            _Field(hint: 'e.g. Deep-tissue & sports massage'),
            const SizedBox(height: 20),
            _Label('Category'),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final c in ServiceCategory.values)
                GestureDetector(
                  onTap: () => setState(() => category = c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: category == c ? HC.terracotta : HC.card,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                          color: category == c ? HC.terracotta : HC.hairline),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(c.icon,
                          size: 15, color: category == c ? Colors.white : HC.inkSoft),
                      const SizedBox(width: 6),
                      Text(c.label,
                          style: HearthTheme.body(13.5,
                              w: FontWeight.w600,
                              color: category == c ? Colors.white : HC.ink)),
                    ]),
                  ),
                ),
            ]),
            const SizedBox(height: 20),
            _Label('About this session'),
            const SizedBox(height: 8),
            _Field(hint: 'What members can expect, what you bring...', lines: 4),
            const SizedBox(height: 20),
            _Label('Sessions & pricing'),
            const SizedBox(height: 10),
            _PriceRow('60 min - Full body', r'$90'),
            const SizedBox(height: 10),
            _PriceRow('90 min - Deep recovery', r'$130'),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.add_circle_outline, size: 18, color: HC.terracotta),
              const SizedBox(width: 8),
              Text('Add another option',
                  style: HearthTheme.body(14, w: FontWeight.w600, color: HC.terracotta)),
            ]),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: SizedBox(
                    height: 56,
                    child: HearthButton('Preview', filled: false, onTap: () {})),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HearthButton('Publish listing', onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: HC.sage,
                    content: Text('Listing submitted for review',
                        style: HearthTheme.body(14, color: Colors.white)),
                  ));
                  Navigator.pop(context);
                }),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: HearthTheme.body(15, w: FontWeight.w700));
}

class _AddPhoto extends StatelessWidget {
  final bool filled;
  const _AddPhoto({this.filled = false});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: filled ? null : HC.card,
            gradient: filled
                ? const LinearGradient(
                    colors: [HC.peach, HC.surfaceSand],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                : null,
            borderRadius: BorderRadius.circular(14),
            border: filled ? null : Border.all(color: HC.hairline),
          ),
          child: Icon(filled ? Icons.image_outlined : Icons.add,
              color: filled ? Colors.white : HC.mutedLight, size: 24),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String hint;
  final int lines;
  const _Field({required this.hint, this.lines = 1});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: HC.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HC.hairline),
      ),
      child: TextField(
        maxLines: lines,
        style: HearthTheme.body(15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: HearthTheme.body(14.5, color: HC.mutedLight),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String name;
  final String price;
  const _PriceRow(this.name, this.price);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: HC.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HC.hairline),
      ),
      child: Row(children: [
        const Icon(Icons.schedule, size: 18, color: HC.inkSoft),
        const SizedBox(width: 10),
        Expanded(child: Text(name, style: HearthTheme.body(14.5, w: FontWeight.w600))),
        Text(price, style: HearthTheme.display(16)),
      ]),
    );
  }
}
