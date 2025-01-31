import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lanchonete/services/product_service.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mockito/mockito.dart';
import 'package:lanchonete/screens/products_screen.dart';
import 'package:lanchonete/models/cart.dart';
import 'package:lanchonete/models/categories.dart';
import 'package:lanchonete/models/hamburgers.dart';
import '../../mocks/mock_product_service.dart';
import '../../helpers/test_helper.dart';

void main() {
  late MockProductService mockProductService;

  setUp(() {
    mockProductService = MockProductService();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Cart()),
          Provider<ProductService>.value(value: mockProductService),
        ],
        child: const ProductsScreen(),
      ),
    );
  }

  group('ProductsScreen', () {
    testWidgets('displays categories and products correctly',
        (WidgetTester tester) async {
      // Arrange
      final categories = TestHelper.getMockCategories();
      final hamburger = TestHelper.getMockHamburger();

      when(mockProductService.getCategories())
          .thenAnswer((_) async => categories);
      when(mockProductService.getHamburgers())
          .thenAnswer((_) async => [hamburger]);
      when(mockProductService.getAppetizers()).thenAnswer((_) async => []);
      when(mockProductService.getDesserts()).thenAnswer((_) async => []);
      when(mockProductService.getBeverages()).thenAnswer((_) async => []);

      // Act & Assert
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify categories
        for (var category in categories) {
          expect(find.text(category.text), findsOneWidget);
        }

        // Verify product details
        expect(find.text(hamburger.name), findsOneWidget);
        expect(find.text('R\$${hamburger.values.single.toStringAsFixed(2)}'),
            findsOneWidget);
        expect(find.text('R\$${hamburger.values.combo.toStringAsFixed(2)}'),
            findsOneWidget);

        // Test add to cart
        await tester.tap(find.text('Add to Cart').first);
        await tester.pumpAndSettle();
        expect(find.text('Added to cart!'), findsOneWidget);
      });
    });

    testWidgets('shows error message when loading fails',
        (WidgetTester tester) async {
      // Arrange
      when(mockProductService.getCategories())
          .thenThrow(Exception('Failed to load categories'));

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Failed to load categories'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially',
        (WidgetTester tester) async {
      // Arrange
      when(mockProductService.getCategories()).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(seconds: 1));
          return TestHelper.getMockCategories();
        },
      );

      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Initially shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait and verify loading is gone
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('handles empty product lists gracefully',
        (WidgetTester tester) async {
      // Arrange
      final categories = [TestHelper.getMockCategories().first];
      when(mockProductService.getCategories())
          .thenAnswer((_) async => categories);
      when(mockProductService.getHamburgers()).thenAnswer((_) async => []);
      when(mockProductService.getAppetizers()).thenAnswer((_) async => []);
      when(mockProductService.getDesserts()).thenAnswer((_) async => []);
      when(mockProductService.getBeverages()).thenAnswer((_) async => []);

      // Act
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(categories.first.text), findsOneWidget);
        expect(find.byType(ProductCard), findsNothing);
      });
    });
  });
}
