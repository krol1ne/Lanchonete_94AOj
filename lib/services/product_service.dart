import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lanchonete/models/appetizers.dart';
import 'package:lanchonete/models/beverages.dart';
import 'package:lanchonete/models/categories.dart';
import 'package:lanchonete/models/dessert.dart';
import 'package:lanchonete/models/hamburgers.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class ProductService {
  final http.Client _client;

  ProductService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Categories>> getCategories() async {
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categories}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((category) => Categories.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Hamburgers>> getHamburgers() async {
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hamburgersEndpoint}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Hamburgers.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hamburgers');
    }
  }

  Future<List<Appetizers>> getAppetizers() async {
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.appetizersEndpoint}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Appetizers.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appetizers');
    }
  }

  Future<List<Dessert>> getDesserts() async {
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dessertsEndpoint}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Dessert.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load desserts');
    }
  }

  Future<List<Beverages>> getBeverages() async {
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.beveragesEndpoint}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Beverages.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load beverages');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final response =
          await _client.get(Uri.parse('${ApiConstants.baseUrl}/products'));

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response =
          await _client.get(Uri.parse('${ApiConstants.baseUrl}/products/$id'));

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }
}
