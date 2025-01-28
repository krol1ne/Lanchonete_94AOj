import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lanchonete/services/order_service.dart';
import 'package:lanchonete/models/cart.dart';
import 'package:lanchonete/models/product.dart';
import 'package:lanchonete/utils/constants.dart';

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
      final paymentOptions = ['Credit Card', 'Debit Card', 'Cash'];

      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.paymentOptionsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async =>
          http.Response(json.encode(paymentOptions), 200));

      final result = await orderService.getPaymentOptions();
      expect(result, equals(paymentOptions));
    });

    test('getPaymentOptions throws exception on error', () async {
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.paymentOptionsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )).thenAnswer((_) async => http.Response('Server error', 500));

      expect(() => orderService.getPaymentOptions(),
          throwsA(isA<Exception>()));
    });

    test('createOrder returns order details on success', () async {
      final cart = Cart();
      cart.addItem(
        Product(
          id: 1,
          name: 'Test Burger',
          description: 'Test Description',
          price: 10.99,
          imageUrl: 'http://example.com/burger.jpg',
          category: 'Hamburgers',
        ),
      );

      final expectedResponse = {
        'orderId': '12345',
        'status': 'confirmed',
        'totalAmount': 10.99,
      };

      when(mockClient.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createOrderEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenAnswer((_) async =>
          http.Response(json.encode(expectedResponse), 200));

      final result = await orderService.createOrder(
        cart: cart,
        paymentMethod: 'Credit Card',
        deliveryAddress: '123 Test St',
      );

      expect(result, equals(expectedResponse));
    });

    test('createOrder throws exception on error', () async {
      final cart = Cart();
      cart.addItem(
        Product(
          id: 1,
          name: 'Test Burger',
          description: 'Test Description',
          price: 10.99,
          imageUrl: 'http://example.com/burger.jpg',
          category: 'Hamburgers',
        ),
      );

      when(mockClient.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createOrderEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: any,
      )).thenAnswer((_) async => http.Response('Server error', 500));

      expect(
          () => orderService.createOrder(
                cart: cart,
                paymentMethod: 'Credit Card',
                deliveryAddress: '123 Test St',
              ),
          throwsA(isA<Exception>()));
    });
  });
}
