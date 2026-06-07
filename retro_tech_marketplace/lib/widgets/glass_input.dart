import 'package:flutter/material.dart';
import '../constants/theme.dart';
import 'glass_card.dart';

class GlassInput extends StatefulWidget {
  const GlassInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscure = false,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscure;
  final int maxLines;

  @override
  State<GlassInput> createState() => _GlassInputState();
}

class _GlassInputState extends State<GlassInput> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
  }

  @override
  void didUpdateWidget(covariant GlassInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscure != widget.obscure) {
      _obscured = widget.obscure;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: widget.maxLines > 1 ? 6 : 0,
      ),
      opacity: 0.46,
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _obscured,
        maxLines: widget.maxLines,
        style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.ink),
        decoration: InputDecoration(
          icon: Icon(widget.icon, color: AppTheme.blue, size: 18),
          hintText: widget.hint,
          hintStyle: AppTheme.body.copyWith(
            color: AppTheme.muted.withValues(alpha: 0.78),
          ),
          suffixIcon: widget.obscure
              ? IconButton(
                  onPressed: () => setState(() => _obscured = !_obscured),
                  icon: Icon(
                    _obscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppTheme.muted,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 28)),
                  splashRadius: 18,
                )
              : null,
          suffixIconConstraints: widget.obscure
              ? BoxConstraints.tight(Size(24, 32))
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

