import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  String _filter = 'Orders';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    final query = _query.trim().toLowerCase();
    final faqs = _helpTopics.where((topic) {
      final matchesFilter = topic.category == _filter;
      final matchesQuery =
          query.isEmpty ||
          topic.title.toLowerCase().contains(query) ||
          topic.body.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
    return GlassScaffold(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              metrics.pagePadding,
              metrics.topGap,
              metrics.pagePadding,
              104,
            ),
            children: [
              Row(
                children: [
                  CircleGlassButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  Spacer(),
                  CircleGlassButton(
                    icon: Icons.headset_mic_outlined,
                    color: AppTheme.blue,
                  ),
                ],
              ),
              SizedBox(height: 22),
              Text('How can we help?', style: AppTheme.h1),
              SizedBox(height: 18),
              GlassCard(
                height: 52,
                radius: 23,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  key: const ValueKey('help-search-field'),
                  onChanged: (value) => setState(() => _query = value),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppTheme.muted,
                      size: 18,
                    ),
                    hintText: 'Search help topics',
                    hintStyle: AppTheme.body,
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Wrap(
                runSpacing: 8,
                children: [
                  for (final label in const [
                    'Orders',
                    'Selling',
                    'Payments',
                    'Safety',
                  ])
                    FilterPill(
                      label,
                      _filter == label,
                      onTap: () => setState(() => _filter = label),
                    ),
                ],
              ),
              SizedBox(height: 18),
              if (faqs.isEmpty)
                GlassCard(
                  child: Text('No help topics found.', style: AppTheme.body),
                )
              else
                ...faqs.map((topic) => FaqTile(topic.title, topic.body)),
            ],
          ),
          Positioned(
            left: metrics.pagePadding,
            right: metrics.pagePadding,
            bottom: 22,
            child: LiquidButton(
              label: 'Start Live Chat',
              icon: Icons.chat_bubble_rounded,
              onPressed: () => Navigator.pushNamed(context, '/chat'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpTopic {
  const _HelpTopic(this.category, this.title, this.body);

  final String category;
  final String title;
  final String body;
}

const _helpTopics = [
  _HelpTopic(
    'Orders',
    'How do I contact a seller?',
    'Message sellers securely from any product page.',
  ),
  _HelpTopic(
    'Orders',
    'How do I track an order?',
    'Open Orders from your profile and tap Track Order after payment.',
  ),
  _HelpTopic(
    'Selling',
    'How do I create a listing?',
    'Add product details, photos, and price in minutes.',
  ),
  _HelpTopic(
    'Payments',
    'How are payments protected?',
    'Protected checkout helps keep transactions safe.',
  ),
  _HelpTopic(
    'Safety',
    'How do I report a fake item?',
    'Flag suspicious listings and our team will review them.',
  ),
];

class FaqTile extends StatefulWidget {
  const FaqTile(this.title, this.body, {super.key});

  final String title;
  final String body;

  @override
  State<FaqTile> createState() => FaqTileState();
}

class FaqTileState extends State<FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LiquidPressable(
      onTap: () => setState(() => _expanded = !_expanded),
      active: _expanded,
      borderRadius: BorderRadius.circular(22),
      glowColor: AppTheme.blue,
      child: GlassCard(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        radius: 22,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.help_outline_rounded, color: AppTheme.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, left: 36),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.body, style: AppTheme.body),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
