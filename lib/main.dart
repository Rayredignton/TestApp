import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pawltest/core/local_db.dart';
import 'package:pawltest/core/locator.dart';
import 'package:pawltest/core/network_info.dart';
import 'package:pawltest/core/network_vm.dart';
import 'package:pawltest/features/cart/presentation/cart_vm.dart';
import 'package:pawltest/features/connectivity/data/connectivity_service.dart';

import 'package:pawltest/features/feed/presentation/product_vm.dart';
import 'package:pawltest/features/home/presentation/main_view.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  final db = LocalDb();
  await db.init();

  runApp(
    MultiProvider(
      providers: [
        // Initialize ConnectivityProvider first
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => NetworkVm(NetworkInfo())),
        ChangeNotifierProvider(create: (_) => FeedVm()),
        ChangeNotifierProvider(create: (_) => CartVm()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey, // Add navigator key
          title: 'Pawl Stores',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MainView(),
        );
      },
    );
  }
}