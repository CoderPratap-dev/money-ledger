import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/db_service.dart';
import '../models/transaction.dart';
import '../models/user_config.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> _categories = [
    'Food',
    'Salary',
    'Rent',
    'Entertainment',
    'Utilities',
    'Other',
  ];

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Salary':
        return Colors.green;
      case 'Rent':
        return Colors.blue;
      case 'Entertainment':
        return Colors.purple;
      case 'Utilities':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  // Dialog Controllers
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  bool _isIncome = false;

  // State Variables for Filtering & Searching
  String _searchQuery = '';
  String _selectedFilter = 'All';

  // Track budget updates across rebuilds
  UserConfig? _currentConfig;
  double _thisMonthsSpending = 0.0;

  @override
  void initState() {
    super.initState();
    _refreshBudgetConfig();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Consolidated setup reads from a clean database instance thread without crashing
  Future<void> _refreshBudgetConfig() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final tempIsar = await Isar.open(
        [UserConfigSchema],
        directory: dir.path,
        name: 'config_db',
      );
      final config = await tempIsar.userConfigs.where().findFirst();
      await tempIsar.close();

      // Dynamically load calculated transaction volumes for the current calendar month
      final monthlySpend = await DbService.getThisMonthsTotalSpending();

      if (mounted) {
        setState(() {
          _currentConfig = config;
          _thisMonthsSpending = monthlySpend;
        });
      }
    } catch (e) {
      debugPrint("Warning sync tracking failure: $e");
    }
  }

  Stream<List<LocalTransaction>> _listenToTransactions() {
    return DbService.instance.localTransactions.where().sortByDateDesc().watch(
      fireImmediately: true,
    );
  }

  Future<void> _exportToHTML(List<LocalTransaction> transactions) async {
    try {
      if (transactions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No transactions available to export!')),
        );
        return;
      }

      StringBuffer htmlContent = StringBuffer();
      htmlContent.write('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <title>Financial Ledger Report</title>
          <style>
            body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 30px; color: #333; }
            h2 { color: #1a73e8; margin-bottom: 5px; }
            .date-meta { color: #666; font-size: 14px; margin-bottom: 25px; }
            table { width: 100%; border-collapse: collapse; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
            th, td { padding: 12px 15px; border: 1px solid #e0e0e0; text-align: left; }
            th { background-color: #f8f9fa; font-weight: 600; color: #495057; }
            .income-row { color: #1b5e20; background-color: #e8f5e9; font-weight: 500; }
            .expense-row { color: #b71c1c; background-color: #ffebee; font-weight: 500; }
          </style>
        </head>
        <body>
          <h2>Secure Financial Ledger Report</h2>
          <div class="date-meta">Generated on: ${DateTime.now().toString().substring(0, 16)}</div>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Type</th>
                <th>Title</th>
                <th>Category</th>
                <th>Amount</th>
                <th>Date</th>
              </tr>
            </thead>
            <tbody>
      ''');

      for (var tx in transactions) {
        final isInc = tx.isIncome;
        final rowClass = isInc ? 'income-row' : 'expense-row';
        final typeLabel = isInc ? 'Income' : 'Expense';
        final signPrefix = isInc ? '+' : '-';

        htmlContent.write('''
          <tr class="$rowClass">
            <td>${tx.id ?? ''}</td>
            <td>$typeLabel</td>
            <td>${tx.title}</td>
            <td>${tx.category}</td>
            <td>$signPrefix\$${tx.amount.toStringAsFixed(2)}</td>
            <td>${tx.date.toString().substring(0, 10)}</td>
          </tr>
        ''');
      }

      htmlContent.write('</tbody></table></body></html>');

      final directory = await getTemporaryDirectory();
      final path =
          "${directory.path}/Ledger_Report_${DateTime.now().millisecondsSinceEpoch}.html";
      final file = File(path);

      await file.writeAsString(htmlContent.toString());

      final XFile xFile = XFile(file.path, mimeType: 'text/html');
      await Share.shareXFiles([
        xFile,
      ], text: 'My Color-Coded Financial Ledger Export');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export Failed: $e')));
      }
    }
  }

  void _showAddTransactionDialog() {
    _titleController.clear();
    _amountController.clear();
    setState(() {
      _selectedCategory = 'Food';
      _isIncome = false;
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Transaction'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ToggleButtons(
                  isSelected: [!_isIncome, _isIncome],
                  onPressed: (index) {
                    setDialogState(() => _isIncome = index == 1);
                  },
                  borderRadius: BorderRadius.circular(8),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Expense'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Income'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => _selectedCategory = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              // FIXED: Passing dialog context down to handle pops correctly
              onPressed: () => _saveTransaction(context),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // FIXED: Accepts explicit dialog context to avoid background route popping errors
  void _saveTransaction(BuildContext dialogContext) async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isEmpty || amount <= 0) {
      // FIXED: Added helpful warning so UI doesn't freeze silently on faulty inputs
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and amount.')),
      );
      return;
    }

    final tx = LocalTransaction()
      ..title = title
      ..amount = amount
      ..category = _selectedCategory
      ..isIncome = _isIncome
      ..date = DateTime.now();

    await DbService.instance.writeTxn(() async {
      await DbService.instance.localTransactions.put(tx);
    });

    if (mounted) {
      Navigator.pop(dialogContext); // Explicitly closes target dialog
      _refreshBudgetConfig(); // Refreshes banner calculations instantly
    }
  }

  void _deleteTransaction(Id id) async {
    await DbService.instance.writeTxn(() async {
      await DbService.instance.localTransactions.delete(id);
    });
    _refreshBudgetConfig();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LocalTransaction>>(
      stream: _listenToTransactions(),
      builder: (context, snapshot) {
        final txList = snapshot.data ?? [];

        double totalIncome = 0;
        double totalExpense = 0;

        Map<String, double> categoryMap = {};

        for (var tx in txList) {
          if (tx.isIncome) {
            totalIncome += tx.amount;
          } else {
            totalExpense += tx.amount;
            categoryMap[tx.category] =
                (categoryMap[tx.category] ?? 0.0) + tx.amount;
          }
        }
        final balance = totalIncome - totalExpense;

        List<PieChartSectionData> chartSections = [];
        categoryMap.forEach((category, totalAmount) {
          final percentage = totalExpense > 0
              ? (totalAmount / totalExpense) * 100
              : 0.0;
          chartSections.add(
            PieChartSectionData(
              color: _getCategoryColor(category),
              value: totalAmount,
              title: '${percentage.toStringAsFixed(0)}%',
              radius: 40,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        });

        final filteredList = txList.where((tx) {
          final matchesSearch =
              tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              tx.category.toLowerCase().contains(_searchQuery.toLowerCase());
          bool matchesType = true;
          if (_selectedFilter == 'Income') matchesType = tx.isIncome;
          if (_selectedFilter == 'Expenses') matchesType = !tx.isIncome;

          return matchesSearch && matchesType;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Secure Ledger'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.account_balance_wallet_rounded),
                tooltip: 'Budget Settings',
                onPressed: () async {
                  await Navigator.pushNamed(context, '/budget');
                  await _refreshBudgetConfig(); // Re-read metrics cleanly on returning
                },
              ),
              IconButton(
                icon: const Icon(Icons.ios_share_rounded),
                tooltip: 'Export Color-Coded Report',
                onPressed: () => _exportToHTML(txList),
              ),
              IconButton(
                icon: const Icon(Icons.lock, color: Colors.redAccent),
                onPressed: () async {
                  await DbService.lockDatabase();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddTransactionDialog,
            child: const Icon(Icons.add),
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _refreshBudgetConfig,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Text(
                                    'Net Balance',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '\$${balance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: balance >= 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),

                                  // FIXED/ADDED: Persistent monthly budget descriptor string display
                                  if (_currentConfig != null &&
                                      _currentConfig!.globalMonthlyBudget !=
                                          null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      'Monthly Budget Limit: \$${_currentConfig!.globalMonthlyBudget!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            'Income',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '\$${totalIncome.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'Expenses',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '\$${totalExpense.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Display structural monthly context banners cleanly
                          if (_currentConfig != null &&
                              _currentConfig!.globalMonthlyBudget != null) ...[
                            Builder(
                              builder: (context) {
                                final cap =
                                    _currentConfig!.globalMonthlyBudget!;
                                if (cap <= 0) return const SizedBox.shrink();

                                final usageRatio = _thisMonthsSpending / cap;

                                if (usageRatio >= 1.0) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Card(
                                      color: Colors.red.shade400,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        title: const Text(
                                          'Budget Cap Exceeded!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Spent \$${_thisMonthsSpending.toStringAsFixed(2)} of \$${cap.toStringAsFixed(2)} limit this month.',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (usageRatio >= 0.85) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Card(
                                      color: Colors.orange.shade400,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        title: const Text(
                                          'Approaching Budget Limit',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'You have consumed ${(usageRatio * 100).toStringAsFixed(0)}% of your monthly cap (\$${cap.toStringAsFixed(2)}).',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                          const SizedBox(height: 16),

                          if (totalExpense > 0)
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Expense Distribution',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 140,
                                      child: PieChart(
                                        PieChartData(
                                          sections: chartSections,
                                          centerSpaceRadius: 35,
                                          sectionsSpace: 2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 6,
                                      children: categoryMap.keys.map((cat) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: _getCategoryColor(cat),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              cat,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),

                          TextField(
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search title or category...',
                              prefixIcon: const Icon(Icons.search),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: ['All', 'Income', 'Expenses'].map((
                              filterType,
                            ) {
                              final isSelected = _selectedFilter == filterType;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(filterType),
                                  selected: isSelected,
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      setState(
                                        () => _selectedFilter = filterType,
                                      );
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'History',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final tx = filteredList[index];
                              final txId = tx.id ?? 0;
                              return Dismissible(
                                key: Key(txId.toString()),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => _deleteTransaction(txId),
                                child: Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: tx.isIncome
                                          ? Colors.green.withAlpha(51)
                                          : Colors.red.withAlpha(51),
                                      child: Icon(
                                        tx.isIncome
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        color: tx.isIncome
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    title: Text(
                                      tx.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${tx.category} • ${tx.date.day}/${tx.date.month}',
                                    ),
                                    trailing: Text(
                                      '${tx.isIncome ? "+" : "-"}\$${tx.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: tx.isIncome
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (filteredList.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: Text('No matching records found.'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
