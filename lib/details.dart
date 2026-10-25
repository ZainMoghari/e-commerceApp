import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerceapp1/cart_controller.dart';
import 'package:ecommerceapp1/cart_page.dart';
import 'package:ecommerceapp1/cart_icon.dart';
import 'package:ecommerceapp1/homepage.dart';

class itemdetails extends StatefulWidget {
  final Map<String, dynamic> data;

  const itemdetails({super.key, required this.data});

  @override
  State<itemdetails> createState() => _itemdetailsState();
}

class _itemdetailsState extends State<itemdetails> {
  final CartController cart = Get.find<CartController>();

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage()),
    );
  }

  void goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
      (route) => route.isFirst,
    );
  }

  void addProductToCart() {
    final product = widget.data;

    final price = (product['price'] as num).toDouble();

    cart.addToCart(
      CartItem(
        id: product['id'].toString(),
        name: product['title'].toString(),
        image: product['image'].toString(),
        price: price,
      ),
    );

    openCart();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.data;
    final price = (product['price'] as num).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        iconSize: 30,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            goHome();
          } else if (index == 1) {
            openCart();
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: CartIcon(), label: "Cart"),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),

      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shop_two_outlined, color: Colors.black),
            Text(
              " Zain ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Shop",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),

            Image.asset(
              product['image'].toString(),
              height: 370,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 25),

            Text(
              product['title'].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              '\$${price.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                product['subtitle'].toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 35),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: addProductToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Add To Cart",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
