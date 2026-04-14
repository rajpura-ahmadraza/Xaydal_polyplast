import 'package:get/get.dart';
import '../bindings/bindings.dart';
import '../views/splash_view.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/home_view.dart';
import '../views/add_order_view.dart';
import '../views/add_product_view.dart';
import '../views/add_customer_view.dart';
import '../views/add_brochure_view.dart';

class AppRoutes {
  static const splash      = '/splash';
  static const login       = '/login';
  static const register    = '/register';
  static const home        = '/';
  static const addOrder    = '/add-order';
  static const addProduct  = '/add-product';
  static const addCustomer = '/add-customer';
  static const addBrochure = '/add-brochure';

  static final pages = [
    GetPage(name: splash,      page: () => const SplashView(),      binding: AuthBinding()),
    GetPage(name: login,       page: () => const LoginView(),       binding: AuthBinding()),
    GetPage(name: register,    page: () => const RegisterView(),    binding: AuthBinding()),
    GetPage(name: home,        page: () => const HomeView(),        binding: AppBinding()),
    GetPage(name: addOrder,    page: () => const AddOrderView()),
    GetPage(name: addProduct,  page: () => const AddProductView()),
    GetPage(name: addCustomer, page: () => const AddCustomerView()),
    GetPage(name: addBrochure, page: () => const AddBrochureView()),
  ];
}
