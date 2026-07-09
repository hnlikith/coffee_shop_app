import 'package:flutter_test/flutter_test.dart';
import 'package:coffee_shop_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CoffeeShopApp());
    // Verify splash screen renders
    expect(find.text('Get Started'), findsOneWidget);
  });
}
