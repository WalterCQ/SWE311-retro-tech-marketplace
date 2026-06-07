import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/listing_store.dart';
import '../../store/seed_data.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/navigation.dart';
import '../home/home_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key, required this.store});

  final ListingStore store;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              return ListView(
                padding: EdgeInsets.fromLTRB(22, 18, 22, 104),
                children: [
                  TopBar(
                    title: 'My Listings',
                    trailing: Icons.filter_alt_outlined,
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      _ListingCounter(
                        '${store.listings.where((e) => e.status == 'Published').length}',
                        'Published',
                      ),
                      _ListingCounter(
                        '${store.listings.where((e) => e.status == 'Draft').length}',
                        'Drafts',
                      ),
                      _ListingCounter('5', 'Sold'),
                    ],
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      FilterPill('Published', true),
                      FilterPill('Drafts', false),
                      FilterPill('Sold', false),
                    ],
                  ),
                  SizedBox(height: 18),
                  ...store.listings.map(
                    (listing) => ListingCard(
                      listing: listing,
                      openStore: store,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/product',
                        arguments: listing,
                      ),
                      onEdit: () => Navigator.pushNamed(
                        context,
                        '/edit-listing',
                        arguments: listing,
                      ),
                      onDelete: () =>
                          showDeleteListingDialog(context, store, listing),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            right: 24,
            bottom: 26,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/create-listing'),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.red,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.red.withValues(alpha: 0.32),
                      offset: Offset(0, 10),
                      blurRadius: 22,
                    ),
                  ],
                ),
                child: Icon(Icons.add_rounded, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingCounter extends StatelessWidget {
  const _ListingCounter(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(vertical: 12),
        radius: 20,
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.h2.copyWith(fontSize: 16, color: AppTheme.blue),
            ),
            Text(label, style: AppTheme.body.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class DeleteConfirmationScreen extends StatelessWidget {
  const DeleteConfirmationScreen({super.key, required this.store});

  final ListingStore store;

  @override
  Widget build(BuildContext context) {
    final listing = store.listings.isEmpty
        ? seedListings.first
        : store.listings.first;
    return GlassScaffold(
      child: Stack(
        children: [
          IgnorePointer(
            child: AnimatedBuilder(
              animation: store,
              builder: (context, _) {
                return ListView(
                  padding: EdgeInsets.fromLTRB(22, 18, 22, 34),
                  children: [
                    TopBar(
                      title: 'My Listings',
                      trailing: Icons.filter_alt_outlined,
                    ),
                    SizedBox(height: 18),
                    Row(
                      children: [
                        _ListingCounter('12', 'Published'),
                        _ListingCounter('3', 'Drafts'),
                        _ListingCounter('5', 'Sold'),
                      ],
                    ),
                    SizedBox(height: 18),
                    ListingCard(listing: listing, openStore: store),
                    ListingCard(listing: seedListings[1], openStore: store),
                  ],
                );
              },
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(color: Colors.white.withValues(alpha: 0.42)),
          ),
          Center(
            child: GlassCard(
              width: 300,
              radius: 28,
              padding: EdgeInsets.fromLTRB(22, 26, 22, 18),
              opacity: 0.82,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: AppTheme.red,
                    size: 34,
                  ),
                  SizedBox(height: 12),
                  Text('Delete Listing?', style: AppTheme.h2),
                  SizedBox(height: 8),
                  Text(
                    'This action cannot be undone.\nYour listing will be removed from RetroTech.',
                    textAlign: TextAlign.center,
                    style: AppTheme.body.copyWith(fontSize: 12),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: AppTheme.body.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.red,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                          onPressed: () async {
                            await store.delete(listing.id);
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showDeleteListingDialog(
  BuildContext context,
  ListingStore store,
  Listing listing,
) async {
  await showDialog<void>(
    context: context,
    barrierColor: Colors.white.withValues(alpha: 0.42),
    builder: (dialogContext) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: AlertDialog(
          backgroundColor: Colors.white.withValues(alpha: 0.82),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Column(
            children: [
              Icon(Icons.delete_outline_rounded, color: AppTheme.red, size: 34),
              SizedBox(height: 12),
              Text(
                'Delete Listing?',
                textAlign: TextAlign.center,
                style: AppTheme.h2,
              ),
            ],
          ),
          content: Text(
            'This action cannot be undone.\nYour listing will be removed from RetroTech.',
            textAlign: TextAlign.center,
            style: AppTheme.body,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: AppTheme.body.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.red,
                foregroundColor: Colors.white,
                shape: StadiumBorder(),
              ),
              onPressed: () async {
                await store.delete(listing.id);
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: Text('Delete'),
            ),
          ],
        ),
      );
    },
  );
}
