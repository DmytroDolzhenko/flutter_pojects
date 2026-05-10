import '../models/category.dart';

class Expense {
  final int id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';

}