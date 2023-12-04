import 'package:flutter/material.dart';

import '../views/account/reset_info_page.dart';
import '../views/account/set_language_page.dart';
import '../views/app_bottom_tabs_page.dart';
import '../views/auth/auth_page.dart';
import '../views/auth/login_page.dart';
import '../views/auth/register_page.dart';
import '../views/auth/register_verify_page.dart';
import '../views/auth/reset_password_page.dart';
import '../views/auth/reset_password_verify_page.dart';
import '../views/menu/menu_form/menu_form_page.dart';
import '../views/menu/menu_overview/menu_overview_page.dart';
import '../views/seat/seat_form/seat_form_page.dart';
import '../views/seat/seat_list/seat_list_page.dart';
import '../views/store/store_form/store_form_page.dart';
import '../views/store/store_list/store_list_page.dart';
import '../views/store/store_bottom_tabs_page.dart';
import '../views/store/store_overview/store_overview_page.dart';

class AppRoutes {
  static const auth = '/auth';
  static const login = '/login';
  static const verify = '/verify';
  static const register = '/register';
  static const storeForm = '/storeForm';
  static const storeOverview = '/storeOverview';
  static const storeList = '/storeList';
  static const storeBottomTabs = '/storeBottomTabs';
  static const menuForm = '/menuForm';
  static const menuOverview = '/menuOverview';
  static const resetPassword = '/resetPassword';
  static const resetPasswordVerify = '/resetPasswordVerify';
  static const appBottomTabs = '/appBottomTabs';
  static const resetInfo = '/resetInfo';
  static const seatForm = '/seatForm';
  static const seatList = '/seatList';
  static const setLanguage = '/setLanguage';
}

Map<String, WidgetBuilder> routes = {
  AppRoutes.login: (context) => LoginPage(),
  AppRoutes.verify: (context) => const RegisterVerifyPage(),
  AppRoutes.register: (context) => RegisterPage(),
  AppRoutes.auth: (context) => AuthPage(),
  AppRoutes.storeForm: (context) => const StoreFormPage(),
  AppRoutes.storeOverview: (context) => const StoreOverviewPage(),
  AppRoutes.storeList: (context) => const StoreListPage(),
  AppRoutes.storeBottomTabs: (context) => const StoreBottomTabsPage(),
  AppRoutes.menuForm: (context) => const MenuFormPage(),
  AppRoutes.menuOverview: (context) => const MenuOverviewPage(),
  AppRoutes.resetPassword: (context) => ResetPasswordPage(),
  AppRoutes.resetPasswordVerify: (context) => const ResetPasswordVerifyPage(),
  AppRoutes.appBottomTabs: (context) => const AppBottomTabsPage(),
  AppRoutes.resetInfo: (context) => const ResetInfoPage(),
  AppRoutes.seatForm: (context) => const SeatFormPage(),
  AppRoutes.seatList: (context) => const SeatListPage(),
  AppRoutes.setLanguage: (context) => const SetLanguagePage(),
};
