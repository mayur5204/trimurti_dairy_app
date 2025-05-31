import 'package:drift/drift.dart';

class MilkTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get ratePerLiter => real()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}
