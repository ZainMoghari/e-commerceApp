
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerceapp1/login.dart';
import 'package:ecommerceapp1/cart_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize CartController once for the entire app
  Get.put<CartController>(
    CartController(),
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // First screen is Login Page
      home: const LoginPage(),
    );
  }
}
