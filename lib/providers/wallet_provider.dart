import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../models/transaction.dart';

class WalletProvider extends ChangeNotifier {
  // ── User ──────────────────────────────────────────────
  String _userEmail = '';
  String get userEmail => _userEmail;

  void setUser(String email) {
    _userEmail = email;
    notifyListeners();
  }

  // ── Constants ─────────────────────────────────────────
  // 1 BPC = 0.0001 grams of gold  →  10,000 BPC = 1 gram
  static const double bpcPerGram = 10000.0;

  // ── Gold Price (simulated live) ───────────────────────
  double _goldPricePerGram = 75.51; // USD per gram
  double get goldPricePerGram => _goldPricePerGram;
  double get goldPricePerOunce => _goldPricePerGram * 31.1035;

  Timer? _priceTimer;

  void startLivePriceSimulation() {
    _priceTimer?.cancel();
    _priceTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      final rng = Random();
      final change = (rng.nextDouble() - 0.48) * 0.60; // small fluctuation
      _goldPricePerGram = (_goldPricePerGram + change).clamp(70.0, 85.0);
      notifyListeners();
    });
  }

  void stopLivePriceSimulation() => _priceTimer?.cancel();

  // ── Balances ──────────────────────────────────────────
  double _bpcBalance = 24500.0;
  double get bpcBalance => _bpcBalance;
  double get goldGrams => _bpcBalance / bpcPerGram;
  double get usdBalance => goldGrams * _goldPricePerGram;

  // ── Transactions ─────────────────────────────────────
  final List<Transaction> _transactions = [
    Transaction(
      id: 'txn_001',
      type: TransactionType.buy,
      bpcAmount: 10000,
      goldGrams: 1.0,
      usdAmount: 75.51,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 'txn_002',
      type: TransactionType.receive,
      bpcAmount: 5000,
      goldGrams: 0.5,
      usdAmount: 37.76,
      date: DateTime.now().subtract(const Duration(days: 1)),
      counterparty: 'ali@example.com',
    ),
    Transaction(
      id: 'txn_003',
      type: TransactionType.buy,
      bpcAmount: 9500,
      goldGrams: 0.95,
      usdAmount: 71.73,
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  List<Transaction> get transactions =>
      List.unmodifiable(_transactions.reversed.toList());

  // ── Helpers ───────────────────────────────────────────
  double usdToGrams(double usd) => usd / _goldPricePerGram;
  double usdToBpc(double usd) => usdToGrams(usd) * bpcPerGram;
  double gramsToBpc(double grams) => grams * bpcPerGram;
  double gramsToUsd(double grams) => grams * _goldPricePerGram;
  double bpcToGrams(double bpc) => bpc / bpcPerGram;
  double bpcToUsd(double bpc) => bpcToGrams(bpc) * _goldPricePerGram;

  // ── Buy Gold ──────────────────────────────────────────
  /// Returns null on success, error string on failure.
  String? buyGold({required double usdAmount}) {
    if (usdAmount <= 0) return 'Enter a valid USD amount.';
    final bpc = usdToBpc(usdAmount);
    final grams = usdToGrams(usdAmount);
    _bpcBalance += bpc;
    _transactions.add(Transaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.buy,
      bpcAmount: bpc,
      goldGrams: grams,
      usdAmount: usdAmount,
      date: DateTime.now(),
    ));
    notifyListeners();
    return null;
  }

  // ── Sell Gold ─────────────────────────────────────────
  String? sellGold({double? grams, double? bpc}) {
    final bpcAmt = bpc ?? (grams != null ? gramsToBpc(grams) : 0.0);
    if (bpcAmt <= 0) return 'Enter a valid amount.';
    if (bpcAmt > _bpcBalance) return 'Insufficient balance.';
    final gramsAmt = bpcToGrams(bpcAmt);
    final usd = bpcToUsd(bpcAmt);
    _bpcBalance -= bpcAmt;
    _transactions.add(Transaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.sell,
      bpcAmount: bpcAmt,
      goldGrams: gramsAmt,
      usdAmount: usd,
      date: DateTime.now(),
    ));
    notifyListeners();
    return null;
  }

  // ── Send Payment ──────────────────────────────────────
  String? sendPayment({required double bpcAmt, required String recipient}) {
    if (bpcAmt <= 0) return 'Amount must be greater than zero.';
    if (bpcAmt > _bpcBalance) return 'Insufficient balance.';
    if (recipient.trim().isEmpty) return 'Enter a recipient email or wallet ID.';
    _bpcBalance -= bpcAmt;
    _transactions.add(Transaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.send,
      bpcAmount: bpcAmt,
      goldGrams: bpcToGrams(bpcAmt),
      usdAmount: bpcToUsd(bpcAmt),
      date: DateTime.now(),
      counterparty: recipient.trim(),
    ));
    notifyListeners();
    return null;
  }

  @override
  void dispose() {
    _priceTimer?.cancel();
    super.dispose();
  }
}