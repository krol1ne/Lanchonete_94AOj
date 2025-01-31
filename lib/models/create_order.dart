import 'package:flutter/material.dart';

class OrderItem {
  final int id;
  final String title;
  final double value;
  final int quantity;
  final String? variant;

  OrderItem({
    required this.id,
    required this.title,
    required this.value,
    required this.quantity,
    this.variant,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'quantity': quantity,
      'variant': variant,
    };
  }
}

class CreateOrder {
  final List<OrderItem> items;
  final String paymentOption;

  CreateOrder({
    required this.items,
    required this.paymentOption,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'paymentOption': paymentOption,
    };
  }
}
