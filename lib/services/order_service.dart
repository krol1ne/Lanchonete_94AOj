import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lanchonete/models/create_order.dart';
import 'package:lanchonete/models/payment_options.dart';
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

  Future<void> createOrder(CreateOrder order) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.createOrderEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(order.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
