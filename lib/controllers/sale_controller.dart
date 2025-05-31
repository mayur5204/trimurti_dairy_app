import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../services/database_service.dart';

/// GetX Controller for managing Sale operations
class SaleController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Reactive lists
  final RxList<Sale> _sales = <Sale>[].obs;
  final RxList<Customer> _customers = <Customer>[].obs;
  final RxList<MilkType> _milkTypes = <MilkType>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isFormVisible = false.obs;
  final Rx<Sale?> _selectedSale = Rx<Sale?>(null);

  // Getters
  List<Sale> get sales => _sales;
  List<Customer> get customers => _customers;
  List<MilkType> get milkTypes => _milkTypes;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isFormVisible => _isFormVisible.value;
  Sale? get selectedSale => _selectedSale.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load all necessary data (sales, customers, milk types)
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      // Load all data in parallel
      final results = await Future.wait([
        _databaseService.database.getAllSales(),
        _databaseService.database.getAllCustomers(),
        _databaseService.database.getAllMilkTypes(),
      ]);

      _sales.assignAll(results[0] as List<Sale>);
      _customers.assignAll(results[1] as List<Customer>);
      _milkTypes.assignAll(results[2] as List<MilkType>);
    } catch (e) {
      _error.value = 'Failed to load data: $e';
      Get.snackbar(
        'Error',
        'Failed to load sales data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load only sales data
  Future<void> loadSales() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final saleList = await _databaseService.database.getAllSales();
      _sales.assignAll(saleList);
    } catch (e) {
      _error.value = 'Failed to load sales: $e';
      Get.snackbar(
        'Error',
        'Failed to load sales',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Create new sale
  Future<void> createSale({
    required int customerId,
    required int milkTypeId,
    required DateTime date,
    required double quantity,
    required double rate,
    String? notes,
  }) async {
    try {
      _isLoading.value = true;

      final companion = SalesCompanion(
        customerId: Value(customerId),
        milkTypeId: Value(milkTypeId),
        date: Value(date),
        quantity: Value(quantity),
        rate: Value(rate),
        notes: notes != null ? Value(notes) : const Value.absent(),
        isSynced: const Value(false),
      );

      await _databaseService.database.insertSale(companion);

      // Use Future.microtask for better performance
      await Future.microtask(() async {
        await loadSales(); // Refresh list
      });
    } catch (e) {
      _error.value = 'Failed to create sale: $e';
      rethrow; // Let the UI handle error display
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update existing sale
  Future<void> updateSale({
    required int id,
    required int customerId,
    required int milkTypeId,
    required DateTime date,
    required double quantity,
    required double rate,
    String? notes,
  }) async {
    try {
      _isLoading.value = true;

      final sale = _sales.firstWhere((s) => s.id == id);
      final updatedSale = sale.copyWith(
        customerId: customerId,
        milkTypeId: milkTypeId,
        date: date,
        quantity: quantity,
        rate: rate,
        notes: Value(notes),
        updatedAt: DateTime.now(),
        isSynced: false, // Mark as not synced for future Firebase sync
      );

      await _databaseService.database.updateSale(updatedSale);

      // Use Future.microtask for better performance
      await Future.microtask(() async {
        await loadSales(); // Refresh list
      });
    } catch (e) {
      _error.value = 'Failed to update sale: $e';
      rethrow; // Let the UI handle error display
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete sale
  Future<void> deleteSale(int id) async {
    try {
      _isLoading.value = true;

      await _databaseService.database.deleteSale(id);
      await loadSales(); // Refresh list

      Get.snackbar(
        'Success',
        'Sale deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _error.value = 'Failed to delete sale: $e';
      Get.snackbar(
        'Error',
        'Failed to delete sale',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Show form for creating new sale
  void showCreateForm() {
    _selectedSale.value = null;
    _isFormVisible.value = true;
  }

  /// Show form for editing sale
  void showEditForm(Sale sale) {
    _selectedSale.value = sale;
    _isFormVisible.value = true;
  }

  /// Hide form
  void hideForm() {
    _isFormVisible.value = false;
    _selectedSale.value = null;
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

  /// Get milk type name by ID
  String getMilkTypeName(int milkTypeId) {
    try {
      final milkType = _milkTypes.firstWhere((m) => m.id == milkTypeId);
      return milkType.name;
    } catch (e) {
      return 'Unknown Milk Type';
    }
  }

  /// Get sales for a specific customer
  List<Sale> getSalesByCustomer(int customerId) {
    return _sales.where((sale) => sale.customerId == customerId).toList();
  }

  /// Get sales for a specific date range
  List<Sale> getSalesByDateRange(DateTime startDate, DateTime endDate) {
    return _sales
        .where(
          (sale) =>
              sale.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              sale.date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();
  }

  /// Calculate total revenue
  double get totalRevenue {
    return _sales.fold(0.0, (sum, sale) => sum + (sale.quantity * sale.rate));
  }

  /// Calculate total quantity sold
  double get totalQuantity {
    return _sales.fold(0.0, (sum, sale) => sum + sale.quantity);
  }

  /// Clear error message
  void clearError() {
    _error.value = '';
  }
}
