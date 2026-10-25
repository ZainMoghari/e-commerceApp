
import 'package:get/get.dart';

class CartItem {
  final String id;
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartController extends GetxController {
  final items = <CartItem>[].obs;

  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(
        0.0,
        (sum, item) => sum + item.price * item.quantity,
      );

  void addToCart(CartItem product) {
    final index = items.indexWhere(
      (item) => item.id == product.id,
    );

    if (index != -1) {
      items[index].quantity++;
      items.refresh();
    } else {
      items.add(product);
    }
  }

  void increase(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index == -1) return;

    items[index].quantity++;
    items.refresh();
  }

  void decrease(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index == -1) return;

    if (items[index].quantity > 1) {
      items[index].quantity--;
      items.refresh();
    } else {
      items.removeAt(index);
    }
  }

  void removeItem(String id) {
    items.removeWhere((item) => item.id == id);
  }
}
