import 'package:flutter/material.dart';
// import 'package:rcdit_user/functions/functions.dart';
// import 'package:rcdit_user/functions/notifications.dart';
// import 'pages/loadingPage/loadingpage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants/component_constants.dart';
import 'functions/function.dart';
import 'pages/loadingPage/loading_page.dart';
import 'injection_container.dart' as di;
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
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

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 25.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;

  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
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
          debugShowCheckedModeBanner: false,
          title: 'EaglesRides',
          theme: ThemeData(),
          home: const LoadingPage(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
