import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';
import '../product/product_detail_screen.dart';
import '../profile/account_profile_screen.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({this.size = 42});

  final double size;

  @override
  State<FavoriteButton> createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  bool _favorite = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: LiquidPressable(
        onTap: () => setState(() => _favorite = !_favorite),
        borderRadius: BorderRadius.circular(widget.size / 2),
        glowColor: AppTheme.red,
        active: _favorite,
        pressedScale: 0.94,
        child: GlassCard(
          width: widget.size,
          height: widget.size,
          radius: widget.size / 2,
          padding: EdgeInsets.zero,
          opacity: _favorite ? 0.72 : 0.62,
          child: Icon(
            _favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: AppTheme.red,
            size: widget.size * 0.45,
          ),
        ),
      ),
    );
  }
}

class HomeListingCard extends StatelessWidget {
  const HomeListingCard({
    required this.listing,
    this.onTap,
    this.heroTag,
    this.margin,
  });

  final Listing listing;
  final VoidCallback? onTap;
  final Object? heroTag;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    final isMotorola = listing.id == 'motorola-v60';
    final isIpod = listing.id == 'ipod-classic';
    final bodyCopy = isMotorola
        ? 'Legendary flip.\nTimeless design.'
        : isIpod
        ? '1,000 songs.\nZero skips.'
        : 'Portable audio.\nCrystal shell.';
    final imageWidth = isMotorola
        ? 176.0
        : isIpod
        ? 150.0
        : 167.0;
    final imageHeight = isMotorola
        ? 264.0
        : isIpod
        ? 225.0
        : 115.0;
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: metrics.gutter + 2),
      child: LiquidPressable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(metrics.cardRadius),
        glowColor: AppTheme.red,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardHeight = metrics.homeCardHeight;
            final compact = constraints.maxWidth < 340;
            final buttonSize = compact ? 32.0 : 36.0;
            return GlassCard(
              padding: EdgeInsets.fromLTRB(
                compact ? 16 : 20,
                compact ? 14 : 16,
                compact ? 12 : 14,
                compact ? 14 : 18,
              ),
              radius: metrics.cardRadius,
              opacity: 0.22,
              blur: 42,
              borderOpacity: 0.9,
              child: SizedBox(
                height: cardHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: compact ? 5 : 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.status,
                            style: AppTheme.label.copyWith(fontSize: 12),
                          ),
                          SizedBox(height: compact ? 7 : 9),
                          Text.rich(
                            TextSpan(
                              style: AppTheme.h2.copyWith(
                                fontSize: compact ? 20 : 23,
                                height: 1.05,
                              ),
                              children: [
                                TextSpan(
                                  text: isMotorola
                                      ? 'Motorola\n'
                                      : '${listing.title}\n',
                                ),
                                TextSpan(
                                  text: isIpod ? '4th Gen ' : listing.subtitle,
                                ),
                                accentSquare(size: 8),
                              ],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: compact ? 10 : 13),
                          Text(
                            bodyCopy,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.body.copyWith(
                              fontSize: compact ? 12 : 13,
                              height: 1.28,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            listing.priceLabel,
                            style: TextStyle(
                              color: AppTheme.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: compact ? 4 : 6),
                    Expanded(
                      flex: compact ? 5 : 6,
                      child: Column(
                        children: [
                          Expanded(
                            child: Transform.scale(
                              scale: compact ? 1.12 : 1.16,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: ProductImage(
                                  asset: listing.imageAsset,
                                  width: imageWidth,
                                  height: imageHeight,
                                  heroTag: heroTag,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: compact ? 4 : 6),
                          const Dots(),
                        ],
                      ),
                    ),
                    SizedBox(width: compact ? 4 : 6),
                    SizedBox(
                      width: buttonSize,
                      child: Column(
                        children: [
                          FavoriteButton(size: buttonSize),
                          SizedBox(height: compact ? 7 : 9),
                          CircleGlassButton(
                            icon: Icons.shopping_cart_outlined,
                            color: AppTheme.blue,
                            size: buttonSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final ListingStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final metrics = ResponsiveMetrics.of(context);
        return ListView(
          padding: metrics.pageInsetsWithNav,
          children: [
            Row(
              children: [
                CircleGlassImageButton(
                  asset: Assets.homeAvatar,
                  onTap: () => Navigator.pushNamed(context, '/seller'),
                ),
                SizedBox(width: metrics.compact ? 12 : 18),
                Expanded(
                  child: GlassCard(
                    height: 48,
                    radius: 26,
                    padding: EdgeInsets.all(5),
                    child: HomeSegmentControl(
                      value: _segment,
                      onChanged: (value) {
                        if (_segment == value) return;
                        setState(() => _segment = value);
                      },
                    ),
                  ),
                ),
                SizedBox(width: metrics.compact ? 12 : 18),
                CircleGlassButton(icon: Icons.search_rounded),
              ],
            ),
            SizedBox(height: metrics.compact ? 20 : 28),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                reverseDuration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final fromRight = (child.key as ValueKey<int>).value == 1;
                  final offset = Tween<Offset>(
                    begin: Offset(fromRight ? 0.055 : -0.055, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: offset, child: child),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(_segment),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _segment == 0
                        ? _marketContent(context)
                        : _communityContent(context),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _marketContent(BuildContext context) {
    final listings = widget.store.listings;
    return [
      RichText(
        text: TextSpan(
          style: AppTheme.hero,
          children: [
            TextSpan(text: 'Rediscover\n'),
            TextSpan(
              text: 'Iconic',
              style: TextStyle(color: AppTheme.red),
            ),
            accentSquare(size: 13, gap: 7),
          ],
        ),
      ),
      SizedBox(height: 12),
      Text(
        'Buy, sell, and collect authentic\nY2K electronics.',
        style: AppTheme.body.copyWith(fontSize: 18),
      ),
      SizedBox(height: 22),
      Row(
        children: [
          SolidCircleButton(
            icon: Icons.north_east_rounded,
            onTap: () =>
                Navigator.pushNamed(context, '/category', arguments: 'Audio'),
          ),
          SizedBox(width: 14),
          Text(
            'Explore\nCollection',
            style: AppTheme.h2.copyWith(fontSize: 16),
          ),
        ],
      ),
      SizedBox(height: 22),
      ...listings.take(3).map((listing) {
        return ListingCard(
          listing: listing,
          large: true,
          openStore: widget.store,
          onTap: () =>
              Navigator.pushNamed(context, '/product', arguments: listing),
        );
      }),
    ];
  }

  List<Widget> _communityContent(BuildContext context) {
    return [
      Text('Community', style: AppTheme.hero.copyWith(fontSize: 44)),
      SizedBox(height: 10),
      Text(
        'Collectors, restorers, and transparent tech fans share finds here.',
        style: AppTheme.body,
      ),
      SizedBox(height: 22),
      CommunityPostCard(
        user: 'VintageAudioCo',
        time: '18m',
        text: 'I can include the original earbuds for the Walkman bundle.',
        asset: Assets.avatarVintage,
      ),
      CommunityPostCard(
        user: 'PalmPilotFan',
        time: '1h',
        text:
            'Battery holds charge well. Ask for more photos before buying rare PDAs.',
        asset: Assets.avatarPalm,
      ),
      CommunityPostCard(
        user: 'PixelCam Studio',
        time: 'Yesterday',
        text:
            'Transparent tech photographs best against high-key white backgrounds.',
        asset: Assets.avatarPixel,
      ),
    ];
  }
}

class HomeSegmentControl extends StatelessWidget {
  const HomeSegmentControl({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            alignment: value == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white.withValues(alpha: 0.82),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.red.withValues(alpha: 0.14),
                      offset: Offset(0, 7),
                      blurRadius: 15,
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.54),
                      offset: Offset(-2, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            SegmentPill('Market', value == 0, () => onChanged(0)),
            SegmentPill('Community', value == 1, () => onChanged(1)),
          ],
        ),
      ],
    );
  }
}

class SegmentPill extends StatelessWidget {
  const SegmentPill(this.label, this.active, this.onTap);

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LiquidPressable(
        onTap: onTap,
        active: active,
        borderRadius: BorderRadius.circular(24),
        glowColor: AppTheme.red,
        pressedScale: 0.96,
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: active ? AppTheme.red : AppTheme.muted,
          ),
          child: Center(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    );
  }
}

class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.openStore,
    this.large = false,
  });

  final Listing listing;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ListingStore? openStore;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    final hasActions = onEdit != null || onDelete != null;
    final heroTag = listingHeroTag(listing);

    Widget buildCard(VoidCallback? tap, {EdgeInsetsGeometry? margin}) {
      if (!hasActions) {
        return HomeListingCard(
          listing: listing,
          onTap: tap,
          heroTag: heroTag,
          margin: margin,
        );
      }
      final imageWidth = 172.0;
      final imageHeight = 184.0;
      final detailsColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(listing.status.toUpperCase(), style: AppTheme.label),
          SizedBox(height: 8),
          Text(
            listing.shortTitle,
            style: AppTheme.h2.copyWith(fontSize: large ? 25 : 19),
          ),
          SizedBox(height: 8),
          Text(listing.condition, style: AppTheme.body),
          SizedBox(height: 18),
          Text(
            listing.priceLabel,
            style: TextStyle(
              color: AppTheme.red,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          if (!large) ...[
            SizedBox(height: 4),
            Text(
              '${listing.views} views',
              style: AppTheme.body.copyWith(fontSize: 11),
            ),
          ],
        ],
      );

      return LiquidPressable(
        onTap: tap,
        borderRadius: BorderRadius.circular(metrics.cardRadius),
        glowColor: AppTheme.blue,
        child: GlassCard(
          margin: margin ?? EdgeInsets.only(bottom: metrics.gutter + 2),
          padding: EdgeInsets.fromLTRB(20, 16, 14, 18),
          radius: metrics.cardRadius,
          opacity: 0.22,
          blur: 42,
          borderOpacity: 0.9,
          child: SizedBox(
            height: metrics.listingActionCardHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: metrics.compact ? 5 : 4, child: detailsColumn),
                SizedBox(width: metrics.compact ? 4 : 6),
                Expanded(
                  flex: metrics.compact ? 5 : 6,
                  child: Transform.scale(
                    scale: metrics.compact ? 1.1 : 1.14,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: ProductImage(
                        asset: listing.imageAsset,
                        width: imageWidth,
                        height: imageHeight,
                        heroTag: heroTag,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: metrics.compact ? 4 : 6),
                SizedBox(
                  width: 38,
                  child: Column(
                    children: [
                      CircleGlassButton(
                        icon: Icons.edit_rounded,
                        color: AppTheme.blue,
                        size: 38,
                        onTap: onEdit,
                      ),
                      SizedBox(height: 10),
                      CircleGlassButton(
                        icon: Icons.delete_outline_rounded,
                        color: AppTheme.red,
                        size: 38,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final store = openStore;
    if (store == null) return buildCard(onTap);

    return Container(
      margin: EdgeInsets.only(bottom: metrics.gutter + 2),
      child: OpenMotionContainer(
        radius: metrics.cardRadius,
        routeSettings: RouteSettings(name: '/product', arguments: listing),
        openPage: ProductDetailScreen(store: store, listing: listing),
        closedBuilder: (openContainer) =>
            buildCard(openContainer, margin: EdgeInsets.zero),
      ),
    );
  }
}
