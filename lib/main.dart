import 'package:flutter/material.dart';
import 'package:lanchonete/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'models/cart.dart';
import 'screens/login_screen.dart';
import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_summary_screen.dart';
import 'screens/payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (ctx) => AuthService(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        )
      ],
      child: MaterialApp(
        title: 'Burger Delivery',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
            primary: Colors.orange,
            secondary: Colors.deepOrange,
          ),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        routes: {
          '/products': (ctx) => const ProductsScreen(),
          '/cart': (ctx) => const CartScreen(),
          '/order-summary': (ctx) => const OrderSummaryScreen(),
          '/payment': (ctx) => const PaymentScreen(),
        },
      ),
    );
  }
}
