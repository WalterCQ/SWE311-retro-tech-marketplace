import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/image_cache.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    return GlassScaffold(
      includeSafeArea: false,
      background: const AboutBackground(),
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            metrics.pagePadding,
            metrics.topGap,
            metrics.pagePadding,
            30 + MediaQuery.viewPaddingOf(context).bottom,
          ),
          children: [
            Row(
              children: [
                AboutIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => popOrMain(context),
                ),
                const Spacer(),
                const AboutIconButton(icon: Icons.ios_share_rounded),
              ],
            ),
            SizedBox(height: metrics.compact ? 28 : 42),
            LayoutBuilder(
              builder: (context, constraints) {
                final showInlineArt = constraints.maxWidth >= 340;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: AboutHeroCopy(compact: metrics.compact)),
                    if (showInlineArt) ...[
                      SizedBox(width: metrics.gutter),
                      SizedBox(
                        width: constraints.maxWidth * 0.5,
                        height: metrics.compact ? 168 : 210,
                        child: Transform.rotate(
                          angle: 0.06981317007977318,
                          child: Image.asset(
                            Assets.glassButterfly,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            cacheWidth: imageCacheDimension(
                              context,
                              constraints.maxWidth * 0.5,
                              logicalHeight: metrics.compact ? 168 : 210,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            if (metrics.width < 340) ...[
              SizedBox(height: metrics.gutter),
              SizedBox(
                height: 190,
                child: Image.asset(
                  Assets.glassButterfly,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  cacheWidth: imageCacheDimension(context, 190),
                ),
              ),
            ],
            SizedBox(height: metrics.compact ? 30 : 42),
            Row(
              children: const [
                SmallDash(aboutRed),
                SizedBox(width: 10),
                SmallDash(aboutBlue),
              ],
            ),
            SizedBox(height: metrics.compact ? 28 : 38),
            Text.rich(
              TextSpan(
                style: AboutText.body,
                children: [
                  TextSpan(
                    text: 'RetroTech',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text:
                        ' is the go-to marketplace for collectors and enthusiasts of ',
                  ),
                  TextSpan(
                    text: 'Y2K',
                    style: TextStyle(
                      color: aboutRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' electronics. From '),
                  TextSpan(
                    text: 'classic',
                    style: TextStyle(
                      color: aboutBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' devices to rare finds, we bring the best of the past to your future.',
                  ),
                ],
              ),
            ),
            SizedBox(height: metrics.compact ? 28 : 42),
            Row(
              children: [
                AboutIconButton(
                  icon: Icons.arrow_forward_rounded,
                  color: aboutRed,
                  size: 42,
                  iconSize: 22,
                ),
                SizedBox(width: metrics.gutter),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Learn more about our ',
                          style: AboutText.ctaCopy,
                        ),
                        TextSpan(text: 'mission', style: AboutText.ctaLink),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: metrics.compact ? 32 : 44),
            Text('WHAT WE STAND FOR', style: AboutText.section),
            SizedBox(height: metrics.gutter),
            LayoutBuilder(
              builder: (context, constraints) {
                final gap = metrics.compact ? 8.0 : 10.0;
                final cardWidth = ((constraints.maxWidth - gap * 2) / 3)
                    .clamp(88.0, 116.0)
                    .toDouble();
                return Row(
                  children: [
                    ValueCard(
                      Icons.favorite_rounded,
                      'Trust & Safety',
                      'Secure payments\nand verified\nsellers.',
                      aboutRed,
                      width: cardWidth,
                      iconTop: 4,
                      titleLeft: 20,
                      titleTop: 43,
                      copyTop: 63,
                      iconSize: 18,
                    ),
                    SizedBox(width: gap),
                    ValueCard(
                      Icons.groups_rounded,
                      'Community First',
                      'Connect with\ncollectors who\nshare your passion.',
                      aboutBlue,
                      width: cardWidth,
                      iconTop: 5,
                      titleLeft: 11,
                      titleTop: 44,
                      copyTop: 65,
                      iconSize: 16,
                    ),
                    SizedBox(width: gap),
                    ValueCard(
                      Icons.eco_rounded,
                      'Sustainability',
                      'Give vintage\ntech a second\nlife together.',
                      aboutGreen,
                      width: cardWidth,
                      iconTop: 6,
                      titleLeft: 23,
                      titleTop: 47,
                      copyTop: 65,
                      iconSize: 16,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: metrics.compact ? 32 : 44),
            Text('BY THE NUMBERS', style: AboutText.section),
            SizedBox(height: metrics.gutter),
            LayoutBuilder(
              builder: (context, constraints) {
                final gap = metrics.compact ? 6.0 : 8.0;
                final numberWidth = ((constraints.maxWidth - gap * 3) / 4)
                    .clamp(64.0, 90.0)
                    .toDouble();
                return Row(
                  children: [
                    Number(
                      '10K+',
                      'Happy Buyers',
                      aboutRed,
                      width: numberWidth,
                    ),
                    SizedBox(width: gap),
                    Number(
                      '5K+',
                      'Verified Sellers',
                      aboutBlue,
                      width: numberWidth,
                    ),
                    SizedBox(width: gap),
                    Number(
                      '50K+',
                      'Products Sold',
                      aboutGreen,
                      width: numberWidth,
                    ),
                    SizedBox(width: gap),
                    Number(
                      '100+',
                      'Countries',
                      aboutViolet,
                      width: numberWidth,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: metrics.compact ? 28 : 36),
            const AboutNewsCard(),
          ],
        ),
      ),
    );
  }
}

class AboutHeroCopy extends StatelessWidget {
  const AboutHeroCopy({super.key, required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final heroStyle = AboutText.hero.copyWith(fontSize: compact ? 26 : 28);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ABOUT US', style: AboutText.eyebrow),
        SizedBox(height: compact ? 18 : 22),
        Text('More than', style: heroStyle),
        RichText(
          text: TextSpan(
            style: heroStyle,
            children: [
              TextSpan(text: 'a '),
              TextSpan(
                text: 'Marketplace',
                style: TextStyle(color: aboutRed),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  child: SizedBox(
                    width: 8,
                    height: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: aboutRed),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? 16 : 20),
        Text(
          'A community built on trust, passion, and nostalgia.',
          style: AboutText.subcopy.copyWith(fontSize: compact ? 16 : 17),
        ),
      ],
    );
  }
}

const aboutInk = Color(0xFF080A0F);
const aboutMuted = Color(0xFF5C637A);
const aboutEyebrow = Color(0xFF4791DB);
const aboutBlue = Color(0xFF0573FF);
const aboutRed = Color(0xFFFF080F);
const aboutGreen = Color(0xFF0DB238);
const aboutViolet = Color(0xFF7338F2);

class AboutText {
  static const baseFont = 'Inter';

  static const eyebrow = TextStyle(
    fontFamily: baseFont,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: aboutEyebrow,
  );

  static const hero = TextStyle(
    fontFamily: baseFont,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: aboutInk,
  );

  static const subcopy = TextStyle(
    fontFamily: baseFont,
    fontSize: 17,
    height: 24 / 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: aboutMuted,
  );

  static const body = TextStyle(
    fontFamily: baseFont,
    fontSize: 17,
    height: 25 / 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: aboutInk,
  );

  static const ctaCopy = TextStyle(
    fontFamily: baseFont,
    fontSize: 12,
    height: 15 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: aboutMuted,
  );

  static const ctaLink = TextStyle(
    fontFamily: baseFont,
    fontSize: 12,
    height: 15 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: aboutBlue,
  );

  static const section = TextStyle(
    fontFamily: baseFont,
    fontSize: 10,
    height: 13 / 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: aboutEyebrow,
  );

  static const valueTitle = TextStyle(
    fontFamily: baseFont,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const valueCopy = TextStyle(
    fontFamily: baseFont,
    fontSize: 9,
    height: 12 / 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: aboutMuted,
  );

  static const metric = TextStyle(
    fontFamily: baseFont,
    fontSize: 22,
    height: 26 / 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static const metricLabel = TextStyle(
    fontFamily: baseFont,
    fontSize: 9,
    height: 11 / 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: aboutMuted,
  );

  static const newsEyebrow = TextStyle(
    fontFamily: baseFont,
    fontSize: 9,
    height: 11 / 9,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: aboutBlue,
  );

  static const newsTitle = TextStyle(
    fontFamily: baseFont,
    fontSize: 11,
    height: 13 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: aboutInk,
  );

  static const newsCopy = TextStyle(
    fontFamily: baseFont,
    fontSize: 9,
    height: 11 / 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: aboutMuted,
  );
}

class AboutBackground extends StatelessWidget {
  const AboutBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Image.asset(
            Assets.background,
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
            filterQuality: FilterQuality.high,
            cacheWidth: imageCacheDimension(
              context,
              constraints.maxWidth,
              logicalHeight: constraints.maxHeight,
            ),
          );
        },
      ),
    );
  }
}

class AboutGlassSurface extends StatelessWidget {
  const AboutGlassSurface({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    required this.radius,
    this.opacity = 0.66,
  });

  final Widget child;
  final double width;
  final double height;
  final double radius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final glassSheen = opacity.clamp(0.08, 0.22).toDouble();
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: glassSheen * 1.45),
            offset: Offset(-2, -2),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFF1A2942).withValues(alpha: 0.1),
            offset: Offset(0, 16),
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: maxGlassBlur, sigmaY: maxGlassBlur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.94),
                width: 1.1,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AboutIconButton extends StatelessWidget {
  const AboutIconButton({
    super.key,
    required this.icon,
    this.color = aboutInk,
    this.onTap,
    this.size = 44,
    this.iconSize,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: LiquidPressable(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(size / 2),
        glowColor: color,
        child: AboutGlassSurface(
          width: size,
          height: size,
          radius: size / 2,
          child: Icon(icon, color: color, size: iconSize ?? size * 0.54),
        ),
      ),
    );
  }
}

class SmallDash extends StatelessWidget {
  const SmallDash(this.color, {super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class ValueCard extends StatelessWidget {
  const ValueCard(
    this.icon,
    this.title,
    this.text,
    this.color, {
    super.key,
    required this.width,
    required this.iconTop,
    required this.titleLeft,
    required this.titleTop,
    required this.copyTop,
    required this.iconSize,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;
  final double width;
  final double iconTop;
  final double titleLeft;
  final double titleTop;
  final double copyTop;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final height = (112 * (width / 116)).clamp(92.0, 112.0).toDouble();
    return LiquidPressable(
      onTap: () {},
      borderRadius: BorderRadius.circular(18),
      glowColor: color,
      child: AboutGlassSurface(
        width: width,
        height: height,
        radius: 18 * (width / 116).clamp(0.82, 1),
        opacity: 0.52,
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 116,
              height: 112,
              child: Stack(
                children: [
                  Positioned(
                    left: 40,
                    top: iconTop,
                    child: AboutGlassSurface(
                      width: 34,
                      height: 34,
                      radius: 17,
                      child: Icon(icon, color: color, size: iconSize),
                    ),
                  ),
                  Positioned(
                    left: titleLeft,
                    top: titleTop,
                    width: 92,
                    child: Text(
                      title,
                      style: AboutText.valueTitle.copyWith(color: color),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: copyTop,
                    width: 92,
                    child: Text(
                      text,
                      style: AboutText.valueCopy,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Number extends StatelessWidget {
  const Number(
    this.value,
    this.label,
    this.color, {
    super.key,
    required this.width,
  });

  final String value;
  final String label;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 43,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 90,
          height: 43,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: 80,
                child: Text(
                  value,
                  style: AboutText.metric.copyWith(color: color),
                ),
              ),
              Positioned(
                left: 0,
                top: 28,
                width: 90,
                child: Text(label, style: AboutText.metricLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutNewsCard extends StatelessWidget {
  const AboutNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 340;
        return LiquidPressable(
          onTap: () {},
          borderRadius: BorderRadius.circular(30),
          glowColor: aboutRed,
          child: AboutGlassSurface(
            width: constraints.maxWidth,
            height: compact ? 78 : 64,
            radius: 30,
            opacity: 0.58,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(31),
                  child: Image.asset(
                    Assets.latestNewsThumbnail,
                    width: compact ? 76 : 93,
                    height: compact ? 78 : 64,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    cacheWidth: imageCacheDimension(context, compact ? 76 : 93),
                    errorBuilder: (context, error, stackTrace) => ProductImage(
                      asset: Assets.gameboy,
                      width: compact ? 76 : 93,
                      height: compact ? 78 : 64,
                    ),
                  ),
                ),
                SizedBox(width: compact ? 12 : 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LATEST NEWS', style: AboutText.newsEyebrow),
                      SizedBox(height: compact ? 3 : 4),
                      Text(
                        'New Arrivals: Transparent Tech',
                        style: AboutText.newsTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: compact ? 2 : 3),
                      Text(
                        'Explore rare transparent gadgets',
                        style: AboutText.newsCopy,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: compact ? 8 : 12),
                  child: AboutIconButton(
                    icon: Icons.arrow_forward_rounded,
                    color: aboutRed,
                    size: 38,
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
