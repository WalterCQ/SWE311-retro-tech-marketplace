import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retro_tech_marketplace/app.dart';
import 'package:retro_tech_marketplace/constants/assets.dart';
import 'package:retro_tech_marketplace/models/listing.dart';
import 'package:retro_tech_marketplace/store/listing_store.dart';
import 'package:retro_tech_marketplace/store/seed_data.dart';
import 'package:retro_tech_marketplace/constants/theme.dart';
import 'package:retro_tech_marketplace/screens/settings/help_support_screen.dart';
import 'package:retro_tech_marketplace/screens/settings/chat_thread_screen.dart';
import 'package:retro_tech_marketplace/screens/product/product_detail_screen.dart';
import 'package:retro_tech_marketplace/screens/product/multimedia_screen.dart';
import 'package:retro_tech_marketplace/services/update_service.dart';
import 'package:retro_tech_marketplace/widgets/glass_scaffold.dart';
import 'package:retro_tech_marketplace/screens/home/categories_screen.dart';
import 'package:retro_tech_marketplace/screens/settings/about_screen.dart';

void main() {
  test('release version comparison handles tags and build suffixes', () {
    expect(compareVersionNames('v1.0.5', '1.0.4+5'), greaterThan(0));
    expect(compareVersionNames('1.0.4', 'v1.0.4+5'), 0);
    expect(compareVersionNames('v1.0.3', '1.0.4'), lessThan(0));
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
    setPhoneSize(tester);
    await tester.pumpWidget(RetroTechApp(store: ListingStore()));
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
      store: ListingStore(),
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
          store: ListingStore(),
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

  testWidgets('product detail opens multimedia preview from demo entry', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    final fakeMultimediaPlayer = FakeMultimediaPlayer();
    final ipod = seedListings.firstWhere((item) => item.id == 'ipod-classic');
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: detailScreenForTest(ipod),
        onGenerateRoute: (settings) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => MultimediaScreen(
              listing: settings.arguments as Listing?,
              player: fakeMultimediaPlayer,
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -520));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('product-multimedia-entry')));
    await tester.pumpAndSettle();

    expect(find.text('Media Preview'), findsOneWidget);
    expect(find.text('Paused product demo'), findsOneWidget);
  });

  testWidgets('multimedia play pause button toggles playback state', (
    WidgetTester tester,
  ) async {
    setPhoneSize(tester);
    final player = FakeMultimediaPlayer();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: MultimediaScreen(listing: seedListings.first, player: player),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Paused product demo'), findsOneWidget);
    expect(find.text('Play Demo'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('multimedia-play-pause-button')),
    );
    await tester.pumpAndSettle();

    expect(player.isPlaying, isTrue);
    expect(find.text('Playing product demo'), findsOneWidget);
    expect(find.text('Pause Demo'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('multimedia-play-pause-button')),
    );
    await tester.pumpAndSettle();

    expect(player.isPlaying, isFalse);
    expect(find.text('Paused product demo'), findsOneWidget);
    expect(find.text('Play Demo'), findsOneWidget);
  });

  testWidgets('key screens fit common phone widths', (
    WidgetTester tester,
  ) async {
    for (final size in const [Size(320, 740), Size(390, 844), Size(430, 932)]) {
      setPhoneSize(tester, size);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: GlassScaffold(child: CategoriesScreen(store: ListingStore())),
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
            store: ListingStore(),
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
