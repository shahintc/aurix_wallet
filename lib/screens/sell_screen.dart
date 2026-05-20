import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});
  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _amtCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _useBpc = false; // toggle between BPC and grams input
  double _previewUsd = 0;
  double _previewOther = 0; // grams if using BPC, BPC if using grams
  bool _loading = false;

  void _recalc(String val) {
    final wallet = context.read<WalletProvider>();
    final amt = double.tryParse(val) ?? 0;
    setState(() {
      if (_useBpc) {
        _previewUsd = wallet.bpcToUsd(amt);
        _previewOther = wallet.bpcToGrams(amt);
      } else {
        _previewUsd = wallet.gramsToUsd(amt);
        _previewOther = wallet.gramsToBpc(amt);
      }
    });
  }

  Future<void> _sell() async {
    if (!_formKey.currentState!.validate()) return;
    final amt = double.tryParse(_amtCtrl.text);
    if (amt == null) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final err = context.read<WalletProvider>().sellGold(
      bpc: _useBpc ? amt : null,
      grams: _useBpc ? null : amt,
    );
    setState(() => _loading = false);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: AppTheme.danger));
      return;
    }
    _amtCtrl.clear();
    setState(() {
      _previewUsd = 0;
      _previewOther = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Gold sold successfully!'),
          backgroundColor: AppTheme.success),
    );
  }

  @override
  void dispose() {
    _amtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sell Gold')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Balance card ───────────────────────────
              AurixCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatTile(
                        label: 'Available BPC',
                        value:
                        '${wallet.bpcBalance.toStringAsFixed(0)} BPC'),
                    StatTile(
                        label: 'Gold',
                        value:
                        '${wallet.goldGrams.toStringAsFixed(4)}g',
                        valueColor: AppTheme.goldLight),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Toggle ─────────────────────────────────
              Row(
                children: [
                  const SectionLabel('Input mode  '),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _useBpc = !_useBpc;
                        _amtCtrl.clear();
                        _previewUsd = 0;
                        _previewOther = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.navyCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.gold),
                      ),
                      child: Text(
                        _useBpc ? 'Switch to Grams' : 'Switch to BPC',
                        style: const TextStyle(
                            color: AppTheme.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              AmountField(
                controller: _amtCtrl,
                label: _useBpc ? 'BPC Amount' : 'Gold (grams)',
                hint: '0.00',
                suffix: _useBpc ? 'BPC' : 'g',
                onChanged: _recalc,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter an amount.';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Must be greater than 0.';
                  final bpc =
                  _useBpc ? n : wallet.gramsToBpc(n);
                  if (bpc > wallet.bpcBalance) return 'Insufficient balance.';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              if (_previewUsd > 0) ...[
                AurixCard(
                  child: Column(
                    children: [
                      _Row(
                          label: 'You receive',
                          value:
                          '\$${_previewUsd.toStringAsFixed(4)} USD',
                          highlight: true),
                      const SizedBox(height: 12),
                      _Row(
                          label: _useBpc ? 'Equivalent gold' : 'Equivalent BPC',
                          value: _useBpc
                              ? '${_previewOther.toStringAsFixed(6)}g'
                              : '${_previewOther.toStringAsFixed(0)} BPC'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              PrimaryButton(
                label: 'Sell Gold',
                loading: _loading,
                onPressed: _sell,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _Row(
      {required this.label, required this.value, this.highlight = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label,
          style:
          const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
      Text(value,
          style: TextStyle(
              color: highlight ? AppTheme.goldLight : AppTheme.white,
              fontWeight: FontWeight.w700,
              fontSize: 14)),
    ],
  );
}