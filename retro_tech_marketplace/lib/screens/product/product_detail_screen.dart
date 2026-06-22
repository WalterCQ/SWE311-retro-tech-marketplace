import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/listing_store.dart';
import '../../store/seed_data.dart';
import '../../widgets/aero_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';
import '../home/home_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.store, this.listing});

  final ListingStore store;
  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    final fallbackItem = seedListings.firstWhere(
      (item) => item.id == 'ipod-classic',
    );
    final item =
        listing ??
        store.byId('ipod-classic') ??
        (store.listings.isNotEmpty ? store.listings.first : fallbackItem);
    return GlassScaffold(
      includeSafeArea: false,
      background: const DetailAeroBackground(),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = ResponsiveMetrics.of(context);
            final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
            return Stack(
              children: [
                ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    metrics.pagePadding,
                    metrics.topGap,
                    metrics.pagePadding,
                    104 + bottomPadding,
                  ),
                  children: [
                    Row(
                      children: [
                        CircleGlassButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          size: 44,
                          onTap: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        CircleGlassButton(
                          icon: Icons.ios_share_rounded,
                          size: 44,
                        ),
                        SizedBox(width: metrics.compact ? 10 : 14),
                        const FavoriteButton(size: 44),
                      ],
                    ),
                    SizedBox(height: metrics.compact ? 14 : 22),
                    ProductGallery(
                      item: item,
                      height: metrics.detailImageHeight,
                      width: constraints.maxWidth - metrics.pagePadding * 2,
                    ),
                    SizedBox(height: metrics.compact ? 14 : 20),
                    ProductDetailPanel(item: item),
                  ],
                ),
                Positioned(
                  left: metrics.pagePadding + 10,
                  right: metrics.pagePadding + 10,
                  bottom: 10 + bottomPadding,
                  child: LiquidButton(
                    label: 'Contact Seller',
                    icon: Icons.chat_bubble_outline_rounded,
                    height: metrics.compact ? 54 : 60,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/chat', arguments: item),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProductGallery extends StatefulWidget {
  const ProductGallery({
    super.key,
    required this.item,
    required this.height,
    required this.width,
  });

  final Listing item;
  final double height;
  final double width;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  late final PageController _controller;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void didUpdateWidget(ProductGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    final imageCount = widget.item.detailImageAssets.length;
    if (_activeIndex >= imageCount) {
      _activeIndex = 0;
      _controller.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.item.detailImageAssets;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
            height: widget.height,
            width: widget.width,
            child: PageView.builder(
              key: const ValueKey('product-gallery-page-view'),
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              itemCount: images.length,
              onPageChanged: (index) => setState(() => _activeIndex = index),
              itemBuilder: (context, index) {
                return FittedBox(
                  fit: BoxFit.contain,
                  child: ProductImage(
                    asset: images[index],
                    width: 316,
                    height: 413,
                    heroTag: index == _activeIndex
                        ? listingHeroTag(widget.item)
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: ResponsiveMetrics.of(context).compact ? 8 : 14),
        Center(
          child: Dots(
            count: images.length,
            activeIndex: _activeIndex,
            keyPrefix: 'product-gallery',
            onSelected: (index) => _controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
      ],
    );
  }
}

class ProductDetailPanel extends StatelessWidget {
  const ProductDetailPanel({super.key, required this.item});

  final Listing item;

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    return GlassCard(
      padding: EdgeInsets.all(metrics.compact ? 18 : 22),
      radius: metrics.cardRadius,
      opacity: 0.42,
      blur: 30,
      borderOpacity: 0.82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('FEATURED', style: AppTheme.label),
              const Spacer(),
              Text(
                item.priceLabel,
                style: AppTheme.label.copyWith(
                  color: AppTheme.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: metrics.compact ? 14 : 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: AppTheme.h1.copyWith(
                      fontSize: metrics.compact ? 22 : 25,
                      height: 1.08,
                    ),
                    children: [
                      TextSpan(text: '${item.title}\n'),
                      TextSpan(
                        text: item.subtitle,
                        style: TextStyle(color: AppTheme.red),
                      ),
                      accentSquare(size: 8),
                    ],
                  ),
                ),
              ),
              SizedBox(width: metrics.gutter),
              CircleGlassButton(
                icon: Icons.shopping_cart_outlined,
                color: AppTheme.blue,
                size: metrics.compact ? 42 : 46,
              ),
            ],
          ),
          SizedBox(height: metrics.compact ? 14 : 18),
          Text(
            item.description,
            style: AppTheme.body.copyWith(fontSize: 12, height: 1.5),
          ),
          SizedBox(height: metrics.compact ? 16 : 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 360 ? 2 : 4;
              const spacing = 10.0;
              final chipWidth =
                  (constraints.maxWidth - (columns - 1) * spacing) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: chipWidth,
                    child: SpecChip(
                      Icons.sd_storage_rounded,
                      item.storage,
                      'Storage',
                    ),
                  ),
                  SizedBox(
                    width: chipWidth,
                    child: SpecChip(
                      Icons.battery_full_rounded,
                      item.battery,
                      'Battery Life',
                    ),
                  ),
                  SizedBox(
                    width: chipWidth,
                    child: SpecChip(Icons.music_note_rounded, '10K+', 'Songs'),
                  ),
                  SizedBox(
                    width: chipWidth,
                    child: SpecChip(
                      Icons.settings_input_component_rounded,
                      item.connector,
                      'Connector',
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: metrics.compact ? 18 : 22),
          Divider(height: 1, color: AppTheme.line),
          SizedBox(height: metrics.compact ? 16 : 18),
          Text('Seller', style: AppTheme.h2.copyWith(fontSize: 15)),
          SizedBox(height: metrics.compact ? 10 : 12),
          Row(
            children: [
              LogoMark(size: 43, heroTag: sellerLogoHeroTag),
              SizedBox(width: metrics.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.seller,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.h2.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${item.rating} ★  (${item.reviews})',
                      style: AppTheme.label.copyWith(fontSize: 13),
                    ),
                    Text(
                      'Active today',
                      style: AppTheme.body.copyWith(fontSize: 11, height: 1.1),
                    ),
                  ],
                ),
              ),
              CircleGlassButton(
                icon: Icons.more_horiz_rounded,
                size: 42,
                onTap: () => Navigator.pushNamed(context, '/seller'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Dots extends StatelessWidget {
  const Dots({
    super.key,
    this.count = 4,
    this.activeIndex = 0,
    this.onSelected,
    this.keyPrefix,
  });

  final int count;
  final int activeIndex;
  final ValueChanged<int>? onSelected;
  final String? keyPrefix;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final active = index == activeIndex;
        final indicator = AnimatedContainer(
          key: keyPrefix == null ? null : ValueKey('$keyPrefix-dot-$index'),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: active ? 20 : 8,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: active ? AppTheme.red : AppTheme.line,
          ),
        );
        if (onSelected == null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: indicator,
          );
        }
        return Semantics(
          button: true,
          selected: active,
          label: 'Show product image ${index + 1}',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelected!(index),
            child: SizedBox(
              width: 28,
              height: 22,
              child: Center(child: indicator),
            ),
          ),
        );
      }),
    );
  }
}

class SpecChip extends StatelessWidget {
  const SpecChip(this.icon, this.value, this.label, {super.key});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: GlassCard(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        radius: 16,
        opacity: 0.5,
        blur: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 17, color: AppTheme.ink),
            SizedBox(width: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: AppTheme.body.copyWith(fontSize: 8, height: 1.1),
                    ),
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
