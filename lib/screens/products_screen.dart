import 'package:flutter/material.dart';
import 'package:lanchonete/contracts/product_contract.dart';
import 'package:lanchonete/models/appetizers.dart';
import 'package:lanchonete/models/categories.dart';
import 'package:lanchonete/models/hamburgers.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../services/product_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  final ProductService _productService = ProductService();
  late TabController _tabController;
  List<Categories> _categories = [];
  Map<String, List<ProductContract>> _productsByCategory = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await _productService.getCategories();
      if (!mounted) return;

      setState(() {
        _categories = categories;
        _tabController = TabController(length: categories.length, vsync: this);
      });
      await _loadAllProducts();
    } catch (e) {
      print('Error loading categories: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load categories: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadAllProducts() async {
    if (!mounted) return;

    try {
      final products = await Future.wait([
        _productService.getHamburgers(),
        _productService.getAppetizers(),
        _productService.getDesserts(),
        _productService.getBeverages(),
      ]);

      if (!mounted) return;

      setState(() {
        _productsByCategory = {
          'hamburgers': products[0],
          'porcoes': products[1],
          'sobremesas': products[2],
          'bebidas': products[3],
        };
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load products: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_categories.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: const Center(
          child: Text('No categories available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs:
              _categories.map((category) => Tab(text: category.text)).toList(),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              Positioned(
                child: Consumer<Cart>(
                  builder: (ctx, cart, _) => cart.itemCount == 0
                      ? Container()
                      : CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 8,
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          final products = _productsByCategory[category.link] ?? [];
          return RefreshIndicator(
            onRefresh: _loadAllProducts,
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) => ProductCard(product: products[i]),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductContract product;

  const ProductCard({
    super.key,
    required this.product,
  });

  String _getPriceText() {
    if (product is Hamburgers) {
      final hamburger = product as Hamburgers;
      return 'Single: R\$${hamburger.values.single.toStringAsFixed(2)}\nCombo: R\$${hamburger.values.combo.toStringAsFixed(2)}';
    } else if (product is Appetizers) {
      final appetizer = product as Appetizers;
      if (appetizer.values.small != null && appetizer.values.large != null) {
        return 'Small: R\$${appetizer.values.small!.toStringAsFixed(2)}\nLarge: R\$${appetizer.values.large!.toStringAsFixed(2)}';
      } else if (appetizer.values.small != null) {
        return 'R\$${appetizer.values.small!.toStringAsFixed(2)}';
      } else if (appetizer.values.large != null) {
        return 'R\$${appetizer.values.large!.toStringAsFixed(2)}';
      }
    }
    return 'R\$${product.price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getPriceText(),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<Cart>().addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added to cart!'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              context.read<Cart>().removeSingleItem(product.id);
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
