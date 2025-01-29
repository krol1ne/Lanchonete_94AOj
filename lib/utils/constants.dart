class ApiConstants {
  static const String baseUrl = 'https://burgerlivery-api.vercel.app/';

  // Auth endpoints
  static const String loginEndpoint = 'user/login';
  static const String logoutEndpoint = 'user/logout';

  // Product endpoints
  static const String categoriesEndpoint = 'categories';
  static const String hamburgersEndpoint = 'hamburgers';
  static const String appetizersEndpoint = 'appetizers';
  static const String dessertsEndpoint = 'desserts';
  static const String beveragesEndpoint = 'beverages';

  // Order endpoints
  static const String paymentOptionsEndpoint = 'payment-options';
  static const String createOrderEndpoint = 'order/create-order';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
