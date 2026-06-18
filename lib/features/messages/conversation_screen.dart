import 'package:flutter/material.dart';
import '../../data/models.dart';
import '../../data/mock_data.dart';
import '../../theme/hearth_theme.dart';
import '../../widgets/common.dart';

/// In-app messaging thread between member and pro.
class ConversationScreen extends StatefulWidget {
  final String pro;
  final String initials;
  const ConversationScreen({super.key, required this.pro, required this.initials});
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late final List<ChatMessage> messages = List.of(Mock.conversation);
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _send() {
    final t = controller.text.trim();
    if (t.isEmpty) return;
    setState(() {
      messages.add(ChatMessage(t, mine: true));
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(children: [
          Monogram(widget.initials, color: HC.terracotta, size: 38),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.pro, style: HearthTheme.body(15.5, w: FontWeight.w700)),
            Row(children: [
              Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: HC.sage, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Text('Active now', style: HearthTheme.body(12, color: HC.sage)),
            ]),
          ]),
        ]),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: messages.length,
              itemBuilder: (_, i) => _Bubble(messages[i]),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: const BoxDecoration(
              color: HC.card,
              border: Border(top: BorderSide(color: HC.hairline)),
            ),
            child: Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                      color: HC.bg, borderRadius: BorderRadius.circular(40)),
                  child: TextField(
                    controller: controller,
                    style: HearthTheme.body(14.5),
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: HearthTheme.body(14.5, color: HC.mutedLight),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                      color: HC.terracotta, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage m;
  const _Bubble(this.m);
  @override
  Widget build(BuildContext context) {
    if (m.system) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
              color: HC.sageTint, borderRadius: BorderRadius.circular(40)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, size: 14, color: HC.sage),
            const SizedBox(width: 6),
            Text(m.text, style: HearthTheme.body(12.5, w: FontWeight.w600, color: HC.forest)),
          ]),
        ),
      );
    }
    return Align(
      alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: m.mine ? HC.terracotta : HC.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(m.mine ? 18 : 4),
            bottomRight: Radius.circular(m.mine ? 4 : 18),
          ),
          border: m.mine ? null : Border.all(color: HC.hairline),
        ),
        child: Text(m.text,
            style: HearthTheme.body(14.5,
                h: 1.35, color: m.mine ? Colors.white : HC.ink)),
      ),
    );
  }
}
