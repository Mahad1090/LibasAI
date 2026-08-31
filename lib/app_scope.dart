import 'package:flutter/material.dart';
import 'data.dart';

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree');
    return scope!.notifier!;
  }
}

/// Navigation helpers — thin wrappers over Navigator named routes.
void go(BuildContext context, String route, {Object? args}) =>
    Navigator.of(context).pushNamed(route, arguments: args);

void goBack(BuildContext context) {
  final nav = Navigator.of(context);
  if (nav.canPop()) {
    nav.pop();
  } else {
    nav.pushReplacementNamed('/home');
  }
}

void goAndReset(BuildContext context, String route) =>
    Navigator.of(context).pushNamedAndRemoveUntil(route, (r) => false);
