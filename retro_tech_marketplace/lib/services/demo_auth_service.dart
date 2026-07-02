import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

enum DemoAuthProvider { google, apple, facebook }

extension DemoAuthProviderDetails on DemoAuthProvider {
  String get label {
    switch (this) {
      case DemoAuthProvider.google:
        return 'Google';
      case DemoAuthProvider.apple:
        return 'Apple';
      case DemoAuthProvider.facebook:
        return 'Facebook';
    }
  }

  String get storageValue => name;

  UserProfile get profile {
    switch (this) {
      case DemoAuthProvider.google:
        return const UserProfile(
          displayName: 'Google Demo Collector',
          username: '@google_collector',
          email: 'google.collector@retrotech.demo',
          bio: 'Signed in with Google demo auth.',
          location: 'Kuala Lumpur',
          sellerName: 'Google Demo Collector',
          preferredContact: 'Google demo account',
        );
      case DemoAuthProvider.apple:
        return const UserProfile(
          displayName: 'Apple Demo Collector',
          username: '@apple_collector',
          email: 'apple.collector@retrotech.demo',
          bio: 'Signed in with Apple demo auth.',
          location: 'Kuala Lumpur',
          sellerName: 'Apple Demo Collector',
          preferredContact: 'Apple demo account',
        );
      case DemoAuthProvider.facebook:
        return const UserProfile(
          displayName: 'Facebook Demo Collector',
          username: '@facebook_collector',
          email: 'facebook.collector@retrotech.demo',
          bio: 'Signed in with Facebook demo auth.',
          location: 'Kuala Lumpur',
          sellerName: 'Facebook Demo Collector',
          preferredContact: 'Facebook demo account',
        );
    }
  }
}

class DemoAuthService {
  const DemoAuthService._();

  static const providerKey = 'demo_auth_provider';

  static DemoAuthProvider? providerFromValue(String? value) {
    for (final provider in DemoAuthProvider.values) {
      if (provider.storageValue == value) return provider;
    }
    return null;
  }

  static Future<void> saveProvider(DemoAuthProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(providerKey, provider.storageValue);
  }

  static Future<void> clearProvider() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(providerKey);
  }
}
