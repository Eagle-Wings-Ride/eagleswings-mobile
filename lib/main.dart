import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:rcdit_user/functions/functions.dart';
// import 'package:rcdit_user/functions/notifications.dart';
// import 'pages/loadingPage/loadingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants/component_constants.dart';
import 'core/network_checker/network_checker_controller.dart';
import 'functions/function.dart';
import 'pages/loadingPage/loading_page.dart';
import 'injection_container.dart' as di;
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ),
      ),
    );
  }
}
