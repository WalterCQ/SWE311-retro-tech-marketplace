import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
