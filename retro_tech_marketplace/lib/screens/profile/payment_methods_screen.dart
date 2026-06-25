import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/payment_method.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/navigation.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({
    super.key,
    required this.store,
    this.closeOnSelect = false,
  });

  final ListingStore store;
  final bool closeOnSelect;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return GlassScaffold(
          child: ListView(
            padding: EdgeInsets.fromLTRB(22, 18, 22, 28),
            children: [
              TopBar(title: 'Payment Methods'),
              SizedBox(height: 20),
              GlassCard(
                radius: 24,
                child: Row(
                  children: [
                    Icon(Icons.lock_outline_rounded, color: AppTheme.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Protected checkout for verified listings',
                        style: AppTheme.body,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              ...PaymentMethodOption.options.map(
                (method) => _PaymentTile(
                  method,
                  selected: store.selectedPaymentMethod.id == method.id,
                  onTap: () async {
                    await store.selectPaymentMethod(method.id);
                    if (closeOnSelect && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'All payments are encrypted and secure. Eligible purchases are covered by RetroTech Buyer Protection.',
                textAlign: TextAlign.center,
                style: AppTheme.body.copyWith(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile(
    this.method, {
    required this.selected,
    required this.onTap,
  });

  final PaymentMethodOption method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 64,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            method.logo,
            style: TextStyle(color: method.color, fontWeight: FontWeight.w900),
          ),
        ),
        title: Text(
          method.title,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          selected ? 'Selected' : 'Available',
          style: AppTheme.label.copyWith(
            color: selected ? AppTheme.red : AppTheme.blue,
          ),
        ),
        trailing: Icon(
          selected
              ? Icons.radio_button_checked_rounded
              : Icons.radio_button_unchecked_rounded,
          color: selected ? AppTheme.red : AppTheme.muted,
        ),
      ),
    );
  }
}
