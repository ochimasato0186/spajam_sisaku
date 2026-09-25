// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/main.dart';

void main() {
  testWidgets('ホーム画面に各画面へのボタンが表示される', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('カウントする'), findsNothing);
    expect(find.text('AIと会話する'), findsOneWidget);
    expect(find.text('カメラを使う'), findsOneWidget);
    expect(find.text('カメラ２'), findsOneWidget);
  });
}
