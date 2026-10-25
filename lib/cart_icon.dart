
import 'package:ecommerceapp1/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CartIcon extends StatelessWidget {
  CartIcon({super.key});

  final CartController cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Badge(
        isLabelVisible: cart.totalItems > 0,
        label: Text('${cart.totalItems}'),
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        child: const Icon(
          Icons.shopping_bag_outlined,
          size: 27,
        ),
      ),
    );
  }
}
