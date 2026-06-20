import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test/routes/app_routes.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  // 1. Define GlobalKeys for each field we want to highlight in the showcase tour.
  final GlobalKey _titleKey = GlobalKey();
  // final GlobalKey _amountKey = GlobalKey();
  // final GlobalKey _typeKey = GlobalKey();
  // final GlobalKey _merchantKey = GlobalKey();
  // final GlobalKey _categoryKey = GlobalKey();
  // final GlobalKey _paymentMethodKey = GlobalKey();
  // final GlobalKey _dateKey = GlobalKey();
  // final GlobalKey _notesKey = GlobalKey();
  final GlobalKey _saveKey = GlobalKey();

  // Local state parameters
  final _formKey = GlobalKey<FormState>();
  String _transactionType = 'Expense'; // Default type
  String? _selectedCategory = 'Food'; // Default category
  String _paymentMethod = 'Cash'; // Default payment method
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Storage and showcase controls
  late GetStorage _box;
  bool _isStorageInitialized = false;

  @override
  void initState() {
    super.initState();
    // Register the showcase scope synchronously during initState.
    // This ensures that when Showcase widgets build, the scope is immediately registered.
    _registerShowcase();
    _initializeStorage();
  }

  // 2. Asynchronous GetStorage Initialization
  Future<void> _initializeStorage() async {
    // We dynamically initialize a dedicated local storage container for transactions
    await GetStorage.init('TransactionFormPrefs');
    _box = GetStorage('TransactionFormPrefs');

    // Read the boolean flag. If the user has never completed/skipped the tutorial, it returns false.
    final bool hasSeenTutorial =
        _box.read<bool>('hasSeenTransactionTutorial') ?? false;

    if (!hasSeenTutorial) {
      setState(() {
        _isStorageInitialized = true;
      });

      // 4. Trigger showcase view after the widgets have fully built and rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowcaseView.getNamed('transaction_form_scope').startShowCase([
          _titleKey,
          // _amountKey,
          // _typeKey,
          // _merchantKey,
          // _categoryKey,
          // _paymentMethodKey,
          // _dateKey,
          // _notesKey,
          _saveKey,
        ]);
      });
    } else {
      // User has already completed the onboarding flow, just render form normally
      setState(() {
        _isStorageInitialized = true;
      });
    }
  }

  // 3. Helper to register the Showcase scope with custom config and auto-scrolling
  void _registerShowcase() {
    ShowcaseView.register(
      enableAutoScroll: true,
      scrollDuration: const Duration(milliseconds: 300),
      scope: 'transaction_form_scope',
      blurValue: 1.5, // Background overlay dim intensity
      onFinish: _markTutorialAsSeen,
      onDismiss: (key) => _markTutorialAsSeen(),
      globalTooltipActionConfig: const TooltipActionConfig(
        position: TooltipActionPosition.inside,
        alignment: MainAxisAlignment.spaceBetween,
      ),
      globalTooltipActions: [
        // Add a custom next and skip button to the guide bubble
        TooltipActionButton(
          type: TooltipDefaultActionType.skip,
          name: 'Skip Guide',
          backgroundColor: Colors.grey.shade300,
          textStyle: const TextStyle(color: Colors.black87, fontSize: 13),
          onTap: () {
            // Mark tutorial as completed immediately when user taps Skip
            _markTutorialAsSeen();
            ShowcaseView.getNamed('transaction_form_scope').dismiss();
            
            // Navigate to a new screen (e.g. Language list screen)
            Get.toNamed(AppRoutes.LANGUAGE);
          },
        ),
        TooltipActionButton(
          type: TooltipDefaultActionType.next,
          name: 'Next',
          backgroundColor: Colors.teal.shade700,
          textStyle: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }

  // Persists the tutorial completed flag
  void _markTutorialAsSeen() {
    _box.write('hasSeenTransactionTutorial', true);
  }

  // Clears the tutorial flag for testing / replaying purposes
  void _resetTutorialForTesting() {
    _box.write('hasSeenTransactionTutorial', false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Onboarding guide reset! Restart the screen or tap help to replay.',
        ),
        backgroundColor: Colors.teal,
      ),
    );
    // Restart showcase immediately with consistent config
    _registerShowcase();
    ShowcaseView.getNamed('transaction_form_scope').startShowCase([
      _titleKey,
      // _amountKey,
      // _typeKey,
      // _merchantKey,
      // _categoryKey,
      // _paymentMethodKey,
      // _dateKey,
      // _notesKey,
      _saveKey,
    ]);
  }

  @override
  void dispose() {
    // 5. Cleanup the registered showcase scope to avoid memory leaks
    ShowcaseView.getNamed('transaction_form_scope').unregister();
    _titleController.dispose();
    _amountController.dispose();
    _merchantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Select Date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isStorageInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FB),
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          // Restart Onboarding Guide Button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Replay Walkthrough',
            onPressed: _resetTutorialForTesting,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Headline Title Card
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 28,
                        color: Colors.teal.shade700,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Record New Transaction',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 1. Transaction Title Input
              Showcase(
                key: _titleKey,
                title: 'Transaction Description',
                description:
                    'Enter a name or details of what this transaction is about (e.g. "Grocery Shopping", "Salary").',
                scope: 'transaction_form_scope',
                targetBorderRadius: BorderRadius.circular(8),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Colors.teal,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.teal.shade700,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Amount Input
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: Colors.teal,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.teal.shade700,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Toggle Category: Expense / Income
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Flow Type',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      fillColor: _transactionType == 'Expense'
                          ? Colors.redAccent.shade100
                          : Colors.greenAccent.shade200,
                      selectedColor: Colors.black87,
                      color: Colors.grey,
                      isSelected: [
                        _transactionType == 'Expense',
                        _transactionType == 'Income',
                      ],
                      onPressed: (index) {
                        setState(() {
                          _transactionType = index == 0 ? 'Expense' : 'Income';
                        });
                      },
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
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3.5. Merchant / Payee Input
              TextFormField(
                controller: _merchantController,
                decoration: InputDecoration(
                  labelText: 'Merchant / Payee',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: const Icon(Icons.store, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.teal.shade700,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Category Dropdown Selector
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: const Icon(Icons.category, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.teal.shade700,
                      width: 2,
                    ),
                  ),
                ),
                items:
                    [
                          'Food',
                          'Travel',
                          'Utilities',
                          'Entertainment',
                          'Salary',
                          'Others',
                        ]
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 4.5. Payment Method Dropdown
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: const Icon(Icons.payment, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.teal.shade700,
                      width: 2,
                    ),
                  ),
                ),
                items:
                    [
                          'Cash',
                          'Credit Card',
                          'Debit Card',
                          'Bank Transfer',
                          'Mobile Payment',
                        ]
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value ?? 'Cash';
                  });
                },
              ),
              const SizedBox(height: 16),

              // 5. Date Picker Row
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.teal),
                          const SizedBox(width: 12),
                          Text(
                            'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Choose',
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 5.5. Notes / Remarks Input (Multiline)
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes / Remarks',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: const Icon(Icons.note_alt, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.teal.shade700,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 6. Submit Button
              Showcase(
                key: _saveKey,
                title: 'Save Transaction',
                description:
                    'Tap here to save this transaction. It will be added to your transaction history.',
                scope: 'transaction_form_scope',
                targetBorderRadius: BorderRadius.circular(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 1,
                  ),
                  onPressed: () {
                    final title = _titleController.text.trim();
                    final amount = _amountController.text.trim();
                    if (title.isEmpty || amount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a description and amount.',
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Saved: $title ($amount) as $_transactionType',
                        ),
                        backgroundColor: Colors.teal,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save Transaction',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
