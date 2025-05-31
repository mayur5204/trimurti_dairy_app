import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../services/database_service.dart';

/// GetX Controller for managing Customer operations
class CustomerController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Reactive lists
  final RxList<Customer> _customers = <Customer>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isFormVisible = false.obs;
  final Rx<Customer?> _selectedCustomer = Rx<Customer?>(null);

  // Getters
  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isFormVisible => _isFormVisible.value;
  Customer? get selectedCustomer => _selectedCustomer.value;

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  /// Load all customers from database
  Future<void> loadCustomers() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final customerList = await _databaseService.database.getAllCustomers();
      _customers.assignAll(customerList);
    } catch (e) {
      _error.value = 'Failed to load customers: $e';
      Get.snackbar(
        'Error',
        'Failed to load customers',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Create new customer
  Future<void> createCustomer({
    required String name,
    String? address,
    String? phone,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final companion = CustomersCompanion(
        name: Value(name),
        address: address != null ? Value(address) : const Value.absent(),
        phone: phone != null ? Value(phone) : const Value.absent(),
        isSynced: const Value(false),
      );

      // Perform database operation without blocking UI
      await _databaseService.database.insertCustomer(companion);

      // Refresh list efficiently without blocking UI
      await Future.microtask(() async {
        await loadCustomers();
      });
    } catch (e) {
      _error.value = 'Failed to create customer: $e';
      rethrow; // Let the UI handle the error display
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update existing customer
  Future<void> updateCustomer({
    required int id,
    required String name,
    String? address,
    String? phone,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final customer = _customers.firstWhere((c) => c.id == id);
      final updatedCustomer = customer.copyWith(
        name: name,
        address: Value(address),
        phone: Value(phone),
        isSynced: false, // Mark as not synced for future Firebase sync
      );

      // Perform database operation without blocking UI
      await _databaseService.database.updateCustomer(updatedCustomer);

      // Refresh list efficiently without blocking UI
      await Future.microtask(() async {
        await loadCustomers();
      });
    } catch (e) {
      _error.value = 'Failed to update customer: $e';
      rethrow; // Let the UI handle the error display
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete customer
  Future<void> deleteCustomer(int id) async {
    try {
      _isLoading.value = true;

      await _databaseService.database.deleteCustomer(id);
      await loadCustomers(); // Refresh list

      Get.snackbar(
        'Success',
        'Customer deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _error.value = 'Failed to delete customer: $e';
      Get.snackbar(
        'Error',
        'Failed to delete customer',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Show form for creating new customer
  void showCreateForm() {
    _selectedCustomer.value = null;
    _isFormVisible.value = true;
  }

  /// Show form for editing customer
  void showEditForm(Customer customer) {
    _selectedCustomer.value = customer;
    _isFormVisible.value = true;
  }

  /// Hide form
  void hideForm() {
    _isFormVisible.value = false;
    _selectedCustomer.value = null;
  }

  /// Search customers by name
  List<Customer> searchCustomers(String query) {
    if (query.isEmpty) return customers;

    return customers
        .where(
          (customer) =>
              customer.name.toLowerCase().contains(query.toLowerCase()) ||
              (customer.phone?.contains(query) ?? false),
        )
        .toList();
  }

  /// Clear error message
  void clearError() {
    _error.value = '';
  }
}
