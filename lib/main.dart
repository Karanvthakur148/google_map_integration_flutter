import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_configs/app_routes.dart';
import 'hompage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Db().setPreference(prefs);
  //AuthDb.setPreference(prefs);
  runApp(
    ScreenUtilInit(
      designSize: const Size(392.72, 825.45),
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(Get.context!).requestFocus(FocusNode());
          },
          child: GetMaterialApp(
            title: "map",
            theme: ThemeData(
              primaryColor: Colors.lightBlue,
              textTheme: GoogleFonts.robotoSlabTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            debugShowCheckedModeBanner: false,
            // initialRoute: StartScreen.routeName,
            initialRoute: HomePage.routeName,
            getPages: AppPages.pages,
            defaultTransition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
    ),
  );
}
