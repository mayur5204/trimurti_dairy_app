import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../services/database_service.dart';

/// GetX Controller for managing Payment operations
class PaymentController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Reactive lists
  final RxList<Payment> _payments = <Payment>[].obs;
  final RxList<Customer> _customers = <Customer>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isFormVisible = false.obs;
  final Rx<Payment?> _selectedPayment = Rx<Payment?>(null);

  // Getters
  List<Payment> get payments => _payments;
  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isFormVisible => _isFormVisible.value;
  Payment? get selectedPayment => _selectedPayment.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load all necessary data (payments and customers)
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      // Load payments and customers in parallel
      final results = await Future.wait([
        _databaseService.database.getAllPayments(),
        _databaseService.database.getAllCustomers(),
      ]);

      _payments.assignAll(results[0] as List<Payment>);
      _customers.assignAll(results[1] as List<Customer>);
    } catch (e) {
      _error.value = 'Failed to load data: $e';
      Get.snackbar(
        'Error',
        'Failed to load payments data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load only payments data
  Future<void> loadPayments() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final paymentList = await _databaseService.database.getAllPayments();
      _payments.assignAll(paymentList);
    } catch (e) {
      _error.value = 'Failed to load payments: $e';
      Get.snackbar(
        'Error',
        'Failed to load payments',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Create new payment
  Future<void> createPayment({
    required int customerId,
    required DateTime date,
    required double amount,
    String? description,
  }) async {
    try {
      _isLoading.value = true;

      final companion = PaymentsCompanion(
        customerId: Value(customerId),
        date: Value(date),
        amount: Value(amount),
        description: description != null
            ? Value(description)
            : const Value.absent(),
        isSynced: const Value(false),
      );

      await _databaseService.database.insertPayment(companion);

      // Use Future.microtask for better performance
      await Future.microtask(() async {
        await loadPayments(); // Refresh list
      });
    } catch (e) {
      _error.value = 'Failed to create payment: $e';
      rethrow; // Let the UI handle error display
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update existing payment
  Future<void> updatePayment({
    required int id,
    required int customerId,
    required DateTime date,
    required double amount,
    String? description,
  }) async {
    try {
      _isLoading.value = true;

      final payment = _payments.firstWhere((p) => p.id == id);
      final updatedPayment = payment.copyWith(
        customerId: customerId,
        date: date,
        amount: amount,
        description: Value(description),
        updatedAt: DateTime.now(),
        isSynced: false, // Mark as not synced for future Firebase sync
      );

      await _databaseService.database.updatePayment(updatedPayment);

      // Use Future.microtask for better performance
      await Future.microtask(() async {
        await loadPayments(); // Refresh list
      });
    } catch (e) {
      _error.value = 'Failed to update payment: $e';
      rethrow; // Let the UI handle error display
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete payment
  Future<void> deletePayment(int id) async {
    try {
      _isLoading.value = true;

      await _databaseService.database.deletePayment(id);
      await loadPayments(); // Refresh list

      Get.snackbar(
        'Success',
        'Payment deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _error.value = 'Failed to delete payment: $e';
      Get.snackbar(
        'Error',
        'Failed to delete payment',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Show form for creating new payment
  void showCreateForm() {
    _selectedPayment.value = null;
    _isFormVisible.value = true;
  }

  /// Show form for editing payment
  void showEditForm(Payment payment) {
    _selectedPayment.value = payment;
    _isFormVisible.value = true;
  }

  /// Hide form
  void hideForm() {
    _isFormVisible.value = false;
    _selectedPayment.value = null;
  }

  /// Get customer name by ID
  String getCustomerName(int customerId) {
    try {
      final customer = _customers.firstWhere((c) => c.id == customerId);
      return customer.name;
    } catch (e) {
      return 'Unknown Customer';
    }
  }

  /// Get payments for a specific customer
  List<Payment> getPaymentsByCustomer(int customerId) {
    return _payments
        .where((payment) => payment.customerId == customerId)
        .toList();
  }

  /// Get payments for a specific date range
  List<Payment> getPaymentsByDateRange(DateTime startDate, DateTime endDate) {
    return _payments
        .where(
          (payment) =>
              payment.date.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              payment.date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();
  }

  /// Calculate total payments received
  double get totalPayments {
    return _payments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Calculate total payments for a specific customer
  double getTotalPaymentsForCustomer(int customerId) {
    return _payments
        .where((payment) => payment.customerId == customerId)
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Clear error message
  void clearError() {
    _error.value = '';
  }
}
