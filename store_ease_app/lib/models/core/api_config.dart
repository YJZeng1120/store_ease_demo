import '../../constants.dart';

class ApiConfig {
  static const String endpoint = 'https://osbe-dev-h4hebvrrhq-uc.a.run.app';
  static const String baseUrl = "$endpoint/api/v1";

  static const String login = '/login';
  static const String users = '/users';
  static const String otp = '/otp';
  static const String stores = '/stores';
  static const String categories = '/categories';
  static const String menus = '/menus';
  static const String resetPassword = '/reset-password';
  static const String create = '/create';
  static const String verify = '/verify';
  static const String seats = '/seats';
  static const String orderTickets = '/order-tickets';
  static const String fcmTokens = '/fcm-tokens';

  static String usersWithId(String userId) {
    return '$users/$userId';
  }

  static String menusWithId(String menuId) {
    return '$menus/$menuId';
  }

  static String storesWithId(String storeId) {
    return '$stores/$storeId';
  }

  static String seatsWithId(int seatId) {
    return '$seats/$seatId';
  }

  static String categoriesWithId(int categoryId) {
    return '$categories/$categoryId';
  }

  static String orderTicketsWithId(int orderTicketId) {
    return '$orderTickets/$orderTicketId';
  }

  static String languageParam(int languageId) {
    return 'language=$languageId';
  }

  static String userTypeParam() {
    return 'userType=$userType';
  }

  static String emailParam(String email) {
    return 'email=$email';
  }

  static String uidParam(String uid) {
    return 'uid=$uid';
  }

  static String methodParam(ApiMethod method) {
    late String methodStr = '';

    switch (method) {
      case ApiMethod.uid:
        methodStr = 'uid';
        break;
      case ApiMethod.email:
        methodStr = 'email';
        break;
    }

    return 'method=$methodStr';
  }
}

enum ApiMethod { email, uid }
