import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/image_cache.dart';
import '../../widgets/interaction_helpers.dart';
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
                    onTap: () => showInfoSheet(
                      context,
                      icon: Icons.headset_mic_outlined,
                      title: 'RetroTech Support',
                      body:
                          'Support chat can help with listings, payments, orders, and account questions in this demo.',
                      actionLabel: 'Start Live Chat',
                      onAction: () => Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: 'RetroTech Support',
                      ),
                    ),
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
                ...faqs.map(
                  (topic) => FaqTile(topic.title, topic.body, topic.imageAsset),
                ),
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
  const _HelpTopic(this.category, this.title, this.body, this.imageAsset);

  final String category;
  final String title;
  final String body;
  final String imageAsset;
}

const _helpTopics = [
  _HelpTopic(
    'Orders',
    'How do I contact a seller?',
    'Message sellers securely from any product page.',
    Assets.helpOrders,
  ),
  _HelpTopic(
    'Orders',
    'How do I track an order?',
    'Open Orders from your profile and tap an order after checkout to see its status.',
    Assets.helpOrders,
  ),
  _HelpTopic(
    'Orders',
    'Where can I find my order receipt?',
    'Open Orders from your profile to review the order number, seller, total, and payment method.',
    Assets.helpOrders,
  ),
  _HelpTopic(
    'Orders',
    'What if the seller has not replied?',
    'Send a message from the product page or chat thread and include the order number if you already paid.',
    Assets.helpOrders,
  ),
  _HelpTopic(
    'Orders',
    'Can I cancel an order?',
    'Start a support chat before the seller prepares the item so the team can review the order.',
    Assets.helpOrders,
  ),
  _HelpTopic(
    'Selling',
    'How do I create a listing?',
    'Add product details, photos, and price in minutes.',
    Assets.helpSelling,
  ),
  _HelpTopic(
    'Selling',
    'How do I edit a listing?',
    'Open My Listings from your profile, choose a listing, and save the updated details.',
    Assets.helpSelling,
  ),
  _HelpTopic(
    'Selling',
    'How do I delete a listing?',
    'Use Delete Listing from the edit screen or listing action and confirm the removal.',
    Assets.helpSelling,
  ),
  _HelpTopic(
    'Selling',
    'What photos should I upload?',
    'Use clear front, side, and back photos, and include visible marks or accessories.',
    Assets.helpSelling,
  ),
  _HelpTopic(
    'Selling',
    'What do listing statuses mean?',
    'Published items appear in the marketplace, drafts stay private, and sold items remain in your dashboard.',
    Assets.helpSelling,
  ),
  _HelpTopic(
    'Payments',
    'How are payments protected?',
    'Protected checkout helps keep transactions safe.',
    Assets.helpPayments,
  ),
  _HelpTopic(
    'Payments',
    'Which payment methods can I use?',
    "Visa, Apple Pay, Touch 'n Go eWallet, and Online Banking are available in Payment Methods.",
    Assets.helpPayments,
  ),
  _HelpTopic(
    'Payments',
    'How do I change my payment method?',
    'Open Payment Method during checkout or Payment Methods from your profile and select another option.',
    Assets.helpPayments,
  ),
  _HelpTopic(
    'Payments',
    'Is my card information shown?',
    'RetroTech only shows the selected payment label in the demo and never displays full card details.',
    Assets.helpPayments,
  ),
  _HelpTopic(
    'Payments',
    'What is Buyer Protection?',
    'Keep checkout and chat details in RetroTech so support can review eligible purchase issues.',
    Assets.helpPayments,
  ),
  _HelpTopic(
    'Safety',
    'How do I report a fake item?',
    'Start a support chat with the listing title, seller name, and reason for review.',
    Assets.helpSafety,
  ),
  _HelpTopic(
    'Safety',
    'What should I check before buying?',
    'Review the condition, photos, storage, battery, connector details, and seller profile before checkout.',
    Assets.helpSafety,
  ),
  _HelpTopic(
    'Safety',
    'How do I keep a purchase safe?',
    'Keep messages inside RetroTech chat and use checkout so order details stay visible.',
    Assets.helpSafety,
  ),
  _HelpTopic(
    'Safety',
    'How do I spot risky payment requests?',
    'Only trust orders confirmed in RetroTech and avoid sending money through outside links.',
    Assets.helpSafety,
  ),
  _HelpTopic(
    'Safety',
    'What if a profile looks suspicious?',
    'Do not share passwords or codes, then contact support with the profile and listing details.',
    Assets.helpSafety,
  ),
];

class FaqTile extends StatefulWidget {
  const FaqTile(this.title, this.body, this.imageAsset, {super.key});

  final String title;
  final String body;
  final String imageAsset;

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
        key: ValueKey('faq-card-${widget.title}'),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.body, style: AppTheme.body),
                          SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.asset(
                                widget.imageAsset,
                                key: ValueKey('faq-image-${widget.imageAsset}'),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                cacheWidth: imageCacheDimension(
                                  context,
                                  320,
                                  logicalHeight: 180,
                                ),
                              ),
                            ),
                          ),
                        ],
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
