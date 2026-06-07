import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/assets.dart';
import '../constants/theme.dart';

class AeroBackground extends StatelessWidget {
  const AeroBackground({
    super.key,
    this.asset = Assets.background,
    this.includeOverlay = true,
  });

  final String asset;
  final bool includeOverlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          asset,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          filterQuality: FilterQuality.high,
        ),
        if (includeOverlay) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withValues(alpha: 0.24),
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.02),
                ],
                stops: const [0, 0.42, 1],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0),
                      Colors.white.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class DetailAeroBackground extends StatelessWidget {
  const DetailAeroBackground({super.key, this.asset = Assets.detailBackground});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heroHeight = (constraints.maxHeight * 0.5)
            .clamp(448.0, 478.0)
            .toDouble();
        final imageWidth = constraints.maxWidth * 1.1364;
        final imageHeight = heroHeight * 1.8578;
        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppTheme.detailBg),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: heroHeight,
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned(
                      left: constraints.maxWidth - imageWidth,
                      top: 0,
                      width: imageWidth,
                      height: imageHeight,
                      child: Image.asset(
                        asset,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppTheme.detailBg,
                              AppTheme.detailBg.withValues(alpha: 0.45),
                              AppTheme.detailBg.withValues(alpha: 0),
                            ],
                            stops: const [0, 0.1, 0.24],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

