import 'package:flutter/material.dart';
// import 'package:rcdit_user/functions/functions.dart';
// import 'package:rcdit_user/functions/notifications.dart';
// import 'pages/loadingPage/loadingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'constants/component_constants.dart';
import 'functions/function.dart';
import 'pages/loadingPage/loading_page.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  checkInternetConnection();

  // initMessaging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    setUpScreenUtils(context);
    setStatusBar();
    return GestureDetector(
      onTap: () {
        //remove keyboard on touching anywhere on the screen.
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EaglesRides',
          theme: ThemeData(),
          home: const LoadingPage(),
        ),
      ),
    );
  }
}
