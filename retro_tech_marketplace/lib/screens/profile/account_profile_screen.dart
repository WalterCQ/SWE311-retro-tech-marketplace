import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/theme.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';

class AccountProfileScreen extends StatelessWidget {
  const AccountProfileScreen({super.key, required this.store});

  final ListingStore store;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final metrics = ResponsiveMetrics.of(context);
        return ListView(
          padding: metrics.pageInsetsWithNav,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CircleGlassButton(
                icon: Icons.settings_rounded,
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
            ),
            SizedBox(height: 2),
            Center(child: LogoMark(size: 94)),
            SizedBox(height: 12),
            Center(
              child: Text(
                'Retro Tech',
                style: AppTheme.h1.copyWith(fontSize: 26),
              ),
            ),
            Center(
              child: Text(
                '@retrotech',
                style: AppTheme.body.copyWith(fontSize: 14),
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text('Collect rare. Live timeless.', style: AppTheme.body),
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
                child: Text('Edit Profile', style: AppTheme.label),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ProfileStat(
                  '${store.listings.length}',
                  'Listings',
                  Icons.article_outlined,
                ),
                ProfileStat(
                  '342',
                  'Saved',
                  Icons.favorite_rounded,
                  color: AppTheme.red,
                ),
                ProfileStat('1.2K', 'Followers', Icons.groups_rounded),
                ProfileStat('98%', 'Rating', Icons.star_rounded),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Marketplace Dashboard',
              style: AppTheme.h2.copyWith(fontSize: 16),
            ),
            SizedBox(height: 10),
            GlassListSection(
              children: [
                ProfileRow(
                  'My Listings',
                  '${store.listings.length}',
                  Icons.sell_outlined,
                  () => Navigator.pushNamed(context, '/my-listings'),
                ),
                ProfileRow(
                  'Orders',
                  '8',
                  Icons.inventory_2_outlined,
                  () => Navigator.pushNamed(
                    context,
                    '/checkout',
                    arguments: store.listings.first,
                  ),
                ),
                ProfileRow(
                  'Saved Items',
                  '342',
                  Icons.favorite_border_rounded,
                  null,
                ),
                ProfileRow(
                  'Messages',
                  '8',
                  Icons.chat_bubble_outline_rounded,
                  () => Navigator.pushNamed(context, '/chat'),
                ),
              ],
            ),
            SizedBox(height: 14),
            Text('Recent Activity', style: AppTheme.h2.copyWith(fontSize: 16)),
            SizedBox(height: 12),
            ActivityTile(
              'iPod Classic 4th Gen',
              'Listing updated',
              '2h ago',
              Assets.ipodFront,
            ),
            ActivityTile('Motorola V60', 'Saved item', '1d ago', Assets.v60),
          ],
        );
      },
    );
  }
}

class ProfileRow extends StatelessWidget {
  const ProfileRow(this.title, this.badge, this.icon, this.onTap, {super.key});

  final String title;
  final String badge;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassListRow(
      icon: icon,
      title: title,
      badge: badge,
      onTap: onTap,
      dense: true,
    );
  }
}

class ActivityTile extends StatelessWidget {
  const ActivityTile(
    this.title,
    this.subtitle,
    this.time,
    this.asset, {
    super.key,
  });

  final String title;
  final String subtitle;
  final String time;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      radius: 20,
      child: Row(
        children: [
          ProductImage(asset: asset, width: 42, height: 42),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w900)),
                Text(subtitle, style: AppTheme.body.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: AppTheme.body.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({
    super.key,
    required this.user,
    required this.time,
    required this.text,
    required this.asset,
  });

  final String user;
  final String time;
  final String text;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return LiquidPressable(
      onTap: () {},
      borderRadius: BorderRadius.circular(30),
      glowColor: AppTheme.blue,
      child: GlassCard(
        margin: EdgeInsets.only(bottom: 14),
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(child: ProductImage(asset: asset, width: 44, height: 44)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(time, style: AppTheme.body.copyWith(fontSize: 10)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    text,
                    style: AppTheme.body.copyWith(color: AppTheme.ink),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        color: AppTheme.red,
                        size: 17,
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppTheme.blue,
                        size: 17,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
