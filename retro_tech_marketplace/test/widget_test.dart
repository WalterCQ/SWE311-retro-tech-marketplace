import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retro_tech_marketplace/app.dart';
import 'package:retro_tech_marketplace/constants/assets.dart';
import 'package:retro_tech_marketplace/data/listing_repository.dart';
import 'package:retro_tech_marketplace/models/listing.dart';
import 'package:retro_tech_marketplace/models/order_record.dart';
import 'package:retro_tech_marketplace/models/user_profile.dart';
import 'package:retro_tech_marketplace/store/listing_store.dart';
import 'package:retro_tech_marketplace/store/seed_data.dart';
import 'package:retro_tech_marketplace/constants/theme.dart';
import 'package:retro_tech_marketplace/screens/settings/help_support_screen.dart';
import 'package:retro_tech_marketplace/screens/settings/chat_thread_screen.dart';
import 'package:retro_tech_marketplace/screens/settings/settings_screen.dart';
import 'package:retro_tech_marketplace/screens/checkout/checkout_screen.dart';
import 'package:retro_tech_marketplace/screens/checkout/order_confirmation_screen.dart';
import 'package:retro_tech_marketplace/screens/product/category_detail_screen.dart';
import 'package:retro_tech_marketplace/screens/product/my_listings_screen.dart';
import 'package:retro_tech_marketplace/screens/product/product_detail_screen.dart';
import 'package:retro_tech_marketplace/screens/product/product_video_player.dart';
import 'package:retro_tech_marketplace/screens/profile/account_profile_screen.dart';
import 'package:retro_tech_marketplace/screens/profile/payment_methods_screen.dart';
import 'package:retro_tech_marketplace/screens/profile/seller_profile_screen.dart';
import 'package:retro_tech_marketplace/services/update_service.dart';
import 'package:retro_tech_marketplace/widgets/glass_scaffold.dart';
import 'package:retro_tech_marketplace/screens/home/categories_screen.dart';
import 'package:retro_tech_marketplace/screens/settings/about_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('release version comparison handles tags and build suffixes', () {
    expect(compareVersionNames('v1.0.5', '1.0.4+5'), greaterThan(0));
    expect(compareVersionNames('1.0.4', 'v1.0.4+5'), 0);
    expect(compareVersionNames('v1.0.3', '1.0.4'), lessThan(0));
  });

  test('release parser selects the first APK asset download URL', () {
    final release = <String, Object?>{
      'assets': [
        {
          'name': 'release-notes.txt',
          'browser_download_url':
              'https://github.com/WalterCQ/example/releases/download/v1.1.1/release-notes.txt',
        },
        {
          'name': 'retro-tech-marketplace.apk',
          'browser_download_url':
              'https://github.com/WalterCQ/example/releases/download/v1.1.1/retro-tech-marketplace.apk',
        },
        {
          'name': 'retro-tech-marketplace-arm64.apk',
          'browser_download_url':
              'https://github.com/WalterCQ/example/releases/download/v1.1.1/retro-tech-marketplace-arm64.apk',
        },
      ],
    };

    expect(
      selectApkDownloadUrlFromRelease(release),
      'https://github.com/WalterCQ/example/releases/download/v1.1.1/retro-tech-marketplace.apk',
    );
  });

  test('release parser returns null when no APK asset is available', () {
    final release = <String, Object?>{
      'assets': [
        {
          'name': 'ios-unsigned.zip',
          'browser_download_url':
              'https://github.com/WalterCQ/example/releases/download/v1.1.1/ios-unsigned.zip',
        },
      ],
    };

    expect(selectApkDownloadUrlFromRelease(release), isNull);
  });

  test(
    'product galleries keep original first image and expose three images',
    () {
      for (final listing in seedListings) {
        expect(listing.detailImageAssets, hasLength(3));
        expect(listing.detailImageAssets.first, listing.imageAsset);
      }

      final watchListing = seedListings.first.copyWith(
        imageAsset: Assets.watch,
      );
      expect(watchListing.detailImageAssets, hasLength(3));
      expect(watchListing.detailImageAssets.first, Assets.watch);
    },
  );

  void setPhoneSize(WidgetTester tester, [Size size = const Size(390, 844)]) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpRetroTech(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    setPhoneSize(tester);
    await tester.pumpWidget(RetroTechApp(store: testStore()));
    await tester.pumpAndSettle();
  }

  Future<void> logIn(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
  }

  ProductDetailScreen detailScreenForTest(Listing listing) {
    return ProductDetailScreen(
      store: testStore(),
      listing: listing,
      videoPlayerBuilder: (_) => FakeMultimediaPlayer(),
    );
  }

  testWidgets('RetroTech app smoke test', (WidgetTester tester) async {
    await pumpRetroTech(tester);

    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets('home segments switch between market and community', (
    WidgetTester tester,
  ) async {
    await pumpRetroTech(tester);
    await logIn(tester);

    expect(find.textContaining('Buy, sell'), findsOneWidget);

    await tester.tap(find.text('Community'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Collectors, restorers, and transparent tech fans share finds here.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('category search filters visible categories', (
    WidgetTester tester,
  ) async {
    await pumpRetroTech(tester);
    await logIn(tester);

    await tester.tap(find.text('Categories').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('category-search-field')),
      'Gaming',
    );
    await tester.pumpAndSettle();

    expect(find.text('Gaming'), findsWidgets);
    expect(find.text('Phones'), findsNothing);
  });

  testWidgets('FAQ card expands on tap', (WidgetTester tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.theme, home: const HelpSupportScreen()),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Message sellers securely from any product page.'),
      findsNothing,
    );

    await tester.tap(find.text('How do I contact a seller?'));
    await tester.pumpAndSettle();

    expect(
      find.text('Message sellers securely from any product page.'),
      findsOneWidget,
    );
  });

  testWidgets('chat input sends local message', (WidgetTester tester) async {
    setPhoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.theme, home: const ChatThreadScreen()),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('chat-message-field')),
      'Can you send more photos?',
    );
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Can you send more photos?'), findsOneWidget);
  });

  testWidgets('favorite button toggles selected state', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: detailScreenForTest(seedListings.first),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_rounded), findsNothing);

    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
  });

  testWidgets('profile changes sync into account and settings screens', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = testStore();
    await store.load();
    setPhoneSize(tester);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: AccountProfileScreen(store: store),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Retro Tech'), findsOneWidget);

    await store.saveProfile(
      const UserProfile(
        displayName: 'Walter Collector',
        username: '@walter',
        email: 'walter@example.com',
        bio: 'Restores rare devices.',
        location: 'Kuala Lumpur',
        sellerName: 'Walter Shop',
        preferredContact: 'In-app message',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Walter Collector'), findsOneWidget);
    expect(find.text('@walter'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: SettingsScreen(store: store),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Walter Collector'), findsOneWidget);
    expect(find.text('Language'), findsNothing);
    expect(find.text('Currency'), findsNothing);
    expect(find.text('Theme'), findsNothing);
  });

  testWidgets('payment selection updates checkout and orders can be tracked', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = testStore();
    await store.load();
    setPhoneSize(tester);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: PaymentMethodsScreen(store: store),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apple Pay'));
    await tester.pumpAndSettle();
    expect(store.selectedPaymentMethod.title, 'Apple Pay');
    expect(find.byIcon(Icons.radio_button_checked_rounded), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        onGenerateRoute: (settings) {
          if (settings.name == '/order-confirmed') {
            return MaterialPageRoute<void>(
              builder: (_) => OrderConfirmationScreen(
                store: store,
                order: settings.arguments as OrderRecord?,
              ),
              settings: settings,
            );
          }
          if (settings.name == '/order-detail') {
            return MaterialPageRoute<void>(
              builder: (_) => OrderDetailScreen(
                store: store,
                order: settings.arguments as OrderRecord?,
              ),
              settings: settings,
            );
          }
          return null;
        },
        home: CheckoutScreen(store: store, listing: seedListings.first),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Apple Pay'), findsOneWidget);

    await tester.tap(find.text('Pay Securely'));
    await tester.pumpAndSettle();
    expect(store.orders, hasLength(1));
    expect(find.text('Order Confirmed'), findsOneWidget);
    expect(find.textContaining('Apple Pay'), findsOneWidget);

    await tester.tap(find.text('Track Order'));
    await tester.pumpAndSettle();
    expect(find.text('Order Detail'), findsOneWidget);
  });

  testWidgets('profile saved items and seller follow use store state', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = testStore();
    await store.load();
    setPhoneSize(tester);

    await store.toggleSaved('ipod-classic');
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: AccountProfileScreen(store: store),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Saved Items'), findsOneWidget);
    expect(store.savedListings, hasLength(1));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: SellerProfileScreen(store: store, sellerName: 'VintageAudioCo'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Follow'), findsOneWidget);
    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();
    expect(find.text('Following'), findsOneWidget);
    expect(store.isFollowing('VintageAudioCo'), isTrue);
  });

  testWidgets('filter pills update my listings, inbox, and help results', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = testStore();
    await store.load();
    setPhoneSize(tester);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: MyListingsScreen(store: store),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('iMac G3'), findsNothing);
    await tester.tap(find.text('Drafts').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('iMac G3'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.theme, home: const InboxScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('VintageAudioCo'), findsOneWidget);
    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.text('RetroTech Orders'), findsOneWidget);
    expect(find.text('VintageAudioCo'), findsNothing);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.theme, home: const HelpSupportScreen()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();
    expect(find.text('How are payments protected?'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('help-search-field')),
      'fake',
    );
    await tester.pumpAndSettle();
    expect(find.text('No help topics found.'), findsOneWidget);
  });

  testWidgets('category detail price filter changes visible products', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = testStore();
    await store.load();
    setPhoneSize(tester);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: CategoryDetailScreen(store: store, category: 'Audio'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('RM 1599.00'), findsWidgets);
    await tester.tap(find.text('Under RM1000'));
    await tester.pumpAndSettle();
    expect(find.text('RM 1599.00'), findsNothing);
    expect(find.text('RM 999.00'), findsWidgets);
  });

  testWidgets('product detail gallery swipes and dots select images', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    final ipod = seedListings.firstWhere((item) => item.id == 'ipod-classic');
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.theme, home: detailScreenForTest(ipod)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('product-gallery-page-view')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('product-gallery-dot-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('product-gallery-dot-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('product-gallery-dot-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('product-gallery-dot-3')), findsOneWidget);
    expect(find.text('Contact Seller'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('product-gallery-dot-0'))).width,
      20,
    );

    await tester.drag(
      find.byKey(const ValueKey('product-gallery-page-view')),
      const Offset(-320, 0),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('product-gallery-dot-1'))).width,
      20,
    );

    await tester.tap(find.byKey(const ValueKey('product-gallery-dot-2')));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('product-gallery-dot-2'))).width,
      20,
    );
  });

  testWidgets('product detail starts gallery with playable product video', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    final player = FakeMultimediaPlayer();
    final ipod = seedListings.firstWhere((item) => item.id == 'ipod-classic');
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: ProductDetailScreen(
          store: testStore(),
          listing: ipod,
          videoPlayerBuilder: (_) => player,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('product-gallery-video-toggle')),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('product-gallery-dot-0'))).width,
      20,
    );

    await tester.tap(
      find.byKey(const ValueKey('product-gallery-video-toggle')),
    );
    await tester.pumpAndSettle();
    expect(player.isPlaying, isTrue);

    await tester.tap(
      find.byKey(const ValueKey('product-gallery-video-sound-toggle')),
    );
    await tester.pumpAndSettle();
    expect(player.isMuted, isTrue);
    expect(player.isPlaying, isTrue);

    await tester.tap(
      find.byKey(const ValueKey('product-gallery-video-sound-toggle')),
    );
    await tester.pumpAndSettle();
    expect(player.isMuted, isFalse);
    expect(player.isPlaying, isTrue);

    await tester.tap(
      find.byKey(const ValueKey('product-gallery-video-toggle')),
    );
    await tester.pumpAndSettle();
    expect(player.isPlaying, isFalse);
  });

  testWidgets('key screens fit common phone widths', (
    WidgetTester tester,
  ) async {
    for (final size in const [Size(320, 740), Size(390, 844), Size(430, 932)]) {
      setPhoneSize(tester, size);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: GlassScaffold(child: CategoriesScreen(store: testStore())),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('category-search-field')),
        findsOneWidget,
      );

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.theme, home: const AboutScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('ABOUT US'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: ProductDetailScreen(
            store: testStore(),
            listing: seedListings.first,
            videoPlayerBuilder: (_) => FakeMultimediaPlayer(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Contact Seller'), findsOneWidget);
    }
  });
}

