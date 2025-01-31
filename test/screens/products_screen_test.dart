import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lanchonete/screens/products_screen.dart';
import 'package:lanchonete/services/product_service.dart';
import 'package:lanchonete/models/cart.dart';
import 'package:lanchonete/models/categories.dart';
import 'package:lanchonete/models/hamburgers.dart';
import 'package:lanchonete/models/appetizers.dart';
import 'package:lanchonete/models/beverages.dart';
import 'package:lanchonete/models/dessert.dart';

import 'products_screen_test.mocks.dart';

@GenerateMocks([ProductService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockProductService mockProductService;

  setUp(() {
    mockProductService = MockProductService();
  });

  testWidgets('ProductsScreen displays categories and products',
      (WidgetTester tester) async {
    final categories = [
      Categories(id: '1', text: 'Hamburgers', number: 1, link: ''),
      Categories(id: '2', text: 'Porções', number: 2, link: ''),
      Categories(id: '3', text: 'Sobremesas', number: 3, link: ''),
      Categories(id: '4', text: 'Bebidas', number: 4, link: ''),
    ];

    final hamburger = Hamburgers(
      id: 1,
      name: 'Test Burger',
      description: 'Test Description',
      imageUrl: 'http://example.com/burger.jpg',
      images: ['http://example.com/burger.jpg'],
      price: 0,
      values: Values(single: 15.99, combo: 25.99),
    );

    when(mockProductService.getCategories())
        .thenAnswer((_) async => categories);
    when(mockProductService.getHamburgers())
        .thenAnswer((_) async => [hamburger]);
    when(mockProductService.getAppetizers()).thenAnswer((_) async => []);
    when(mockProductService.getDesserts()).thenAnswer((_) async => []);
    when(mockProductService.getBeverages()).thenAnswer((_) async => []);

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

      // Verify categories are displayed
      for (var category in categories) {
        expect(find.text(category.text), findsOneWidget);
      }

      // Verify hamburger details are displayed
      expect(find.text('Test Burger'), findsOneWidget);
      expect(find.text('R\$15.99'), findsOneWidget); // Single price
      expect(find.text('R\$25.99'), findsOneWidget); // Combo price

      // Test add to cart functionality
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
    final categories = [Categories(id: '1', text: 'Hamburgers', number: 1)];

    when(mockProductService.getCategories())
        .thenAnswer((_) async => categories);
    when(mockProductService.getHamburgers()).thenAnswer((_) async => []);
    when(mockProductService.getAppetizers()).thenAnswer((_) async => []);
    when(mockProductService.getDesserts()).thenAnswer((_) async => []);
    when(mockProductService.getBeverages()).thenAnswer((_) async => []);

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

  testWidgets('ProductsScreen shows loading state',
      (WidgetTester tester) async {
    when(mockProductService.getCategories()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return [Categories(id: '1', text: 'Hamburgers', number: 1)];
    });

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

    // Initially should show loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for loading to complete
    await tester.pumpAndSettle();

    // Loading indicator should be gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
