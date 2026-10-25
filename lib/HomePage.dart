
import 'package:flutter/material.dart';
import 'package:ecommerceapp1/details.dart';
import 'package:ecommerceapp1/login.dart';
import 'package:ecommerceapp1/cart_page.dart';
import 'package:ecommerceapp1/cart_icon.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';

  final List<Map<String, dynamic>> items = [
    {
      "id": "headphone1",
      "image": "images/headphone.png",
      "title": "HeadPhone",
      "subtitle": "Description",
      "price": "350\$",
    },
    {
      "id": "watch1",
      "image": "images/smart.png",
      "title": "Smart Watch",
      "subtitle": "12 hours battery",
      "price": "150\$",
    },
    {
      "id": "laptop1",
      "image": "images/headphone.png",
      "title": "Labtop",
      "subtitle": "Description",
      "price": "350\$",
    },
    {
      "id": "watch2",
      "image": "images/smart.png",
      "title": "Smart Watch",
      "subtitle": "Description 12 hours battery",
      "price": "150\$",
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.where((product) {
      final title = product['title'].toString().toLowerCase();
      return title.contains(searchQuery.toLowerCase().trim());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        iconSize: 25,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          }
        },

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: CartIcon(),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Search Bar
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Show Best Selling only when not searching
              if (searchQuery.trim().isEmpty) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Best Selling",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Products
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : GridView.builder(
                        itemCount: filteredItems.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 200,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, i) {
                          final product = filteredItems[i];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => itemdetails(
                                    data: product,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              surfaceTintColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 112,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Image.asset(
                                      product['image'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  Text(
                                    product['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    product['subtitle'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ),

                                  Text(
                                    product['price'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.amber[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
