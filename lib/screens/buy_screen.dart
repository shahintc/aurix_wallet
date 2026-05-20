import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});
  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final _usdCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _previewGrams = 0;
  double _previewBpc = 0;
  bool _loading = false;

  void _recalc(String val) {
    final wallet = context.read<WalletProvider>();
    final usd = double.tryParse(val) ?? 0;
    setState(() {
      _previewGrams = wallet.usdToGrams(usd);
      _previewBpc = wallet.usdToBpc(usd);
    });
  }

  Future<void> _buy() async {
    if (!_formKey.currentState!.validate()) return;
    final usd = double.tryParse(_usdCtrl.text);
    if (usd == null) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final err = context.read<WalletProvider>().buyGold(usdAmount: usd);
    setState(() => _loading = false);
    if (err != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err), backgroundColor: AppTheme.danger));
      return;
    }
    _usdCtrl.clear();
    setState(() {
      _previewGrams = 0;
      _previewBpc = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gold purchased successfully!'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  void dispose() {
    _usdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buy Gold')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Gold price banner ──────────────────────
              AurixCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Live Gold Price',
                        style: TextStyle(color: AppTheme.textSecondary)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${wallet.goldPricePerGram.toStringAsFixed(2)}/g',
                          style: const TextStyle(
                              color: AppTheme.goldLight,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        Text(
                          '\$${wallet.goldPricePerOunce.toStringAsFixed(2)}/oz',
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const SectionLabel('Enter Amount'),

              // ── USD input ──────────────────────────────
              AmountField(
                controller: _usdCtrl,
                label: 'USD Amount',
                hint: '0.00',
                prefix: '\$ ',
                onChanged: _recalc,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter an amount.';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Must be greater than 0.';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ── Preview card ───────────────────────────
              if (_previewBpc > 0) ...[
                AurixCard(
                  child: Column(
                    children: [
                      _PreviewRow(
                          label: 'You receive',
                          value: '${_previewGrams.toStringAsFixed(6)}g',
                          highlight: true),
                      const SizedBox(height: 12),
                      _PreviewRow(
                          label: 'Aurix (BPC)',
                          value:
                          '${_previewBpc.toStringAsFixed(0)} BPC'),
                      const SizedBox(height: 12),
                      _PreviewRow(
                          label: 'Rate',
                          value: '1 BPC = 0.0001g gold'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Buy button ─────────────────────────────
              PrimaryButton(
                label: 'Buy Gold',
                loading: _loading,
                onPressed: _buy,
              ),

              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Current balance: ${wallet.bpcBalance.toStringAsFixed(0)} BPC',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _PreviewRow(
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
              fontSize: 14,
              fontWeight: FontWeight.w700)),
    ],
  );
}