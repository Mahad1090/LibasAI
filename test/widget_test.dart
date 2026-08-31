import 'package:flutter_test/flutter_test.dart';

import 'package:libasai/data.dart';
import 'package:libasai/main.dart';

void main() {
  testWidgets('App boots to splash screen', (tester) async {
    await tester.pumpWidget(LibasAIApp(state: AppState()));
    await tester.pump();
    expect(find.byType(LibasAIApp), findsOneWidget);
  });
}
