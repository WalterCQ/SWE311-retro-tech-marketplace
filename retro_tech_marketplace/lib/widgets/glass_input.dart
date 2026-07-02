import 'package:flutter/material.dart';
import '../constants/theme.dart';
import 'glass_card.dart';

class GlassInput extends StatefulWidget {
  const GlassInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.label,
    this.helperText,
    this.requiredField = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? label;
  final String? helperText;
  final bool requiredField;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
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
    final showLabel =
        widget.label != null ||
        widget.helperText != null ||
        widget.requiredField ||
        widget.validator != null;
    final label = widget.label ?? widget.hint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Row(
            children: [
              Text(label, style: AppTheme.label.copyWith(color: AppTheme.ink)),
              if (widget.requiredField)
                Text(' *', style: AppTheme.label.copyWith(color: AppTheme.red)),
            ],
          ),
          if (widget.helperText != null) ...[
            SizedBox(height: 3),
            Text(
              widget.helperText!,
              style: AppTheme.body.copyWith(fontSize: 11, height: 1.25),
            ),
          ],
          SizedBox(height: 7),
        ],
        GlassCard(
          radius: 22,
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: widget.maxLines > 1 ? 6 : 0,
          ),
          opacity: 0.46,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: _obscured,
            maxLines: widget.obscure ? 1 : widget.maxLines,
            validator: widget.validator,
            style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.ink),
            decoration: InputDecoration(
              icon: Icon(widget.icon, color: AppTheme.blue, size: 18),
              hintText: showLabel && widget.hint == label ? null : widget.hint,
              hintStyle: AppTheme.body.copyWith(
                color: AppTheme.muted.withValues(alpha: 0.48),
              ),
              errorMaxLines: 2,
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
        ),
      ],
    );
  }
}

class GlassDropdown extends StatelessWidget {
  const GlassDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.icon,
    required this.onChanged,
    this.helperText,
    this.requiredField = false,
    this.validator,
  });

  final String value;
  final List<String> items;
  final String label;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  final String? helperText;
  final bool requiredField;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final dropdownItems = [
      if (value.trim().isNotEmpty && !items.contains(value)) value,
      ...items,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTheme.label.copyWith(color: AppTheme.ink)),
            if (requiredField)
              Text(' *', style: AppTheme.label.copyWith(color: AppTheme.red)),
          ],
        ),
        if (helperText != null) ...[
          SizedBox(height: 3),
          Text(
            helperText!,
            style: AppTheme.body.copyWith(fontSize: 11, height: 1.25),
          ),
        ],
        SizedBox(height: 7),
        GlassCard(
          radius: 22,
          padding: EdgeInsets.symmetric(horizontal: 18),
          opacity: 0.46,
          child: DropdownButtonFormField<String>(
            initialValue: value.trim().isEmpty ? null : value,
            items: dropdownItems
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(growable: false),
            onChanged: onChanged,
            validator: validator,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.muted,
            ),
            dropdownColor: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(22),
            style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.ink),
            decoration: InputDecoration(
              icon: Icon(icon, color: AppTheme.blue, size: 18),
              hintText: 'Select $label',
              hintStyle: AppTheme.body.copyWith(
                color: AppTheme.muted.withValues(alpha: 0.48),
              ),
              errorMaxLines: 2,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
