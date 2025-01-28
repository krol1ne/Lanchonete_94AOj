import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lanchonete/screens/products_screen.dart';
import 'package:lanchonete/services/product_service.dart';
import 'package:lanchonete/models/cart.dart';
import 'package:lanchonete/models/product.dart';

@GenerateMocks([ProductService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockProductService mockProductService;

  setUp(() {
    mockProductService = MockProductService();
  });

  testWidgets('ProductsScreen displays categories and products',
      (WidgetTester tester) async {
    final categories = ['Hamburgers', 'Appetizers', 'Desserts', 'Beverages'];
    final products = [
      Product(
        id: 1,
        name: 'Test Burger',
        description: 'Test Description',
        price: 10.99,
        imageUrl: 'http://example.com/burger.jpg',
        category: 'Hamburgers',
      ),
    ];

    when(mockProductService.getCategories())
        .thenAnswer((_) async => categories);
    when(mockProductService.getHamburgers())
        .thenAnswer((_) async => products);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Cart()),
              Provider<ProductService>.value(value: mockProductService),
            ],
            child: const ProductsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      for (var category in categories) {
        expect(find.text(category), findsOneWidget);
      }

      expect(find.text('Test Burger'), findsOneWidget);
      expect(find.text('\$10.99'), findsOneWidget);

      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      expect(find.text('Added to cart!'), findsOneWidget);
    });
  });

  testWidgets('ProductsScreen handles error state',
      (WidgetTester tester) async {
    when(mockProductService.getCategories())
        .thenThrow(Exception('Failed to load categories'));

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Cart()),
            Provider<ProductService>.value(value: mockProductService),
          ],
          child: const ProductsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Failed to load categories'), findsOneWidget);
  });

  testWidgets('ProductsScreen handles empty product list',
      (WidgetTester tester) async {
    when(mockProductService.getCategories())
        .thenAnswer((_) async => ['Hamburgers']);
    when(mockProductService.getHamburgers())
        .thenAnswer((_) async => []);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Cart()),
              Provider<ProductService>.value(value: mockProductService),
            ],
            child: const ProductsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hamburgers'), findsOneWidget);
      expect(find.byType(ProductCard), findsNothing);
    });
  });
}
