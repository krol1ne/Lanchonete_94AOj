import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lanchonete/services/order_service.dart';
import 'package:lanchonete/models/payment_options.dart';
import 'package:lanchonete/models/create_order.dart';
import 'package:lanchonete/utils/constants.dart';

import '../mocks/mock_http_client.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late OrderService orderService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    orderService = OrderService(client: mockClient);
  });

  group('OrderService', () {
    test('getPaymentOptions returns list of payment options on success',
        () async {
      final mockResponse = [
        {'id': '1', 'number': 1, 'text': 'Credit Card'},
        {'id': '2', 'number': 2, 'text': 'Debit Card'}
      ];

      when(mockClient.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.paymentOptionsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response(json.encode(mockResponse), 200));

      final result = await orderService.getPaymentOptions();

      expect(result, isA<List<PaymentOptions>>());
      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[0].text, equals('Credit Card'));
      expect(result[1].id, equals('2'));
      expect(result[1].text, equals('Debit Card'));
    });

    test('getPaymentOptions throws exception on error', () async {
      when(mockClient.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.paymentOptionsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('Server error', 500));

      expect(() => orderService.getPaymentOptions(), throwsException);
    });

    test('getCreateOrder returns list of orders on success', () async {
      final mockResponse = [
        {
          'title': 'Order #1',
          'number': 1,
          'payment_option': 'Credit Card',
          'order_number': 'ORD001',
          'created_at': '2025-01-30T21:51:10-03:00',
          'menssage': 'Order created successfully',
          'details': {'items': [], 'total': 99.99}
        }
      ];

      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createOrderEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response(json.encode(mockResponse), 200));

      final result = await orderService.getCreateOrder();

      expect(result, isA<List<CreateOrder>>());
      expect(result.length, equals(1));
      expect(result[0].title, equals('Order #1'));
      expect(result[0].number, equals(1));
      expect(result[0].paymentOption, equals('Credit Card'));
      expect(result[0].orderNumber, equals('ORD001'));
    });

    test('getCreateOrder throws exception on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createOrderEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('Server error', 500));

      expect(() => orderService.getCreateOrder(), throwsException);
    });
  });
}
