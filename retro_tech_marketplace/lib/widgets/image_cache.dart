import 'package:flutter/widgets.dart';

int imageCacheDimension(
  BuildContext context,
  double logicalPixels, {
  double? logicalHeight,
  double overscan = 1.2,
}) {
  final maxLogicalPixels =
      logicalHeight != null && logicalHeight > logicalPixels
      ? logicalHeight
      : logicalPixels;
  if (!maxLogicalPixels.isFinite || maxLogicalPixels <= 0) return 1;
  final pixels =
      maxLogicalPixels * MediaQuery.devicePixelRatioOf(context) * overscan;
  return pixels.ceil().clamp(1, 4096).toInt();
}
