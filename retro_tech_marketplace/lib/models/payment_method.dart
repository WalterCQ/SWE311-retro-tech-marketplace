import 'package:flutter/material.dart';

import '../constants/theme.dart';

class PaymentMethodOption {
  const PaymentMethodOption({
    required this.id,
    required this.logo,
    required this.title,
    required this.color,
  });

  final String id;
  final String logo;
  final String title;
  final Color color;

  static const visa = PaymentMethodOption(
    id: 'visa',
    logo: 'VISA',
    title: 'Visa ending 2048',
    color: AppTheme.blue,
  );

  static const options = [
    visa,
    PaymentMethodOption(
      id: 'apple-pay',
      logo: 'Pay',
      title: 'Apple Pay',
      color: AppTheme.ink,
    ),
    PaymentMethodOption(
      id: 'tng',
      logo: 'TnG',
      title: "Touch 'n Go eWallet",
      color: AppTheme.blue,
    ),
    PaymentMethodOption(
      id: 'bank',
      logo: 'Bank',
      title: 'Online Banking',
      color: AppTheme.green,
    ),
  ];

  static PaymentMethodOption byId(String id) {
    return options.firstWhere((method) => method.id == id, orElse: () => visa);
  }
}
