import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../constants/assets.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/seed_data.dart';
import '../../widgets/aero_background.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';

abstract class MultimediaPlayer {
  Future<void> initialize();
  Future<void> play();
  Future<void> pause();
  Future<void> setMuted(bool muted);
  Widget buildView();
  void dispose();

  bool get isInitialized;
  bool get isPlaying;
  bool get isMuted;
  double get aspectRatio;
}

class AssetMultimediaPlayer implements MultimediaPlayer {
  AssetMultimediaPlayer(String asset)
    : _controller = VideoPlayerController.asset(asset);

  final VideoPlayerController _controller;

  @override
  Future<void> initialize() async {
    await _controller.initialize();
    await _controller.setLooping(true);
  }

  @override
  Future<void> play() => _controller.play();

  @override
  Future<void> pause() => _controller.pause();

  @override
  Future<void> setMuted(bool muted) => _controller.setVolume(muted ? 0 : 1);

  @override
  Widget buildView() => VideoPlayer(_controller);

  @override
  void dispose() => _controller.dispose();

  @override
  bool get isInitialized => _controller.value.isInitialized;

  @override
  bool get isPlaying => _controller.value.isPlaying;

  @override
  bool get isMuted => _controller.value.volume == 0;

  @override
  double get aspectRatio => _controller.value.aspectRatio == 0
      ? 16 / 9
      : _controller.value.aspectRatio;
}

class MultimediaScreen extends StatefulWidget {
  const MultimediaScreen({super.key, this.listing, this.player});

  final Listing? listing;
  final MultimediaPlayer? player;

  @override
  State<MultimediaScreen> createState() => _MultimediaScreenState();
}

class _MultimediaScreenState extends State<MultimediaScreen> {
  late final MultimediaPlayer _player =
      widget.player ?? AssetMultimediaPlayer(Assets.ipodDemoVideo);
  late final Future<void> _initializeFuture = _player.initialize();

  Listing get _item {
    return widget.listing ??
        seedListings.firstWhere((item) => item.id == 'ipod-classic');
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (!_player.isInitialized) return;
    if (_player.isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    final item = _item;
    return GlassScaffold(
      includeSafeArea: false,
      background: const DetailAeroBackground(),
      child: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            metrics.pagePadding,
            metrics.topGap,
            metrics.pagePadding,
            28 + MediaQuery.viewPaddingOf(context).bottom,
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
                  icon: Icons.movie_filter_rounded,
                  color: AppTheme.blue,
                  size: 44,
                ),
              ],
            ),
            SizedBox(height: metrics.compact ? 18 : 26),
            Text('Media Preview', style: AppTheme.h1),
            SizedBox(height: 8),
            Text(
              'Watch a short working video preview for ${item.title} ${item.subtitle}.',
              style: AppTheme.body.copyWith(fontSize: 15),
            ),
            SizedBox(height: metrics.compact ? 18 : 24),
            GlassCard(
              padding: EdgeInsets.all(metrics.compact ? 12 : 14),
              radius: metrics.cardRadius,
              opacity: 0.42,
              blur: 30,
              borderOpacity: 0.86,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      metrics.compact ? 18 : 22,
                    ),
                    child: ColoredBox(
                      color: AppTheme.ink,
                      child: FutureBuilder<void>(
                        future: _initializeFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          }
                          if (snapshot.hasError || !_player.isInitialized) {
                            return AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Center(
                                child: Text(
                                  'Video preview unavailable',
                                  style: AppTheme.body.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                          return AspectRatio(
                            aspectRatio: _player.aspectRatio,
                            child: _player.buildView(),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: metrics.compact ? 14 : 16),
                  _PlaybackStatus(player: _player),
                  SizedBox(height: metrics.compact ? 12 : 14),
                  LiquidButton(
                    key: const ValueKey('multimedia-play-pause-button'),
                    label: _player.isPlaying ? 'Pause Demo' : 'Play Demo',
                    icon: _player.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: _player.isPlaying ? AppTheme.blue : AppTheme.red,
                    height: metrics.compact ? 52 : 56,
                    onPressed: _togglePlayback,
                  ),
                ],
              ),
            ),
            SizedBox(height: metrics.compact ? 16 : 20),
            GlassCard(
              padding: EdgeInsets.all(metrics.compact ? 16 : 18),
              radius: metrics.cardRadius,
              child: Row(
                children: [
                  ProductImage(asset: item.imageAsset, width: 58, height: 58),
                  SizedBox(width: metrics.gutter),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.h2.copyWith(fontSize: 16),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${item.subtitle} demo video',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.body.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(item.priceLabel, style: AppTheme.label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaybackStatus extends StatelessWidget {
  const _PlaybackStatus({required this.player});

  final MultimediaPlayer player;

  @override
  Widget build(BuildContext context) {
    final active = player.isPlaying;
    return Row(
      children: [
        Icon(
          active ? Icons.graphic_eq_rounded : Icons.pause_circle_outline,
          color: active ? AppTheme.blue : AppTheme.muted,
          size: 19,
        ),
        SizedBox(width: 8),
        Text(
          active ? 'Playing product demo' : 'Paused product demo',
          key: const ValueKey('multimedia-playback-status'),
          style: AppTheme.label.copyWith(
            color: active ? AppTheme.blue : AppTheme.muted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
