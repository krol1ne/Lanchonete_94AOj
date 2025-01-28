class ApiConstants {
  static const String baseUrl = 'https://burgerlivery-api.vercel.app/';

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';

  // Product endpoints
  static const String categoriesEndpoint = '/categories';
  static const String hamburgersEndpoint = '/products/hamburgers';
  static const String appetizersEndpoint = '/products/appetizers';
  static const String dessertsEndpoint = '/products/desserts';
  static const String beveragesEndpoint = '/products/beverages';

  // Order endpoints
  static const String paymentOptionsEndpoint = '/payment-options';
  static const String createOrderEndpoint = '/orders';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
