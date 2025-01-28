import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lanchonete/services/product_service.dart';
import 'package:lanchonete/models/product.dart';
import 'package:lanchonete/utils/constants.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductService productService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    productService = ProductService(client: mockClient);
  });

  group('ProductService', () {
    test('getCategories returns list of categories on success', () async {
      final categories = ['Hamburgers', 'Appetizers', 'Desserts', 'Beverages'];
      
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response(json.encode(categories), 200));

      final result = await productService.getCategories();
      expect(result, equals(categories));
    });

    test('getCategories throws exception on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response('Server error', 500));

      expect(() => productService.getCategories(),
          throwsA(isA<Exception>()));
    });

    test('getHamburgers returns list of hamburgers on success', () async {
      final hamburgers = [
        {
          'id': 1,
          'name': 'Classic Burger',
          'description': 'Delicious classic burger',
          'price': 10.99,
          'imageUrl': 'http://example.com/burger.jpg',
          'category': 'Hamburgers'
        }
      ];

      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hamburgersEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response(json.encode(hamburgers), 200));

      final result = await productService.getHamburgers();
      expect(result.length, equals(1));
      expect(result.first.name, equals('Classic Burger'));
    });

    test('getHamburgers throws exception on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hamburgersEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response('Server error', 500));

      expect(() => productService.getHamburgers(),
          throwsA(isA<Exception>()));
    });

    test('getAppetizers returns list of appetizers on success', () async {
      final appetizers = [
        {
          'id': 2,
          'name': 'Onion Rings',
          'description': 'Crispy onion rings',
          'price': 5.99,
          'imageUrl': 'http://example.com/onion-rings.jpg',
          'category': 'Appetizers'
        }
      ];

      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.appetizersEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response(json.encode(appetizers), 200));

      final result = await productService.getAppetizers();
      expect(result.length, equals(1));
      expect(result.first.name, equals('Onion Rings'));
    });

    test('getAppetizers throws exception on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.appetizersEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response('Server error', 500));

      expect(() => productService.getAppetizers(),
          throwsA(isA<Exception>()));
    });

    test('getDesserts returns list of desserts on success', () async {
      final desserts = [
        {
          'id': 3,
          'name': 'Ice Cream',
          'description': 'Vanilla ice cream',
          'price': 4.99,
          'imageUrl': 'http://example.com/ice-cream.jpg',
          'category': 'Desserts'
        }
      ];

      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dessertsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response(json.encode(desserts), 200));

      final result = await productService.getDesserts();
      expect(result.length, equals(1));
      expect(result.first.name, equals('Ice Cream'));
    });

    test('getDesserts throws exception on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dessertsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response('Server error', 500));

      expect(() => productService.getDesserts(),
          throwsA(isA<Exception>()));
    });

    test('getBeverages returns list of beverages on success', () async {
      final beverages = [
        {
          'id': 4,
          'name': 'Cola',
          'description': 'Refreshing cola',
          'price': 2.99,
          'imageUrl': 'http://example.com/cola.jpg',
          'category': 'Beverages'
        }
      ];

      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.beveragesEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response(json.encode(beverages), 200));

      final result = await productService.getBeverages();
      expect(result.length, equals(1));
      expect(result.first.name, equals('Cola'));
    });

    test('getBeverages throws exception on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.beveragesEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response('Server error', 500));

      expect(() => productService.getBeverages(),
          throwsA(isA<Exception>()));
    });
  });
}
