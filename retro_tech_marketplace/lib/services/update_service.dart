import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.tagName,
    required this.releaseUrl,
  });

  final String currentVersion;
  final String latestVersion;
  final String tagName;
  final String releaseUrl;

  bool get updateAvailable =>
      compareVersionNames(latestVersion, currentVersion) > 0;
}

class UpdateService {
  const UpdateService();

  static const fallbackVersion = '1.0.5';
  static const repository = 'WalterCQ/swe311-mobile-application-system-design';
  static const releasePageUrl =
      'https://github.com/$repository/releases/latest';

  static const _channel = MethodChannel('retro_tech_marketplace/app_update');
  static final Uri _latestReleaseApi = Uri.https(
    'api.github.com',
    '/repos/$repository/releases/latest',
  );

  Future<AppUpdateInfo> checkLatestRelease() async {
    final currentVersion = await _currentVersionName();
    final release = await _fetchLatestRelease();
    return AppUpdateInfo(
      currentVersion: currentVersion,
      latestVersion: _normalizeVersion(release.tagName),
      tagName: release.tagName,
      releaseUrl: release.releaseUrl,
    );
  }

  Future<bool> openReleasePage(String url) async {
    try {
      final opened = await _channel.invokeMethod<bool>('openUrl', {'url': url});
      if (opened == true) return true;
    } on MissingPluginException {
      // Fall back to copying the link on platforms without the native channel.
    } on PlatformException {
      // The caller only needs a usable download path, so copy the link below.
    }
    await Clipboard.setData(ClipboardData(text: url));
    return false;
  }

  Future<String> _currentVersionName() async {
    try {
      final info = await _channel.invokeMapMethod<String, Object?>(
        'getAppInfo',
      );
      final versionName = info?['versionName']?.toString().trim();
      if (versionName != null && versionName.isNotEmpty) {
        return _normalizeVersion(versionName);
      }
    } on MissingPluginException {
      // Widget tests and unsupported platforms use the checked-in fallback.
    } on PlatformException {
      // Keep update checks usable even if native metadata is unavailable.
    }
    return fallbackVersion;
  }

  Future<_ReleaseMetadata> _fetchLatestRelease() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client
          .getUrl(_latestReleaseApi)
          .timeout(const Duration(seconds: 8));
      request.headers
        ..set(HttpHeaders.acceptHeader, 'application/vnd.github+json')
        ..set(HttpHeaders.userAgentHeader, 'RetroTechMarketplace');

      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );
      final body = await utf8.decodeStream(response);
      if (response.statusCode != HttpStatus.ok) {
        throw const UpdateCheckException();
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map<String, Object?>) {
        throw const UpdateCheckException();
      }

      final tagName = decoded['tag_name']?.toString() ?? '';
      final releaseUrl = decoded['html_url']?.toString() ?? releasePageUrl;
      if (tagName.trim().isEmpty) {
        throw const UpdateCheckException();
      }

      return _ReleaseMetadata(tagName: tagName, releaseUrl: releaseUrl);
    } on TimeoutException {
      throw const UpdateCheckException();
    } on FormatException {
      throw const UpdateCheckException();
    } on IOException {
      throw const UpdateCheckException();
    } finally {
      client.close(force: true);
    }
  }
}

class UpdateCheckException implements Exception {
  const UpdateCheckException();
}

class _ReleaseMetadata {
  const _ReleaseMetadata({required this.tagName, required this.releaseUrl});

  final String tagName;
  final String releaseUrl;
}

int compareVersionNames(String left, String right) {
  final leftParts = _versionParts(left);
  final rightParts = _versionParts(right);
  final maxLength = leftParts.length > rightParts.length
      ? leftParts.length
      : rightParts.length;

  for (var i = 0; i < maxLength; i += 1) {
    final leftValue = i < leftParts.length ? leftParts[i] : 0;
    final rightValue = i < rightParts.length ? rightParts[i] : 0;
    if (leftValue != rightValue) {
      return leftValue.compareTo(rightValue);
    }
  }
  return 0;
}

String _normalizeVersion(String value) {
  final trimmed = value.trim();
  final withoutBuild = trimmed.split('+').first;
  return withoutBuild.startsWith('v')
      ? withoutBuild.substring(1)
      : withoutBuild;
}

List<int> _versionParts(String value) {
  return _normalizeVersion(
    value,
  ).split('.').map((part) => int.tryParse(part) ?? 0).toList(growable: false);
}
