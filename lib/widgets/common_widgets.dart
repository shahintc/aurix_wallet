import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

// ── Gold divider ─────────────────────────────────────────────────────────────
class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    color: AppTheme.border,
  );
}

// ── Section label ─────────────────────────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    ),
  );
}

// ── Aurix card container ──────────────────────────────────────────────────────
class AurixCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const AurixCard({super.key, required this.child, this.padding});
  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppTheme.navyCard,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.border),
    ),
    child: child,
  );
}

// ── Amount input field ────────────────────────────────────────────────────────
class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? prefix;
  final String? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AmountField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    style: const TextStyle(
        color: AppTheme.white, fontSize: 18, fontWeight: FontWeight.w600),
    validator: validator,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefix,
      suffixText: suffix,
      prefixStyle: const TextStyle(
          color: AppTheme.gold, fontSize: 18, fontWeight: FontWeight.w700),
      suffixStyle:
      const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
    ),
  );
}

// ── Primary action button ─────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  const PrimaryButton(
      {super.key,
        required this.label,
        this.onPressed,
        this.loading = false});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
            strokeWidth: 2.5, color: AppTheme.navy),
      )
          : Text(label),
    ),
  );
}

// ── Stat tile (label + value pair) ───────────────────────────────────────────
class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const StatTile(
      {super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              color: AppTheme.textSecondary, fontSize: 12)),
      const SizedBox(height: 4),
      Text(value,
          style: TextStyle(
              color: valueColor ?? AppTheme.white,
              fontSize: 15,
              fontWeight: FontWeight.w600)),
    ],
  );
}