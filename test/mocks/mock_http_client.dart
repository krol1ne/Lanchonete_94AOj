import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:lanchonete/utils/constants.dart';

import 'mock_http_client.mocks.dart';

@GenerateMocks([http.Client])
class MockResponses {
  static Map<String, dynamic> get mockUser => {
        'id': '1',
        'name': 'Test User',
        'email': 'test@example.com',
        'token': 'mock-token-123'
      };

  static List<Map<String, dynamic>> get mockCategories => [
        {'id': '1', 'text': 'Hamburgers', 'number': 1},
        {'id': '2', 'text': 'Porções', 'number': 2},
        {'id': '3', 'text': 'Sobremesas', 'number': 3},
        {'id': '4', 'text': 'Bebidas', 'number': 4},
      ];

  static List<Map<String, dynamic>> get mockHamburgers => [
        {
          'id': 1,
          'title': 'Classic Burger',
          'description': 'Delicious classic burger',
          'image': ['http://example.com/burger.jpg'],
          'values': {
            'single': 15.99,
            'combo': 25.99,
          }
        }
      ];

  static List<Map<String, dynamic>> get mockPaymentOptions => [
        {'id': '1', 'number': 1, 'text': 'Credit Card'},
        {'id': '2', 'number': 2, 'text': 'Debit Card'},
        {'id': '3', 'number': 3, 'text': 'Cash'},
      ];

  static Map<String, dynamic> get mockCreateOrder => {
        'title': 'Order #123',
        'number': 123,
        'payment_option': 'Credit Card',
        'order_number': 'ORD123',
        'created_at': '2025-01-30T21:53:54-03:00',
        'menssage': 'Order created successfully',
        'details': {'items': [], 'total': 99.99}
      };
}

class MockClientHelper {
  static void setupMockClient(MockClient mockClient) {
    // Auth endpoints
    when(mockClient.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(
          json.encode(MockResponses.mockUser),
          200,
        ));

    // Categories endpoint
    when(mockClient.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(
          json.encode(MockResponses.mockCategories),
          200,
        ));

    // Products endpoints
    when(mockClient.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hamburgersEndpoint}'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(
          json.encode(MockResponses.mockHamburgers),
          200,
        ));

    // Payment options endpoint
    when(mockClient.get(
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.paymentOptionsEndpoint}'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(
          json.encode(MockResponses.mockPaymentOptions),
          200,
        ));

    // Create order endpoint
    when(mockClient.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createOrderEndpoint}'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(
          json.encode(MockResponses.mockCreateOrder),
          201,
        ));
  }

  static void setupErrorResponse(MockClient mockClient, String endpoint,
      {int statusCode = 500, String message = 'Server error'}) {
    when(mockClient.get(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(message, statusCode));

    when(mockClient.post(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(message, statusCode));
  }
}

void main() {}
