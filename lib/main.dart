import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
// import 'package:rcdit_user/functions/functions.dart';
// import 'package:rcdit_user/functions/notifications.dart';
// import 'pages/loadingPage/loadingpage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants/component_constants.dart';
import 'pages/loadingPage/loading_page.dart';
import 'injection_container.dart' as di;
// import 'firebase_options.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // configLoading();
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await di.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); // lock orientation

  // checkInternetConnection();
  // Initialize the network status checker globally
  // Get.put(NetWorkStatusChecker(), permanent: true);

  // initMessaging();
  runApp(const MyApp());
}

// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..loadingStyle = EasyLoadingStyle.custom // Use custom styling
//     ..indicatorSize = 25.0
//     ..radius = 10.0
//     ..progressColor = Colors.yellow
//     ..backgroundColor = Colors.transparent // Remove background color
//     ..indicatorColor = Colors.yellow
//     ..textColor = Colors.yellow
//     ..maskColor = Colors.transparent // Remove overlay mask color
//     ..userInteractions = true
//     ..dismissOnTap = false;
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // platform = Theme.of(context).platform;
    setUpScreenUtils(context);
    setStatusBar();
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'EaglesRides',
          theme: ThemeData(
            highlightColor: backgroundColor,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
            ),
          ),
          home: const LoadingPage(),
          // builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
