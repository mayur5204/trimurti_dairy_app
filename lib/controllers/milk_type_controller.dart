import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../services/database_service.dart';

/// GetX Controller for managing MilkType operations
class MilkTypeController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Reactive lists
  final RxList<MilkType> _milkTypes = <MilkType>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isFormVisible = false.obs;
  final Rx<MilkType?> _selectedMilkType = Rx<MilkType?>(null);

  // Getters
  List<MilkType> get milkTypes => _milkTypes;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isFormVisible => _isFormVisible.value;
  MilkType? get selectedMilkType => _selectedMilkType.value;

  @override
  void onInit() {
    super.onInit();
    loadMilkTypes();
  }

  /// Load all milk types from database
  Future<void> loadMilkTypes() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final milkTypeList = await _databaseService.database.getAllMilkTypes();
      _milkTypes.assignAll(milkTypeList);
    } catch (e) {
      _error.value = 'Failed to load milk types: $e';
      Get.snackbar(
        'Error',
        'Failed to load milk types',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Create new milk type
  Future<void> createMilkType({
    required String name,
    required double ratePerLiter,
  }) async {
    try {
      print('🎛️ Controller: Setting loading state to true');
      _isLoading.value = true;
      _error.value = '';

      final companion = MilkTypesCompanion(
        name: Value(name),
        ratePerLiter: Value(ratePerLiter),
        isSynced: Value(false),
      );

      print('💾 Controller: Inserting milk type into database');
      // Perform database operation
      await _databaseService.database.insertMilkType(companion);

      print('🔄 Controller: Refreshing milk types list');
      // Refresh list efficiently without blocking UI
      await Future.microtask(() async {
        await loadMilkTypes();
      });

      print('✅ Controller: Create operation completed successfully');
      // Don't call hideForm() here - let the UI handle navigation
    } catch (e) {
      print('❌ Controller: Error in createMilkType: $e');
      _error.value = 'Failed to create milk type: $e';
      rethrow; // Let the UI handle the error display
    } finally {
      print('🎛️ Controller: Setting loading state to false');
      _isLoading.value = false;
    }
  }

  /// Update existing milk type
  Future<void> updateMilkType({
    required int id,
    required String name,
    required double ratePerLiter,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final milkType = _milkTypes.firstWhere((m) => m.id == id);
      final updatedMilkType = milkType.copyWith(
        name: name,
        ratePerLiter: ratePerLiter,
        isSynced: false, // Mark as not synced for future Firebase sync
      );

      // Perform database operation
      await _databaseService.database.updateMilkType(updatedMilkType);

      // Refresh list efficiently without blocking UI
      await Future.microtask(() async {
        await loadMilkTypes();
      });

      // Don't call hideForm() here - let the UI handle navigation
    } catch (e) {
      _error.value = 'Failed to update milk type: $e';
      rethrow; // Let the UI handle the error display
    } finally {
      _isLoading.value = false;
    }
  }

  /// Delete milk type
  Future<void> deleteMilkType(int id) async {
    try {
      _isLoading.value = true;

      await _databaseService.database.deleteMilkType(id);
      await loadMilkTypes(); // Refresh list

      Get.snackbar(
        'Success',
        'Milk type deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _error.value = 'Failed to delete milk type: $e';
      Get.snackbar(
        'Error',
        'Failed to delete milk type',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Show form for creating new milk type
  void showCreateForm() {
    _selectedMilkType.value = null;
    _isFormVisible.value = true;
  }

  /// Show form for editing milk type
  void showEditForm(MilkType milkType) {
    _selectedMilkType.value = milkType;
    _isFormVisible.value = true;
  }

  /// Hide form
  void hideForm() {
    _isFormVisible.value = false;
    _selectedMilkType.value = null;
  }

  /// Search milk types by name
  List<MilkType> searchMilkTypes(String query) {
    if (query.isEmpty) return milkTypes;

    return milkTypes
        .where(
          (milkType) =>
              milkType.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Clear error message
  void clearError() {
    _error.value = '';
  }
}
