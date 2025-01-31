import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lanchonete/models/appetizers.dart';
import 'package:lanchonete/models/beverages.dart';
import 'package:lanchonete/models/categories.dart';
import 'package:lanchonete/models/dessert.dart';
import 'package:lanchonete/models/hamburgers.dart';
import '../utils/constants.dart';

class ProductService {
  final http.Client _client;

  ProductService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Categories>> getCategories() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Categories Response Status: ${response.statusCode}');
      print('Categories Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Categories.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      print('Error loading categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<Hamburgers>> getHamburgers() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.hamburgersEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Hamburgers Response Status: ${response.statusCode}');
      print('Hamburgers Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Hamburgers.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hamburgers: ${response.body}');
      }
    } catch (e) {
      print('Error loading hamburgers: $e');
      throw Exception('Failed to load hamburgers: $e');
    }
  }

  Future<List<Appetizers>> getAppetizers() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.appetizersEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Appetizers.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load appetizers: ${response.body}');
      }
    } catch (e) {
      print('Error loading appetizers: $e');
      throw Exception('Failed to load appetizers: $e');
    }
  }

  Future<List<Dessert>> getDesserts() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dessertsEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Dessert.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load desserts: ${response.body}');
      }
    } catch (e) {
      print('Error loading desserts: $e');
      throw Exception('Failed to load desserts: $e');
    }
  }

  Future<List<Beverages>> getBeverages() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.beveragesEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Beverages.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load beverages: ${response.body}');
      }
    } catch (e) {
      print('Error loading beverages: $e');
      throw Exception('Failed to load beverages: $e');
    }
  }
}
