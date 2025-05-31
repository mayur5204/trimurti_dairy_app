import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

// Import table definitions
import 'tables/customer.dart';
import 'tables/milk_type.dart';
import 'tables/sale.dart';
import 'tables/payment.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Customers, MilkTypes, Sales, Payments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Basic CRUD operations - will be expanded in later phases

  // Customer operations
  Future<List<Customer>> getAllCustomers() => select(customers).get();
  Future<int> insertCustomer(CustomersCompanion customer) =>
      into(customers).insert(customer);
  Future<bool> updateCustomer(Customer customer) =>
      update(customers).replace(customer);
  Future<int> deleteCustomer(int id) =>
      (delete(customers)..where((c) => c.id.equals(id))).go();

  // MilkType operations
  Future<List<MilkType>> getAllMilkTypes() => select(milkTypes).get();
  Future<int> insertMilkType(MilkTypesCompanion milkType) =>
      into(milkTypes).insert(milkType);
  Future<bool> updateMilkType(MilkType milkType) =>
      update(milkTypes).replace(milkType);
  Future<int> deleteMilkType(int id) =>
      (delete(milkTypes)..where((m) => m.id.equals(id))).go();

  // Sale operations
  Future<List<Sale>> getAllSales() => select(sales).get();
  Future<int> insertSale(SalesCompanion sale) => into(sales).insert(sale);
  Future<bool> updateSale(Sale sale) => update(sales).replace(sale);
  Future<int> deleteSale(int id) =>
      (delete(sales)..where((s) => s.id.equals(id))).go();

  // Payment operations
  Future<List<Payment>> getAllPayments() => select(payments).get();
  Future<int> insertPayment(PaymentsCompanion payment) =>
      into(payments).insert(payment);
  Future<bool> updatePayment(Payment payment) =>
      update(payments).replace(payment);
  Future<int> deletePayment(int id) =>
      (delete(payments)..where((p) => p.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Ensure sqlite3_flutter_libs is initialized
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'dairy_app.db'));

    // Make sure the directory exists
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    return NativeDatabase(file, logStatements: true);
  });
}
