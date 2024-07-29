import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'no_network_widget.dart';

class NetWorkStatusChecker extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  var isNetworkAvl = false.obs;

  @override
  void onInit() {
    print('checking net');
    super.onInit();
    updateConnectionStatus();
  }

  void updateConnectionStatus() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> resultList) {
        if (resultList.isNotEmpty) {
          ConnectivityResult result = resultList.first;
          print(result);
          if (result == ConnectivityResult.none) {
            Get.dialog(const NoInterNetWidget());
            // if (!(Get.isDialogOpen ?? false)) {
            //   Get.dialog(
            //     const NoInterNetWidget(),
            //     barrierDismissible:
            //         false, // Optional: prevents dialog from being dismissed by tapping outside
            //   );
            // }
          } else {
            isNetworkAvl.value = true;
            if (Get.isDialogOpen == true) {
              Get.back(); // Closes the dialog if it's open
            }
          }
        }
      },
    );
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
