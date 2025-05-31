import 'package:get/get.dart';
import '../services/database_service.dart';

class DatabaseController extends GetxController {
  final _isInitialized = false.obs;

  bool get isInitialized => _isInitialized.value;

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      // Database initialization will happen automatically when first accessed
      final db = DatabaseService.instance.database;
      
      // Test database connection
      await db.customSelect('SELECT 1').get();
      
      _isInitialized.value = true;
      print('✅ Database initialized successfully');
    } catch (e) {
      print('❌ Error initializing database: $e');
    }
  }

  @override
  void onClose() {
    DatabaseService.instance.closeDatabase();
    super.onClose();
  }
}
