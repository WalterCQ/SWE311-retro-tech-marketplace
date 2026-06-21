import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/seed_data.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';
import '../profile/payment_methods_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, this.listing});

  final Listing? listing;

  @override
  Widget build(BuildContext context) {
    final item = listing ?? seedListings.first;
    final total = item.price + 35 + 15;
    return GlassScaffold(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(22, 18, 22, 104),
            children: [
              TopBar(title: 'Checkout'),
              SizedBox(height: 18),
              GlassCard(
                child: Row(
                  children: [
                    ProductImage(asset: item.imageAsset, width: 78, height: 78),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.shortTitle,
                            style: AppTheme.h2.copyWith(fontSize: 16),
                          ),
                          Text(
                            'Seller: ${item.seller}',
                            style: AppTheme.body.copyWith(fontSize: 12),
                          ),
                          Text(
                            item.priceLabel,
                            style: AppTheme.label.copyWith(color: AppTheme.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              _CheckoutTile(
                Icons.location_on_outlined,
                'Delivery Address',
                'Liu Zhenyu\nNo. 18, Jalan Bukit Indah\nKuala Lumpur, Malaysia',
              ),
              _CheckoutTile(
                Icons.credit_card_outlined,
                'Payment Method',
                'Visa ending 2048   Default',
                openPage: const PaymentMethodsScreen(),
                routeSettings: const RouteSettings(name: '/payment-methods'),
              ),
              _CheckoutTile(
                Icons.shield_outlined,
                'Buyer Protection',
                'Secure payment and verified listing coverage included.',
              ),
              SizedBox(height: 16),
              Text('Order Summary', style: AppTheme.h2.copyWith(fontSize: 16)),
              SizedBox(height: 10),
              GlassCard(
                child: Column(
                  children: [
                    _MoneyRow('Item Price', item.price),
                    _MoneyRow('Shipping', 35),
                    _MoneyRow('Protection Fee', 15),
                    Divider(color: AppTheme.line),
                    _MoneyRow('Total', total, strong: true),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 22,
            child: LiquidButton(
              label: 'Pay Securely',
              icon: Icons.lock_outline_rounded,
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                '/order-confirmed',
                arguments: item,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutTile extends StatelessWidget {
  const _CheckoutTile(
    this.icon,
    this.title,
    this.body, {
    this.openPage,
    this.routeSettings,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? openPage;
  final RouteSettings? routeSettings;

  @override
  Widget build(BuildContext context) {
    Widget tile(VoidCallback? tap, {EdgeInsetsGeometry? margin}) {
      return LiquidPressable(
        onTap: tap,
        borderRadius: BorderRadius.circular(30),
        glowColor: AppTheme.blue,
        child: GlassCard(
          margin: margin,
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.blue),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w900)),
                    Text(body, style: AppTheme.body.copyWith(fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppTheme.muted),
            ],
          ),
        ),
      );
    }

    final page = openPage;
    if (page != null) {
      return Container(
        margin: EdgeInsets.only(bottom: 12),
        child: OpenMotionContainer(
          radius: 30,
          openPage: page,
          routeSettings: routeSettings,
          closedBuilder: (openContainer) => tile(openContainer),
        ),
      );
    }

    return tile(null, margin: EdgeInsets.only(bottom: 12));
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow(this.label, this.amount, {this.strong = false});

  final String label;
  final double amount;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: strong ? AppTheme.h2.copyWith(fontSize: 16) : AppTheme.body,
          ),
          Spacer(),
          Text(
            'RM ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: strong ? AppTheme.blue : AppTheme.ink,
            ),
          ),
        ],
      ),
    );
  }
}
