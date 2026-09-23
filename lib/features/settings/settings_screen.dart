import 'package:flutter/material.dart';

import '../../core/theme/app_dimensions.dart';
import '../employees/employees_screen.dart';
import '../history/history_screen.dart';
import '../import/import_history_screen.dart';
import '../import/import_screen.dart';
import '../labels/barcode_settings_screen.dart';
import '../labels/label_settings_screen.dart';
import '../products/products_screen.dart';
import 'network_settings_screen.dart';
import 'printer_settings_screen.dart';
import 'scale_settings_screen.dart';
import 'system_settings_screen.dart';

/// Hub de configurações do sistema (ver escopo, item 46).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        children: [
          _SettingsTile(
            icon: Icons.scale,
            title: 'Balança',
            subtitle: 'Transporte (BLE/cabo USB), protocolo serial e recorte do peso',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ScaleSettingsScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.print,
            title: 'Impressora',
            subtitle: 'Pareamento Bluetooth e impressão de teste',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrinterSettingsScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.upload_file,
            title: 'Importação',
            subtitle: 'Importar arquivo manualmente',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ImportScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.history_edu,
            title: 'Histórico de Importações',
            subtitle: 'Arquivos já importados e seus resultados',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ImportHistoryScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.wifi,
            title: 'Rede',
            subtitle: 'Importação automática via pasta compartilhada (SMB)',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NetworkSettingsScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.qr_code,
            title: 'Código de Barras',
            subtitle: 'Dígitos do PLU e o que o valor representa (preço, peso ou total)',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BarcodeSettingsScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.label,
            title: 'Etiquetas',
            subtitle: 'Perfis de layout e editor visual',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LabelSettingsScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.list_alt,
            title: 'Produtos',
            subtitle: 'Consultar produtos cadastrados',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProductsScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.badge_outlined,
            title: 'Funcionários',
            subtitle: 'Atendentes comissionados, vinculados às vendas por comanda',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EmployeesScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.receipt_long,
            title: 'Histórico',
            subtitle: 'Pesagens impressas, filtros e reimpressão',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.settings_applications,
            title: 'Sistema',
            subtitle: 'Modo totem, orientação e auditoria',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SystemSettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.spaceMd),
        leading: Icon(icon, size: 32),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
