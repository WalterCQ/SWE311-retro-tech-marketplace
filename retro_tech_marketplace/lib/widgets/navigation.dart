import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import '../constants/assets.dart';
import '../constants/theme.dart';
import '../models/listing.dart';
import 'liquid_button.dart';
import 'glass_card.dart';

void popOrMain(BuildContext context) {
  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
    return;
  }
  navigator.pushReplacementNamed('/main');
}

String listingHeroTag(Listing listing) => 'listing-image-${listing.id}';

String categoryHeroTag(String category) => 'category-image-$category';

String categoryAssetFor(String category) {
  return switch (category.toLowerCase()) {
    'phones' => Assets.v60,
    'audio' => Assets.discmanHome,
    'gaming' => Assets.gameboy,
    'cameras' => Assets.camera,
    'computing' => Assets.imac,
    'wearables' => Assets.watch,
    _ => Assets.discmanHome,
  };
}

class OpenMotionContainer extends StatelessWidget {
  const OpenMotionContainer({
    required this.openPage,
    required this.closedBuilder,
    required this.radius,
    this.routeSettings,
  });

  final Widget openPage;
  final Widget Function(VoidCallback openContainer) closedBuilder;
  final double radius;
  final RouteSettings? routeSettings;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<void>(
      tappable: false,
      transitionDuration: const Duration(milliseconds: 520),
      transitionType: ContainerTransitionType.fadeThrough,
      closedColor: Colors.transparent,
      middleColor: Colors.white.withValues(alpha: 0.52),
      openColor: AppTheme.bg,
      closedElevation: 0,
      openElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      openShape: const RoundedRectangleBorder(),
      routeSettings: routeSettings,
      closedBuilder: (context, openContainer) => closedBuilder(openContainer),
      openBuilder: (context, closeContainer) => openPage,
    );
  }
}

class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final activeRealIndex = currentIndex >= 2 ? currentIndex + 1 : currentIndex;
    final metrics = ResponsiveMetrics.of(context);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final barHeight = metrics.compact ? 62.0 : 66.0;
    final addLift = metrics.compact ? 10.0 : 12.0;
    final addSize = metrics.compact ? 60.0 : 64.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        metrics.pagePadding,
        0,
        metrics.pagePadding,
        bottomInset + 8,
      ),
      child: SizedBox(
        height: barHeight + addLift,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GlassCard(
                height: barHeight,
                radius: 32,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                opacity: 0.62,
                child: Row(
                  children: [
                    Expanded(
                      child: NavItem(
                        Icons.home_rounded,
                        'Home',
                        activeRealIndex == 0,
                        () => onTap(0),
                      ),
                    ),
                    Expanded(
                      child: NavItem(
                        Icons.grid_view_rounded,
                        'Categories',
                        activeRealIndex == 1,
                        () => onTap(1),
                      ),
                    ),
                    const Expanded(child: SizedBox.expand()),
                    Expanded(
                      child: NavItem(
                        Icons.chat_bubble_outline_rounded,
                        'Inbox',
                        activeRealIndex == 3,
                        () => onTap(3),
                      ),
                    ),
                    Expanded(
                      child: NavItem(
                        Icons.person_outline_rounded,
                        'Profile',
                        activeRealIndex == 4,
                        () => onTap(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: LiquidPressable(
                  onTap: () => onTap(2),
                  borderRadius: BorderRadius.circular(addSize / 2),
                  glowColor: AppTheme.red,
                  pressedScale: 0.94,
                  child: Container(
                    width: addSize,
                    height: addSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.88),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.96),
                        width: 1.1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF1A2942).withValues(alpha: 0.1),
                          offset: Offset(0, 14),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: AppTheme.red,
                      size: metrics.compact ? 34 : 36,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem(this.icon, this.label, this.active, this.onTap);

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compact = ResponsiveMetrics.of(context).compact;
    return LiquidPressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      glowColor: AppTheme.red,
      pressedScale: 0.94,
      child: SizedBox.expand(
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: compact ? 54 : 60,
              height: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: active ? AppTheme.red : AppTheme.ink,
                    size: compact ? 20 : 21,
                  ),
                  SizedBox(height: compact ? 4 : 5),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: compact ? 9 : 10,
                      fontWeight: FontWeight.w800,
                      color: active ? AppTheme.red : AppTheme.ink,
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

class TopBar extends StatelessWidget {
  const TopBar({required this.title, this.trailing, this.onTrailingTap});

  final String title;
  final IconData? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleGlassButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTheme.h2.copyWith(fontSize: 18),
          ),
        ),
        CircleGlassButton(
          icon: trailing ?? Icons.more_horiz_rounded,
          onTap: onTrailingTap,
        ),
      ],
    );
  }
}
