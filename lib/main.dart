import 'package:flutter/material.dart';

void main() {
  runApp(const AmraProbashiApp());
}

class AmraProbashiApp extends StatelessWidget {
  const AmraProbashiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'আমরা প্রবাসী',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ProbashiHomeScreen(),
    );
  }
}

class ProbashiHomeScreen extends StatefulWidget {
  const ProbashiHomeScreen({super.key});

  @override
  State<ProbashiHomeScreen> createState() => _ProbashiHomeScreenState();
}

class _ProbashiHomeScreenState extends State<ProbashiHomeScreen> {
  double income = 0;
  double expense = 0;
  double remittance = 0;
  double savings = 0;

  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'আয় (বেতন)';

  final List<String> categories = [
    'আয় (বেতন)',
    'দৈনন্দিন খরচ',
    'রেমিট্যান্স (দেশে পাঠানো)',
    'সঞ্চয়',
  ];

  void _addEntry() {
    final double? value = double.tryParse(amountController.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সঠিক টাকার পরিমাণ লিখুন')),
      );
      return;
    }

    setState(() {
      if (selectedCategory == 'আয় (বেতন)') {
        income += value;
      } else if (selectedCategory == 'দৈনন্দিন খরচ') {
        expense += value;
      } else if (selectedCategory == 'রেমিট্যান্স (দেশে পাঠানো)') {
        remittance += value;
      } else if (selectedCategory == 'সঞ্চয়') {
        savings += value;
      }
      amountController.clear();
    });
  }

  double get balance => income - expense - remittance - savings;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আমরা প্রবাসী'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'হাতে অবশিষ্ট ব্যালেন্স',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      balance.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                _summaryCard('মোট আয়', income, Colors.green),
                _summaryCard('দৈনন্দিন খরচ', expense, Colors.red),
                _summaryCard('রেমিট্যান্স', remittance, Colors.blue),
                _summaryCard('সঞ্চয়', savings, Colors.orange),
              ],
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'হিসাবের ধরন',
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedCategory = val);
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'পরিমাণ লিখুন',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'হিসাবে যুক্ত করুন',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, double amount, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              amount.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
