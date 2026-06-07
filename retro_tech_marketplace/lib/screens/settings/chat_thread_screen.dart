import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/seed_data.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key, this.inShell = false});

  final bool inShell;

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    final content = ListView(
      padding: inShell
          ? metrics.pageInsetsWithNav
          : EdgeInsets.fromLTRB(22, 18, 22, 30 + metrics.bottomSafeInset),
      children: [
        Row(
          children: [
            CircleGlassButton(icon: Icons.search_rounded),
            Spacer(),
            Text('Inbox', style: AppTheme.h2),
            Spacer(),
            CircleGlassButton(icon: Icons.tune_rounded),
          ],
        ),
        SizedBox(height: 18),
        Row(
          children: [
            FilterPill('Messages', true),
            FilterPill('Orders', false),
            FilterPill('Support', false),
          ],
        ),
        SizedBox(height: 18),
        MessageTile(
          'RetroTech Collector',
          'The iPod is fully tested and ready to ship.',
          '2m',
          '2',
          Assets.ipod,
        ),
        MessageTile(
          'VintageAudioCo',
          'I can include the original earbuds for you.',
          '18m',
          '1',
          Assets.avatarVintage,
        ),
        MessageTile(
          'PalmPilotFan',
          'Battery holds charge well. Let me know if you want more photos.',
          '1h',
          '3',
          Assets.avatarPalm,
        ),
        MessageTile(
          'PixelCam Studio',
          'Price is firm, but shipping is free.',
          'Yesterday',
          '',
          Assets.avatarPixel,
        ),
      ],
    );
    return inShell ? content : GlassScaffold(child: content);
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile(this.name, this.message, this.time, this.badge, this.asset);

  final String name;
  final String message;
  final String time;
  final String badge;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return LiquidPressable(
      onTap: () => Navigator.pushNamed(context, '/chat'),
      borderRadius: BorderRadius.circular(30),
      glowColor: AppTheme.blue,
      child: GlassCard(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ClipOval(child: ProductImage(asset: asset, width: 48, height: 48)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.body.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              children: [
                Text(time, style: AppTheme.body.copyWith(fontSize: 10)),
                if (badge.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppTheme.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({super.key, this.listing});

  final Listing? listing;

  @override
  State<ChatThreadScreen> createState() => ChatThreadScreenState();
}

class ChatThreadScreenState extends State<ChatThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<_ChatLine> _messages = _initialMessages;

  Listing get _item => widget.listing ?? seedListings.first;

  List<_ChatLine> get _initialMessages {
    final item = _item;
    return [
      _ChatLine(
        'Hi! Thanks for your interest in the ${item.title}.',
        false,
        '2:14 PM',
      ),
      _ChatLine(
        "It's in excellent condition. The front and back are clean.",
        false,
        '2:15 PM',
      ),
      _ChatLine(
        'Thanks! Can you confirm storage capacity and battery?',
        true,
        '2:16 PM',
      ),
      _ChatLine(
        "Sure! It is the ${item.storage} model and battery holds charge well.",
        false,
        '2:17 PM',
      ),
      _ChatLine(
        'Perfect, please do. Also, do you ship to Kuala Lumpur?',
        true,
        '2:18 PM',
      ),
      _ChatLine(
        'Yes, shipping is RM15 via Pos Laju and usually takes 2-3 working days.',
        false,
        '2:18 PM',
      ),
      _ChatLine(
        "Great! I'll take it. Please let me know your preferred payment method.",
        true,
        '2:19 PM',
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatLine(text, true, 'Now'));
      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    final metrics = ResponsiveMetrics.of(context);
    return GlassScaffold(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              metrics.pagePadding,
              metrics.topGap,
              metrics.pagePadding,
              0,
            ),
            child: Row(
              children: [
                CircleGlassButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.seller,
                        style: AppTheme.h2.copyWith(fontSize: 16),
                      ),
                      Text(
                        'Active today',
                        style: AppTheme.body.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                CircleGlassButton(icon: Icons.more_horiz_rounded),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              metrics.pagePadding,
              14,
              metrics.pagePadding,
              10,
            ),
            child: GlassCard(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  ProductImage(asset: item.imageAsset, width: 54, height: 54),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.shortTitle,
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          item.priceLabel,
                          style: AppTheme.label.copyWith(color: AppTheme.red),
                        ),
                        Text('View Listing', style: AppTheme.label),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(
                metrics.pagePadding,
                8,
                metrics.pagePadding,
                8,
              ),
              children: [
                Center(
                  child: Text(
                    'Today 2:14 PM',
                    style: AppTheme.body.copyWith(fontSize: 11),
                  ),
                ),
                SizedBox(height: 12),
                ..._messages.map((message) => _ChatBubble(message)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              metrics.pagePadding,
              6,
              metrics.pagePadding,
              18 + MediaQuery.viewPaddingOf(context).bottom,
            ),
            child: GlassCard(
              radius: 999,
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.image_outlined, color: AppTheme.muted),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      key: const ValueKey('chat-message-field'),
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      minLines: 1,
                      maxLines: 3,
                      style: TextStyle(
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Message seller',
                        hintStyle: AppTheme.body,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  CircleGlassButton(
                    icon: Icons.send_rounded,
                    color: AppTheme.red,
                    size: 42,
                    onTap: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatLine {
  const _ChatLine(this.text, this.mine, this.time);

  final String text;
  final bool mine;
  final String time;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble(this.line);

  final _ChatLine line;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: line.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.74,
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: line.mine
                ? AppTheme.red
                : Colors.white.withValues(alpha: 0.72),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.text,
                style: TextStyle(
                  color: line.mine ? Colors.white : AppTheme.ink,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 5),
              Text(
                line.time,
                style: TextStyle(
                  color: line.mine
                      ? Colors.white.withValues(alpha: 0.78)
                      : AppTheme.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
