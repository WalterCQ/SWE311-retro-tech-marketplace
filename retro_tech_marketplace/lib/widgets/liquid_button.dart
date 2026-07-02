import 'package:flutter/material.dart';
import '../constants/theme.dart';
import 'glass_card.dart';
import 'image_cache.dart';

class LiquidPressable extends StatefulWidget {
  const LiquidPressable({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.glowColor = AppTheme.blue,
    this.active = false,
    this.pressedScale = 0.975,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadiusGeometry borderRadius;
  final Color glowColor;
  final bool active;
  final double pressedScale;

  @override
  State<LiquidPressable> createState() => LiquidPressableState();
}

class LiquidPressableState extends State<LiquidPressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final glowing = enabled && (_pressed || widget.active);
    final overlayOpacity = _pressed ? 0.9 : (widget.active ? 0.55 : 0.0);
    final borderRadius = widget.borderRadius;

    return MouseRegion(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        child: AnimatedScale(
          scale: _pressed ? widget.pressedScale : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: glowing
                  ? [
                      BoxShadow(
                        color: widget.glowColor.withValues(
                          alpha: _pressed ? 0.34 : 0.2,
                        ),
                        blurRadius: _pressed ? 26 : 18,
                        spreadRadius: _pressed ? 1.5 : 0,
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(
                          alpha: _pressed ? 0.46 : 0.22,
                        ),
                        offset: const Offset(-2, -2),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                widget.child,
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutCubic,
                      opacity: overlayOpacity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.82),
                            width: 1.3,
                          ),
                          gradient: RadialGradient(
                            center: Alignment.topLeft,
                            radius: 1.15,
                            colors: [
                              Colors.white.withValues(alpha: 0.42),
                              widget.glowColor.withValues(alpha: 0.16),
                              Colors.transparent,
                            ],
                            stops: const [0, 0.42, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LiquidButton extends StatelessWidget {
  const LiquidButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 58,
    this.color = AppTheme.red,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;
    final compact = height < 54;
    final iconSize = height - (compact ? 16 : 14);

    return LiquidPressable(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      glowColor: color,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.92), color],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.34),
              offset: Offset(0, 10),
              blurRadius: 24,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.white.withValues(alpha: 0.28),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final rawMaxLabelWidth = hasIcon
                      ? constraints.maxWidth -
                            2 * (8 + iconSize + (compact ? 8 : 10))
                      : constraints.maxWidth - 44;
                  final maxLabelWidth = rawMaxLabelWidth
                      .clamp(24.0, constraints.maxWidth)
                      .toDouble();

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxLabelWidth),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: compact ? 14 : 17,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (hasIcon)
              Positioned(
                right: 8,
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.78),
                      width: 1.2,
                    ),
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: compact ? 18 : 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CircleGlassButton extends StatelessWidget {
  const CircleGlassButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color = AppTheme.ink,
    this.size = 46,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: LiquidPressable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        glowColor: color,
        child: GlassCard(
          width: size,
          height: size,
          radius: size / 2,
          padding: EdgeInsets.zero,
          opacity: 0.62,
          child: Icon(icon, color: color, size: size * 0.45),
        ),
      ),
    );
  }
}

class CircleGlassImageButton extends StatelessWidget {
  const CircleGlassImageButton({
    super.key,
    required this.asset,
    this.onTap,
    this.size = 46,
  });

  final String asset;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return LiquidPressable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      glowColor: AppTheme.blue,
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        cacheWidth: imageCacheDimension(context, size),
        errorBuilder: (context, error, stackTrace) => CircleGlassButton(
          icon: Icons.person_rounded,
          color: AppTheme.muted,
          size: size,
        ),
      ),
    );
  }
}

class SolidCircleButton extends StatelessWidget {
  const SolidCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 56,
    this.color = AppTheme.red,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: LiquidPressable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        glowColor: color,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withValues(alpha: 0.92), color],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                offset: Offset(0, 10),
                blurRadius: 22,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.42),
        ),
      ),
    );
  }
}

class FilterPill extends StatelessWidget {
  const FilterPill(this.label, this.active, {super.key, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: LiquidPressable(
        onTap: onTap ?? () {},
        active: active,
        borderRadius: BorderRadius.circular(999),
        glowColor: active ? AppTheme.red : AppTheme.blue,
        pressedScale: 0.95,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: active ? AppTheme.red : Colors.white.withValues(alpha: 0.58),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : AppTheme.muted,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
