import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecommerceapp1/login.dart';
import 'package:ecommerceapp1/cart_controller.dart';
import 'package:ecommerceapp1/product_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<CartController>(CartController(), permanent: true);

  Get.put<ProductController>(ProductController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
