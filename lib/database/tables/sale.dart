import 'package:drift/drift.dart';

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer()();
  IntColumn get milkTypeId => integer()();
  DateTimeColumn get date => dateTime()();
  RealColumn get quantity => real()();
  RealColumn get rate => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}
