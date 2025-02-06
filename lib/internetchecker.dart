import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/No_internetscreen.dart';
import 'package:get/get.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;

  const InternetChecker({Key? key, required this.child}) : super(key: key);

  @override
  State<InternetChecker> createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();

    // Listen to connectivity changes
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      print('Connectivity changed: $results');

      // Check if there is no connectivity
      bool isDisconnected = results.contains(ConnectivityResult.none);

      setState(() {
        _hasInternet = !isDisconnected;
      });

      if (isDisconnected) {
        // No Internet connection
        if (mounted && Get.currentRoute != '/no_internet') {
          // Use GetX navigation to push the NoInternetscreen
          Get.to(() => const NoInternetscreen());
        }
      } else {
        // Internet connection restored
        if (mounted && Get.currentRoute == '') {
          // Use GetX navigation to pop the NoInternetscreen and go back
          Navigator.pop(context);
          Get.back();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
