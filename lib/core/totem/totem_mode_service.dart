import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Aplica o modo totem (ver escopo, item 42): tela cheia imersiva,
/// manter a tela ligada e orientação configurável.
///
/// Kiosk por software — imersivo + retorno automático à tela
/// principal (ver [core/totem/totem_idle_guard.dart]) — sem exigir
/// que o tablet seja provisionado como "device owner"/Lock Task.
class TotemModeService {
  TotemModeService._();

  /// Canal do runner Linux (`linux/runner/my_application.cc`) que põe a
  /// janela GTK em tela cheia — no desktop `SystemChrome` não controla
  /// a janela.
  static const _linuxWindowChannel = MethodChannel('pesagem_totem_window');

  static Future<void> apply({required bool totemEnabled, required String orientation}) async {
    if (Platform.isLinux) {
      try {
        await _linuxWindowChannel.invokeMethod('setFullscreen', totemEnabled);
      } catch (_) {
        // Runner sem o canal (ex.: testes) — não é crítico.
      }
    }

    await SystemChrome.setEnabledSystemUIMode(
      totemEnabled ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );

    try {
      if (totemEnabled) {
        await WakelockPlus.enable();
      } else {
        await WakelockPlus.disable();
      }
    } catch (_) {
      // Wakelock indisponível (ex.: desktop/testes) — não é crítico.
    }

    await _applyOrientation(orientation);
  }

  static Future<void> _applyOrientation(String orientation) async {
    final orientations = switch (orientation) {
      'portrait' => [DeviceOrientation.portraitUp],
      'landscape' => [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      _ => DeviceOrientation.values,
    };
    await SystemChrome.setPreferredOrientations(orientations);
  }
}
