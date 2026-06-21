import 'package:flutter/material.dart';
import '../constants/assets.dart';
import '../constants/theme.dart';
import 'glass_card.dart';
import 'image_cache.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 88, this.heroTag});

  final double size;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final mark = GlassCard(
      width: size,
      height: size,
      radius: size * 0.25,
      padding: EdgeInsets.all(size * 0.06),
      opacity: 0.46,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.asset(
          Assets.logoMark,
          fit: BoxFit.cover,
          cacheWidth: imageCacheDimension(context, size),
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.devices_rounded, color: AppTheme.blue),
        ),
      ),
    );
    final tag = heroTag;
    if (tag == null) return mark;
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      createRectTween: (begin, end) =>
          MaterialRectArcTween(begin: begin, end: end),
      flightShuttleBuilder:
          (context, animation, direction, fromHeroContext, toHeroContext) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
              reverseCurve: Curves.easeInOutCubic,
            );
            final child = direction == HeroFlightDirection.push
                ? toHeroContext.widget
                : fromHeroContext.widget;
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween(begin: 0.96, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
      child: mark,
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.asset,
    this.width = 124,
    this.height = 124,
    this.fit = BoxFit.contain,
    this.heroTag,
  });

  final String asset;
  final double width;
  final double height;
  final BoxFit fit;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: imageCacheDimension(context, width, logicalHeight: height),
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.devices_rounded, size: width * 0.56),
    );
    final tag = heroTag;
    if (tag == null) return image;
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      createRectTween: (begin, end) =>
          MaterialRectArcTween(begin: begin, end: end),
      flightShuttleBuilder:
          (context, animation, direction, fromHeroContext, toHeroContext) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
              reverseCurve: Curves.easeInOutCubic,
            );
            final child = direction == HeroFlightDirection.push
                ? toHeroContext.widget
                : fromHeroContext.widget;
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween(begin: 0.96, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
      child: image,
    );
  }
}

InlineSpan accentSquare({required double size, double gap = 5}) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: Padding(
      padding: EdgeInsets.only(left: gap),
      child: AccentSquare(size: size),
    ),
  );
}

class AccentSquare extends StatelessWidget {
  const AccentSquare({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const ColoredBox(color: AppTheme.red),
    );
  }
}
