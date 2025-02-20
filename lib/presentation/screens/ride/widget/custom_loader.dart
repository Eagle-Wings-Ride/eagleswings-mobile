import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../pages/loadingPage/loading.dart';
import '../../../../styles/styles.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 0.2,
      child: SizedBox(
        height: 50,
        width: 50,
        child: Loading(),
      ),
    );
  }
}
