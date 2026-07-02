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

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key, required this.store});

  final ListingStore store;

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: widget.store,
            builder: (context, _) {
              final visible = widget.store.listings;
              return ListView(
                padding: EdgeInsets.fromLTRB(22, 18, 22, 104),
                children: [
                  TopBar(title: 'My Listings', showTrailing: false),
                  SizedBox(height: 14),
                  if (visible.isEmpty)
                    _EmptyListingsState(
                      onCreate: () =>
                          Navigator.pushNamed(context, '/create-listing'),
                    )
                  else
                    ...visible.map(
                      (listing) => ListingCard(
                        listing: listing,
                        openStore: widget.store,
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
                        onDelete: () => showDeleteListingDialog(
                          context,
                          widget.store,
                          listing,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyListingsState extends StatelessWidget {
  const _EmptyListingsState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
      radius: 26,
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, color: AppTheme.blue, size: 34),
          SizedBox(height: 12),
          Text(
            'No listings yet',
            style: AppTheme.h2.copyWith(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            'Create a listing to start managing your items.',
            style: AppTheme.body.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          LiquidButton(
            label: 'Create Listing',
            icon: Icons.add_rounded,
            onPressed: onCreate,
          ),
        ],
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
                    TopBar(title: 'My Listings', showTrailing: false),
                    SizedBox(height: 14),
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

Future<bool> showDeleteListingDialog(
  BuildContext context,
  ListingStore store,
  Listing listing,
) async {
  final deleted = await showDialog<bool>(
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
            'This action cannot be undone.\n"${listing.title}" will be removed from RetroTech.',
            textAlign: TextAlign.center,
            style: AppTheme.body,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
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
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: Text('Delete'),
            ),
          ],
        ),
      );
    },
  );
  return deleted ?? false;
}
