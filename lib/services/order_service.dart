import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lanchonete/models/payment_options.dart';
import '../models/cart.dart';
import '../utils/constants.dart';

class OrderService {
  final http.Client _client;

  OrderService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<PaymentOptions>> getPaymentOptions() async {
    try {
      final response = await _client.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.paymentOptionsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((option) => PaymentOptions.fromJson(option)).toList();
      } else {
        throw Exception('Failed to load payment options');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required Cart cart,
    required String paymentMethod,
    required String deliveryAddress,
  }) async {
    try {
      final orderItems = cart.items.values
          .map((item) => {
                'productId': item.product.id,
                'quantity': item.quantity,
                'price': item.product.price,
              })
          .toList();

      final orderData = {
        'items': orderItems,
        'totalAmount': cart.totalAmount,
        'paymentMethod': paymentMethod,
        'deliveryAddress': deliveryAddress,
      };

      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createOrderEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
