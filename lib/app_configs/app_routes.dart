import 'package:get/get.dart';

import '../hompage.dart';
import 'app_bindings.dart';

class AppPages {
  static List<GetPage> pages = [
    // GetPage(
    //   name: SplashScreen.routeName,
    //   page: () => const SplashScreen(),
    //   binding: SplashScreenBindings(),
    // ),
    // GetPage(
    //   name: OtpScreen.routeName,
    //   page: () => const OtpScreen(),
    //   binding: OtpPageBindings(),
    // ),
    // GetPage(
    //   name: LogInPage.routeName,
    //   page: () => const LogInPage(),
    //   binding: LogInPageBindings(),
    // ),
    // GetPage(
    //   name: RegistrationScreen.routeName,
    //   page: () => const RegistrationScreen(),
    //   binding: RegistrationPageBindings(),
    // ),
    GetPage(
      name: HomePage.routeName,
      page: () => HomePage(),
      binding: HomePageBindings(),
    ),
  ];
}