ListingStore testStore({FakeListingRepository? repository}) {
  return ListingStore(repository: repository ?? FakeListingRepository());
}

class FakeListingRepository extends ListingRepository {
  FakeListingRepository({List<Listing>? listings})
    : _listings = [...(listings ?? seedListings)];

  final List<Listing> _listings;
  final Set<String> _savedItemIds = {};
  final List<OrderRecord> _orders = [];
  final Set<String> _followedSellers = {};
  UserProfile _profile = UserProfile.defaults;

  @override
  Future<List<Listing>> load() async => List<Listing>.of(_listings);

  @override
  Future<void> add(Listing listing) async {
    _listings.insert(0, listing);
  }

  @override
  Future<void> update(Listing listing) async {
    final index = _listings.indexWhere((item) => item.id == listing.id);
    if (index != -1) _listings[index] = listing;
  }

  @override
  Future<void> delete(String id) async {
    _listings.removeWhere((listing) => listing.id == id);
    _savedItemIds.remove(id);
  }

  @override
  Future<UserProfile> loadProfile() async => _profile;

  @override
  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
  }

  @override
  Future<Set<String>> loadSavedItemIds() async => Set<String>.of(_savedItemIds);

  @override
  Future<void> setSaved(String listingId, bool saved) async {
    if (saved) {
      _savedItemIds.add(listingId);
    } else {
      _savedItemIds.remove(listingId);
    }
  }

  @override
  Future<List<OrderRecord>> loadOrders() async => List<OrderRecord>.of(_orders);

  @override
  Future<void> addOrder(OrderRecord order) async {
    _orders.insert(0, order);
  }

  @override
  Future<Set<String>> loadFollowedSellers() async {
    return Set<String>.of(_followedSellers);
  }

  @override
  Future<void> setFollowing(String seller, bool following) async {
    if (following) {
      _followedSellers.add(seller);
    } else {
      _followedSellers.remove(seller);
    }
  }
}

class FakeMultimediaPlayer implements MultimediaPlayer {
  bool _initialized = false;
  bool _playing = false;
  bool _muted = false;
  bool _disposed = false;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<void> play() async {
    _playing = true;
  }

  @override
  Future<void> pause() async {
    _playing = false;
  }

  @override
  Future<void> setMuted(bool muted) async {
    _muted = muted;
  }

  @override
  Widget buildView() {
    return const ColoredBox(
      key: ValueKey('fake-multimedia-video'),
      color: Colors.black,
    );
  }

  @override
  void dispose() {
    _disposed = true;
  }

  @override
  bool get isInitialized => _initialized && !_disposed;

  @override
  bool get isPlaying => _playing;

  @override
  bool get isMuted => _muted;

  @override
  double get aspectRatio => 16 / 9;
}
