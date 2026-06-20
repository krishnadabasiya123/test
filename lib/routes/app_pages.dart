import 'package:get/get.dart';
import 'package:test/modules/ThemeModule/View/theme_change_screen.dart';
import 'package:test/modules/langauge/models/languages.dart';
import 'package:test/modules/langauge/view/language_list.dart';
import 'package:test/routes/app_routes.dart';
import 'package:test/screen/home_screen.dart';
import 'package:test/screen/first_screen.dart';
import 'package:test/screen/second_screen.dart';
import 'package:test/showcaseview/screens/transaction_form.dart';
import 'package:test/ui/animatedScreens/pizzOrderAnimation/pizzaHomeScreen.dart';
import 'package:test/ui/animatedScreens/shopping/shopping_home_screen.dart';
import 'package:test/ui/animatedScreens/ice_cream/ice_cream_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.HOME, page: () => HomeScreen()),
    GetPage(name: AppRoutes.FIRST_SCREEN, page: () => FirstScreen()),
    GetPage(name: AppRoutes.SECOND_SCREEN, page: () => SecondScreen()),
    GetPage(name: AppRoutes.LANGUAGE, page: () => LanguageView()),
    GetPage(
      name: AppRoutes.THEME,
      page: () => ThemeChangeScreen(title: 'Dynamic Theme Changer'),
    ),
    GetPage(
      name: AppRoutes.TRANSACTION_FORM,
      page: () => const TransactionForm(),
    ),
    GetPage(
      name: AppRoutes.PIZZA_HOME,
      page: () => const PizzaHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.SHOPPING,
      page: () => const ShoppingHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.ICE_CREAM,
      page: () => const IceCreamHomeScreen(),
    ),
  ];
}
