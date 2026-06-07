import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/navigation.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          _PaymentTile('VISA', 'Visa ending 2048', 'Default', AppTheme.blue),
          _PaymentTile('Pay', 'Apple Pay', 'Available', AppTheme.ink),
          _PaymentTile(
            'TnG',
            "Touch 'n Go eWallet",
            'Available',
            AppTheme.blue,
          ),
          _PaymentTile('Bank', 'Online Banking', 'Available', AppTheme.green),
          SizedBox(height: 12),
          GlassCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Icon(Icons.add_rounded, color: AppTheme.blue),
              title: Text('Add New Payment Method', style: AppTheme.label),
              trailing: Icon(Icons.chevron_right_rounded),
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
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile(this.logo, this.title, this.status, this.color);

  final String logo;
  final String title;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              logo,
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text(
                  status,
                  style: AppTheme.label.copyWith(
                    color: status == 'Default' ? AppTheme.red : AppTheme.blue,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.radio_button_unchecked_rounded, color: AppTheme.muted),
        ],
      ),
    );
  }
}
