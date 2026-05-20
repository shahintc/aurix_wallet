import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../models/transaction.dart';
import '../../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final transactions = wallet.transactions;

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: transactions.isEmpty
          ? const Center(
        child: Text(
          'No transactions yet.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _HistoryTile(tx: transactions[index]);
        },
      ),
    );
  }
}

// ── Custom Tile for the History List ──────────────────────────────────────────
class _HistoryTile extends StatelessWidget {
  final Transaction tx;
  const _HistoryTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.isCredit;
    final amountColor = isCredit ? AppTheme.success : AppTheme.danger;
    final amountPrefix = isCredit ? '+' : '-';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.navyCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tx.icon, color: amountColor, size: 24),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.typeLabel,
                  style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                if (tx.counterparty != null) ...[
                  Text(
                    tx.counterparty!,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  _formatDate(tx.date),
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix${tx.bpcAmount.toStringAsFixed(0)} BPC',
                style: TextStyle(
                    color: amountColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${tx.usdAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year} at ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }
}