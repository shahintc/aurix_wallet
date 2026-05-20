import 'package:flutter/material.dart';

enum TransactionType { buy, sell, send, receive }

class Transaction {
  final String id;
  final TransactionType type;
  final double bpcAmount;
  final double goldGrams;
  final double usdAmount;
  final DateTime date;
  final String status;
  final String? counterparty; // email or wallet ID for send/receive

  Transaction({
    required this.id,
    required this.type,
    required this.bpcAmount,
    required this.goldGrams,
    required this.usdAmount,
    required this.date,
    this.status = 'Completed',
    this.counterparty,
  });

  String get typeLabel {
    switch (type) {
      case TransactionType.buy:
        return 'Buy';
      case TransactionType.sell:
        return 'Sell';
      case TransactionType.send:
        return 'Send';
      case TransactionType.receive:
        return 'Receive';
    }
  }

  bool get isCredit =>
      type == TransactionType.buy || type == TransactionType.receive;

  IconData get icon {
    switch (type) {
      case TransactionType.buy:
        return Icons.add_circle_outline_rounded;
      case TransactionType.sell:
        return Icons.remove_circle_outline_rounded;
      case TransactionType.send:
        return Icons.arrow_upward_rounded;
      case TransactionType.receive:
        return Icons.arrow_downward_rounded;
    }
  }
}