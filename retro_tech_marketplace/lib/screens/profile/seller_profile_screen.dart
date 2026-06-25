import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';
import '../home/home_screen.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key, required this.store, this.sellerName});

  final ListingStore store;
  final String? sellerName;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final seller = sellerName ?? store.profile.sellerName;
        final activeListings = store.bySeller(seller);
        final following = store.isFollowing(seller);
        return GlassScaffold(
          child: ListView(
            padding: EdgeInsets.fromLTRB(22, 18, 22, 30),
            children: [
              TopBar(
                title: 'Seller Profile',
                trailing: Icons.ios_share_rounded,
              ),
              SizedBox(height: 24),
              Center(child: LogoMark(size: 112, heroTag: sellerLogoHeroTag)),
              SizedBox(height: 18),
              Center(
                child: Text(seller, style: AppTheme.h1.copyWith(fontSize: 26)),
              ),
              Center(
                child: Text(
                  '4.9 star  |  Verified Seller',
                  style: AppTheme.label,
                ),
              ),
              SizedBox(height: 6),
              Center(
                child: Text(
                  'Transparent tech specialist',
                  style: AppTheme.body,
                ),
              ),
              SizedBox(height: 22),
              Row(
                children: [
                  ProfileStat('128', 'Sold', Icons.shopping_bag_outlined),
                  ProfileStat(
                    '98%',
                    'Positive',
                    Icons.favorite_rounded,
                    color: AppTheme.green,
                  ),
                  ProfileStat('2h', 'Reply', Icons.chat_outlined),
                ],
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: LiquidButton(
                      label: 'Message Seller',
                      height: 48,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: activeListings.isEmpty
                            ? seller
                            : activeListings.first,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: LiquidPressable(
                      onTap: () {
                        store.toggleFollow(seller);
                      },
                      active: following,
                      borderRadius: BorderRadius.circular(999),
                      glowColor: AppTheme.blue,
                      child: GlassCard(
                        height: 48,
                        radius: 999,
                        padding: EdgeInsets.zero,
                        child: Center(
                          child: Text(
                            following ? 'Following' : 'Follow',
                            style: AppTheme.label.copyWith(
                              color: following ? AppTheme.red : AppTheme.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Active Listings',
                style: AppTheme.h2.copyWith(fontSize: 17),
              ),
              SizedBox(height: 12),
              if (activeListings.isEmpty)
                GlassCard(
                  child: Text(
                    'No active listings from this seller yet.',
                    style: AppTheme.body,
                  ),
                )
              else
                ...activeListings
                    .take(4)
                    .map(
                      (listing) => ListingCard(
                        listing: listing,
                        openStore: store,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: listing,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
