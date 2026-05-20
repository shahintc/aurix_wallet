import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});
  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final _recipientCtrl = TextEditingController();
  final _amtCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    final amt = double.tryParse(_amtCtrl.text);
    final recipient = _recipientCtrl.text.trim();
    if (amt == null) return;

    setState(() => _loading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // NOTE: Make sure your WalletProvider has a sendPayment/sendBpc method
    // that accepts the amount and recipient string. Adjust the method name below if needed!
    final err = context.read<WalletProvider>().sendPayment(
        bpcAmt: amt,
        recipient: recipient
    );

    setState(() => _loading = false);

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: AppTheme.danger));
      return;
    }

    _amtCtrl.clear();
    _recipientCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Payment sent successfully!'),
          backgroundColor: AppTheme.success),
    );

    // Optionally pop back to dashboard after sending
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _amtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Send Payment')),
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
                        value: '${wallet.bpcBalance.toStringAsFixed(0)} BPC'),
                    const Icon(Icons.arrow_upward_rounded, color: AppTheme.goldLight),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const SectionLabel('Recipient Details'),

              // ── Recipient input ──────────────────────────────
              TextFormField(
                controller: _recipientCtrl,
                style: const TextStyle(color: AppTheme.white, fontSize: 16),
                decoration: const InputDecoration(
                  labelText: 'Email or Wallet ID',
                  hintText: 'user@example.com',
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.textSecondary),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter a recipient.';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              const SectionLabel('Amount to Send'),

              // ── Amount input ──────────────────────────────
              AmountField(
                controller: _amtCtrl,
                label: 'BPC Amount',
                hint: '0.00',
                suffix: 'BPC',
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter an amount.';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Must be greater than 0.';
                  if (n > wallet.bpcBalance) return 'Insufficient balance.';
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // ── Send button ─────────────────────────────
              PrimaryButton(
                label: 'Send Payment',
                loading: _loading,
                onPressed: _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}