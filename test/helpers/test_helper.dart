import 'package:lanchonete/models/categories.dart';
import 'package:lanchonete/models/hamburgers.dart';

class TestHelper {
  static List<Categories> getMockCategories() {
    return [
      Categories(id: '1', text: 'Hamburgers', number: 1),
      Categories(id: '2', text: 'Porções', number: 2),
      Categories(id: '3', text: 'Sobremesas', number: 3),
      Categories(id: '4', text: 'Bebidas', number: 4),
    ];
  }

  static Hamburgers getMockHamburger() {
    return Hamburgers(
      id: 1,
      name: 'Test Burger',
      description: 'Test Description',
      imageUrl: 'http://example.com/burger.jpg',
      images: ['http://example.com/burger.jpg'],
      price: 0,
      values: Values(single: 15.99, combo: 25.99),
    );
  }
}
