import 'package:flutter_test/flutter_test.dart';

import 'package:libasai_admin/main.dart';

void main() {
  testWidgets('admin app boots to the brand registry screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LibasAIAdminApp());
    await tester.pump();
    expect(find.text('Brand registry'), findsOneWidget);
  });
}
