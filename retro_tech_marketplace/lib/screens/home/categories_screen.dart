import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/theme.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';
import '../product/category_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.store});

  final ListingStore store;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    final categoryColumns = metrics.categoryColumns;
    final categories = [
      _CategoryData(
        'Phones',
        '128 items',
        Icons.phone_iphone_rounded,
        Assets.v60,
      ),
      _CategoryData(
        'Audio',
        '84 items',
        Icons.headphones_rounded,
        Assets.discmanHome,
      ),
      _CategoryData(
        'Gaming',
        '156 items',
        Icons.videogame_asset_rounded,
        Assets.gameboy,
      ),
      _CategoryData(
        'Cameras',
        '92 items',
        Icons.camera_alt_rounded,
        Assets.camera,
      ),
      _CategoryData(
        'Computing',
        '73 items',
        Icons.desktop_mac_rounded,
        Assets.imac,
      ),
      _CategoryData('Wearables', '64 items', Icons.watch_rounded, Assets.watch),
    ];
    final visibleCategories = _query.trim().isEmpty
        ? categories
        : categories
              .where(
                (category) =>
                    category.name.toLowerCase().contains(
                      _query.trim().toLowerCase(),
                    ) ||
                    category.count.toLowerCase().contains(
                      _query.trim().toLowerCase(),
                    ),
              )
              .toList();
    return ListView(
      padding: metrics.pageInsetsWithNav,
      children: [
        Row(
          children: [
            CircleGlassButton(
              icon: Icons.search_rounded,
              size: metrics.compact ? 42 : 46,
            ),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Categories', style: AppTheme.h2),
                ),
              ),
            ),
            CircleGlassButton(
              icon: Icons.tune_rounded,
              size: metrics.compact ? 42 : 46,
            ),
          ],
        ),
        SizedBox(height: 18),
        GlassCard(
          height: 48,
          radius: 24,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: TextField(
            key: const ValueKey('category-search-field'),
            onChanged: (value) => setState(() => _query = value),
            style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.ink),
            decoration: InputDecoration(
              icon: Icon(Icons.search_rounded, color: AppTheme.muted, size: 18),
              hintText: 'Search retro devices',
              hintStyle: AppTheme.body,
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 22),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: categoryColumns,
            childAspectRatio: metrics.categoryCardAspectRatio,
            crossAxisSpacing: metrics.gutter,
            mainAxisSpacing: metrics.gutter,
          ),
          itemBuilder: (context, index) {
            final category = visibleCategories[index];
            return OpenMotionContainer(
              radius: metrics.cardRadius,
              routeSettings: RouteSettings(
                name: '/category',
                arguments: category.name,
              ),
              openPage: CategoryDetailScreen(
                store: widget.store,
                category: category.name,
              ),
              closedBuilder: (openContainer) => LiquidPressable(
                onTap: openContainer,
                borderRadius: BorderRadius.circular(metrics.cardRadius),
                glowColor: AppTheme.blue,
                child: GlassCard(
                  padding: EdgeInsets.all(metrics.compact ? 8 : 10),
                  radius: metrics.cardRadius,
                  opacity: 0.24,
                  blur: 38,
                  borderOpacity: 0.88,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: ProductImage(
                                  asset: category.asset,
                                  width: 152,
                                  height: 122,
                                  heroTag: categoryHeroTag(category.name),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: metrics.compact ? 4 : 6),
                          Text(
                            category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.label.copyWith(color: AppTheme.red),
                          ),
                          SizedBox(height: 4),
                          Text(
                            category.count,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.body.copyWith(fontSize: 11),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryData {
  const _CategoryData(this.name, this.count, this.icon, this.asset);

  final String name;
  final String count;
  final IconData icon;
  final String asset;
}
