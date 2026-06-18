import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';
import 'conversation_screen.dart';

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = [
      ('maya', 'Got it - I will bring a heat pack too.', '2m', true),
      ('daniel', 'Sounds good, see you Saturday!', '1h', false),
      ('priya', 'Your colour kit is ready to collect.', '3d', false),
    ];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text('Messages', style: HearthTheme.display(26, w: FontWeight.w700)),
          const SizedBox(height: 16),
          ...threads.map((t) {
            final l = Mock.byId(t.$1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SoftCard(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ConversationScreen(pro: l.pro, initials: l.initials))),
                child: Row(children: [
                  Monogram(l.initials, color: l.accent, size: 50),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(l.pro, style: HearthTheme.body(15, w: FontWeight.w700)),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, size: 14, color: HC.sage),
                        const Spacer(),
                        Text(t.$3, style: HearthTheme.body(12, color: HC.mutedLight)),
                      ]),
                      const SizedBox(height: 3),
                      Text(t.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HearthTheme.body(13.5,
                              color: t.$4 ? HC.ink : HC.muted,
                              w: t.$4 ? FontWeight.w600 : FontWeight.w400)),
                    ]),
                  ),
                  if (t.$4) ...[
                    const SizedBox(width: 8),
                    Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                            color: HC.terracotta, shape: BoxShape.circle)),
                  ],
                ]),
              ),
            );
          }),
        ],
      ),
    );
  }
}
