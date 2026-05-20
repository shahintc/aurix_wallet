import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/transaction.dart';
import 'buy_screen.dart';
import 'sell_screen.dart';
import 'send_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardAnim;

  @override
  void initState() {
    super.initState();
    _cardAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
  }

  @override
  void dispose() {
    _cardAnim.dispose();
    super.dispose();
  }

  void _go(Widget screen) => Navigator.push(
      context, MaterialPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ────────────────────────────────────────
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Good day,',
                            style: TextStyle(
                                color: AppTheme.textSecondary, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(
                          wallet.userEmail.split('@').first,
                          style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    // Gold price badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.navyCard,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'XAU \$${wallet.goldPricePerGram.toStringAsFixed(2)}/g',
                            style: const TextStyle(
                                color: AppTheme.goldLight,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Balance card ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SlideTransition(
                  position: Tween<Offset>(
                      begin: const Offset(0, 0.15), end: Offset.zero)
                      .animate(CurvedAnimation(
                      parent: _cardAnim, curve: Curves.easeOutCubic)),
                  child: FadeTransition(
                    opacity: _cardAnim,
                    child: _BalanceCard(wallet: wallet),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Quick actions ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _ActionButton(
                        label: 'Buy',
                        icon: Icons.add_rounded,
                        color: AppTheme.success,
                        onTap: () => _go(const BuyScreen())),
                    const SizedBox(width: 12),
                    _ActionButton(
                        label: 'Sell',
                        icon: Icons.remove_rounded,
                        color: AppTheme.danger,
                        onTap: () => _go(const SellScreen())),
                    const SizedBox(width: 12),
                    _ActionButton(
                        label: 'Send',
                        icon: Icons.arrow_upward_rounded,
                        color: AppTheme.gold,
                        onTap: () => _go(const SendScreen())),
                    const SizedBox(width: 12),
                    _ActionButton(
                        label: 'History',
                        icon: Icons.receipt_long_rounded,
                        color: AppTheme.textSecondary,
                        onTap: () => _go(const HistoryScreen())),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Recent transactions ────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionLabel('Recent Activity'),
                    GestureDetector(
                      onTap: () => _go(const HistoryScreen()),
                      child: const Text('See all',
                          style: TextStyle(
                              color: AppTheme.gold,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              ...wallet.transactions.take(5).map(
                    (tx) => _TxTile(tx: tx),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Balance card widget ───────────────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  final WalletProvider wallet;
  const _BalanceCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2845), Color(0xFF0F1A2F)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gold bar accent line
          Row(
            children: [
              Container(
                width: 28,
                height: 4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.goldLight, AppTheme.gold]),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Aurix Wallet',
                  style:
                  TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 20),

          // USD balance (primary)
          Text(
            '\$${wallet.usdBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Total value in USD',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),

          const SizedBox(height: 24),

          // Divider
          Container(height: 1, color: AppTheme.border),
          const SizedBox(height: 20),

          // Gold & BPC stats
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: 'Gold Balance',
                  value: '${wallet.goldGrams.toStringAsFixed(4)}g',
                  valueColor: AppTheme.goldLight,
                ),
              ),
              Expanded(
                child: StatTile(
                  label: 'Aurix (BPC)',
                  value:
                  '${wallet.bpcBalance.toStringAsFixed(0)} BPC',
                  valueColor: AppTheme.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.label,
        required this.icon,
        required this.color,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.navyCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Transaction tile ──────────────────────────────────────────────────────────
class _TxTile extends StatelessWidget {
  final Transaction tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.isCredit;
    final amountColor = isCredit ? AppTheme.success : AppTheme.danger;
    final amountPrefix = isCredit ? '+' : '-';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tx.icon, color: amountColor, size: 20),
          ),
          const SizedBox(width: 14),

          // Type + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.counterparty != null
                      ? '${tx.typeLabel} • ${tx.counterparty}'
                      : tx.typeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 3),
              Text(
                '\$${tx.usdAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${d.day}/${d.month}/${d.year}';
  }
}