import 'dart:async';

import 'package:flutter/material.dart';

/// Retorna automaticamente à tela principal do totem após um período
/// de inatividade e bloqueia o botão "voltar" do Android — parte do
/// modo totem por software (ver escopo, item 42), sem exigir Device
/// Owner/Lock Task.
class TotemIdleGuard extends StatefulWidget {
  const TotemIdleGuard({
    super.key,
    required this.enabled,
    required this.navigatorKey,
    required this.child,
    this.idleTimeout = const Duration(minutes: 3),
  });

  final bool enabled;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;
  final Duration idleTimeout;

  @override
  State<TotemIdleGuard> createState() => _TotemIdleGuardState();
}

class _TotemIdleGuardState extends State<TotemIdleGuard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void didUpdateWidget(covariant TotemIdleGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled || widget.idleTimeout != oldWidget.idleTimeout) {
      _resetTimer();
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    if (!widget.enabled) return;
    _timer = Timer(widget.idleTimeout, _returnToHome);
  }

  void _returnToHome() {
    widget.navigatorKey.currentState?.popUntil((route) => route.isFirst);
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      child: PopScope(
        canPop: !widget.enabled,
        child: widget.child,
      ),
    );
  }
}
