import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';
import '../home/home_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({
    super.key,
    required this.store,
    required this.category,
  });

  final ListingStore store;
  final String category;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  String _filter = 'All';

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
        animation: widget.store,
        builder: (context, _) {
          final categoryItems = widget.store.byCategory(widget.category);
          final baseItems = categoryItems.isEmpty
              ? widget.store.listings
              : categoryItems;
          final items = _filteredItems(baseItems);
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
                  Text(widget.category, style: AppTheme.h2),
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
                        '${widget.category} Collection',
                        style: AppTheme.h2.copyWith(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: metrics.gutter),
                    ProductImage(
                      asset: categoryAssetFor(widget.category),
                      width: 120,
                      height: 100,
                      heroTag: categoryHeroTag(widget.category),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterPill(
                      'All',
                      _filter == 'All',
                      onTap: () => setState(() => _filter = 'All'),
                    ),
                    FilterPill(
                      'Under RM1000',
                      _filter == 'Under RM1000',
                      onTap: () => setState(() => _filter = 'Under RM1000'),
                    ),
                    FilterPill(
                      'RM1000+',
                      _filter == 'RM1000+',
                      onTap: () => setState(() => _filter = 'RM1000+'),
                    ),
                    FilterPill(
                      'Featured',
                      _filter == 'Featured',
                      onTap: () => setState(() => _filter = 'Featured'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              if (items.isEmpty)
                GlassCard(
                  child: Text(
                    'No items match this filter.',
                    style: AppTheme.body,
                  ),
                )
              else
                ...items.map(
                  (listing) => ListingCard(
                    listing: listing,
                    openStore: widget.store,
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

  List<Listing> _filteredItems(List<Listing> items) {
    return switch (_filter) {
      'Under RM1000' =>
        items.where((listing) => listing.price < 1000).toList(growable: false),
      'RM1000+' =>
        items.where((listing) => listing.price >= 1000).toList(growable: false),
      'Featured' =>
        items
            .where((listing) => listing.status.toUpperCase() == 'FEATURED')
            .toList(growable: false),
      _ => items,
    };
  }
}
