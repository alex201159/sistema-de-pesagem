import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../core/constants/database_constants.dart';
import 'migrations.dart';
import 'tables/app_settings_table.dart';
import 'tables/audit_log_table.dart';
import 'tables/employees_table.dart';
import 'tables/import_history_table.dart';
import 'tables/label_elements_table.dart';
import 'tables/labels_table.dart';
import 'tables/printers_table.dart';
import 'tables/product_price_history_table.dart';
import 'tables/products_table.dart';
import 'tables/scales_table.dart';
import 'tables/weighing_employees_table.dart';
import 'tables/weighing_history_table.dart';

part 'app_database.g.dart';

/// Banco de dados local (SQLite via Drift).
///
/// Ponto único de acesso ao SQLite — todo o resto da aplicação
/// (repositories) depende apenas desta classe, nunca de SQL cru
/// espalhado pelas telas/serviços.
@DriftDatabase(
  tables: [
    Products,
    WeighingHistory,
    ImportHistory,
    Labels,
    LabelElements,
    Printers,
    Scales,
    ProductPriceHistory,
    AppSettings,
    AuditLog,
    Employees,
    WeighingEmployees,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Construtor para testes/mocks, permitindo injetar um
  /// `QueryExecutor` em memória (`NativeDatabase.memory()`).
  AppDatabase.withExecutor(super.executor);

  @override
  int get schemaVersion => DatabaseConstants.schemaVersion;

  @override
  MigrationStrategy get migration => buildMigrationStrategy(this);

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      // No Linux (Orange Pi) o banco fica em ~/.local/share/<app id>, não
      // em ~/Documents — pasta que pode nem existir numa instalação
      // mínima do Armbian.
      final dbFolder = Platform.isLinux
          ? await getApplicationSupportDirectory()
          : await getApplicationDocumentsDirectory();
      await dbFolder.create(recursive: true);
      final file = File(p.join(dbFolder.path, DatabaseConstants.databaseFileName));

      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }
      final cachebase = (await getTemporaryDirectory()).path;
      sqlite3.tempDirectory = cachebase;

      return NativeDatabase.createInBackground(file);
    });
  }
}
