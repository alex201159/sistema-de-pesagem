import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_provider.dart';
import 'audit_repository.dart';
import 'employee_repository.dart';
import 'history_repository.dart';
import 'label_repository.dart';
import 'printer_repository.dart';
import 'product_repository.dart';
import 'scale_repository.dart';
import 'settings_repository.dart';
import 'weighing_repository.dart';

/// Providers Riverpod dos repositories, centralizados para que
/// telas/controllers nunca instanciem um repository diretamente
/// (facilita troca por mocks em testes — ver escopo, itens 52-53).
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(ref.watch(databaseProvider)),
);

final weighingRepositoryProvider = Provider<WeighingRepository>(
  (ref) => WeighingRepository(ref.watch(databaseProvider)),
);

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(ref.watch(databaseProvider)),
);

final labelRepositoryProvider = Provider<LabelRepository>(
  (ref) => LabelRepository(ref.watch(databaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final scaleRepositoryProvider = Provider<ScaleRepository>(
  (ref) => ScaleRepository(ref.watch(databaseProvider)),
);

final printerRepositoryProvider = Provider<PrinterRepository>(
  (ref) => PrinterRepository(ref.watch(databaseProvider)),
);

final auditRepositoryProvider = Provider<AuditRepository>(
  (ref) => AuditRepository(ref.watch(databaseProvider)),
);

final employeeRepositoryProvider = Provider<EmployeeRepository>(
  (ref) => EmployeeRepository(ref.watch(databaseProvider)),
);
