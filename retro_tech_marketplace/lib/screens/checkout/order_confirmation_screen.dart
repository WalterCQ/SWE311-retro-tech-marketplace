import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/seed_data.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, this.listing});

  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    final item = listing ?? seedListings.first;
    return GlassScaffold(
      child: ListView(
        padding: EdgeInsets.fromLTRB(22, 30, 22, 30),
        children: [
          Center(child: Text('RetroTech', style: AppTheme.h2)),
          SizedBox(height: 54),
          Center(
            child: GlassCard(
              width: 112,
              height: 112,
              radius: 56,
              padding: EdgeInsets.zero,
              child: Icon(Icons.done_rounded, color: AppTheme.red, size: 58),
            ),
          ),
          SizedBox(height: 28),
          Center(child: Text('Order Confirmed', style: AppTheme.h1)),
          SizedBox(height: 24),
          GlassCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.shortTitle,
                        style: AppTheme.h2.copyWith(fontSize: 17),
                      ),
                      SizedBox(height: 8),
                      Text('Order #RT2048', style: AppTheme.label),
                      Text(
                        'Paid',
                        style: AppTheme.label.copyWith(color: AppTheme.green),
                      ),
                      Text(
                        item.priceLabel,
                        style: AppTheme.h2.copyWith(
                          fontSize: 16,
                          color: AppTheme.blue,
                        ),
                      ),
                      Text(
                        'Seller: ${item.seller}',
                        style: AppTheme.body.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ProductImage(asset: item.imageAsset, width: 72, height: 72),
              ],
            ),
          ),
          SizedBox(height: 22),
          Row(
            children: [
              _ProgressChip('Paid', Icons.done_rounded, true),
              _ProgressChip(
                'Seller Notified',
                Icons.notifications_rounded,
                true,
              ),
              _ProgressChip('Preparing', Icons.inventory_2_outlined, false),
            ],
          ),
          SizedBox(height: 30),
          LiquidButton(
            label: 'Track Order',
            icon: Icons.my_location_rounded,
            onPressed: () {},
          ),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/main',
              (route) => false,
            ),
            child: Text('Back to Home', style: AppTheme.label),
          ),
        ],
      ),
    );
  }
}

class _ProgressChip extends StatelessWidget {
  const _ProgressChip(this.label, this.icon, this.done);

  final String label;
  final IconData icon;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 12),
        radius: 20,
        child: Column(
          children: [
            Icon(icon, color: done ? AppTheme.blue : AppTheme.muted),
            SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTheme.body.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

