import 'package:flutter/material.dart';

class CreateOrder {
  final String title;
  final int number;
  final String paymentOption;
  String? orderNumber;
  String? createdAt;
  String? menssage;
  Object? details;

  CreateOrder({
    required this.title,
    required this.number,
    required this.paymentOption,
    this.orderNumber,
    this.createdAt,
    this.menssage,
    this.details,
  });

  factory CreateOrder.fromJson(Map<String, dynamic> json) {
    return CreateOrder(
      title: json['title'],
      number: json['number'],
      paymentOption: json['payment_option'],
      orderNumber: json['order_number'],
      createdAt: json['created_at'],
      menssage: json['menssage'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'number': number,
      'payment_option': paymentOption,
      'order_number': orderNumber,
      'created_at': createdAt,
      'menssage': menssage,
      'details': details,
    };
  }
}
