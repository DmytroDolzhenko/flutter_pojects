import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'category_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  void _addExpense() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() {
      final newExpense = Expense(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: DateTime.now(),
      );

      _expenses.add(newExpense);

      _titleController.clear();
      _amountController.clear();
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _expenses.addAll([
      Expense(
        id: 1,
        title: 'Lunch',
        amount: 25.00,
        category: ExpenseCategory.food,
        date: DateTime.now(),
      ),
      Expense(
        id: 2,
        title: 'Uber',
        amount: 15.50,
        category: ExpenseCategory.transport,
        date: DateTime.now(),
      ),
      Expense(
        id: 3,
        title: 'Clothes',
        amount: 80.00,
        category: ExpenseCategory.shopping,
        date: DateTime.now(),
      ),
      Expense(
        id: 4,
        title: 'Groceries',
        amount: 60.00,
        category: ExpenseCategory.food,
        date: DateTime.now(),
      ),
      Expense(
        id: 5,
        title: 'Movie',
        amount: 12.00,
        category: ExpenseCategory.other,
        date: DateTime.now(),
      ),
      Expense(
        id: 6,
        title: 'Bus Ticket',
        amount: 2.50,
        category: ExpenseCategory.transport,
        date: DateTime.now(),
      ),
      Expense(
        id: 7,
        title: 'Books',
        amount: 30.00,
        category: ExpenseCategory.shopping,
        date: DateTime.now(),
      ),
    ]);
  }

  double get _totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double _getCategoryTotal(ExpenseCategory category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(
              'Total: \$${_totalExpenses.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: ExpenseCategory.values.length,
              itemBuilder: (context, index) {
                final category = ExpenseCategory.values[index];
                return CategoryCard(
                  category: category,
                  totalAmount: _getCategoryTotal(category),
                  onTap: () => _navigateToCategoryDetails(category),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: _expenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No data yet',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to add',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      final expense = _expenses[index];
                      return Dismissible(
                        key: Key(expense.id.toString()),
                        onDismissed: (direction) => _deleteExpense(expense.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          leading: Icon(
                            expense.category.icon,
                            color: expense.category.color,
                          ),
                          title: Text(expense.title),
                          subtitle: Text(expense.formattedDate),
                          trailing: Text(
                            expense.formattedAmount,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '\$',
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButton(
                    value: _selectedCategory,
                    items: ExpenseCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(category.icon, color: category.color),
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() => _selectedCategory = value!);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _titleController.clear();
                    _amountController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: _addExpense,
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _navigateToCategoryDetails(ExpenseCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CategoryDetailsScreen(category: category, expenses: _expenses),
      ),
    );
  }

  void _deleteExpense(int id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Expense deleted')));
  }
}
