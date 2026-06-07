import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';
import '../home/home_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({
    super.key,
    required this.store,
    required this.category,
  });

  final ListingStore store;
  final String category;

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    return GlassScaffold(
      bottomNavigationBar: GlassBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) {
            Navigator.pop(context);
            return;
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/create-listing');
            return;
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/main',
            (route) => false,
            arguments: index,
          );
        },
      ),
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final items = store.byCategory(category).isEmpty
              ? store.listings
              : store.byCategory(category);
          return ListView(
            padding: metrics.pageInsetsWithNav,
            children: [
              Row(
                children: [
                  CircleGlassButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  Spacer(),
                  Text(category, style: AppTheme.h2),
                  Spacer(),
                  CircleGlassButton(icon: Icons.tune_rounded),
                ],
              ),
              SizedBox(height: 22),
              GlassCard(
                height: 126,
                radius: metrics.cardRadius,
                padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
                opacity: 0.22,
                blur: 42,
                borderOpacity: 0.9,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$category Collection',
                        style: AppTheme.h2.copyWith(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: metrics.gutter),
                    ProductImage(
                      asset: categoryAssetFor(category),
                      width: 120,
                      height: 100,
                      heroTag: categoryHeroTag(category),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  FilterPill('All', true),
                  FilterPill('iPod', false),
                  FilterPill('Walkman', false),
                  FilterPill('Speakers', false),
                ],
              ),
              SizedBox(height: 22),
              ...items.map(
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
          );
        },
      ),
    );
  }
}
