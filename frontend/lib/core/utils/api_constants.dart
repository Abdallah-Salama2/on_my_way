class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://on-my-way.runasp.net/api';

  static const String registerPath = "$baseUrl/user/register";
  static const loginPath = "$baseUrl/user/login";
  static const logOutPath = "$baseUrl/logout";
  static const forgotPasswordPath = "$baseUrl/forgot-password";

  static const getDrivers = "$baseUrl/get-drivers";
  static const createRide = '/create-ride';
  static String cancelRide(String rideId) => '/rides/$rideId/cancel';

  static const getItems = "/items";
  static String showSingleItem(String id) => "/items/$id";

  static const getCategories = "/categories";
  static String showSingleCategories(String id) => "/categories/$id";

  static const getStores = "/stores";
  static String showSingleStores(String id) => "/stores/$id";

  static const getFavorites = "/favorites";
  static String addToFavorites(String id) => "$getFavorites/toggle/$id";

  static const getCart = "/cart";
  static const updateCart = "/cart";
  static String deleteCartItem(int id) => "/cart/$id";

  static const getOrders = '/orders';
  static const createOrder = '/orders';
  static String reorder(int id) => '/orders/$id/reorder';
  static String deleteOrder(int id) => '/orders/$id/cancel';
}
