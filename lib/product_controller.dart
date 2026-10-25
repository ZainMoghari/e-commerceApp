import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'products.dart' as default_data;

class ProductController extends GetxController {
  static const String storageKey = 'saved_products';

  final RxList<Map<String, dynamic>> products = default_data.products
      .map((product) => Map<String, dynamic>.from(product))
      .toList()
      .obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedProducts = prefs.getString(storageKey);

      if (savedProducts == null) {
        await saveProducts();
        return;
      }

      final decoded = jsonDecode(savedProducts);

      if (decoded is List) {
        products.assignAll(
          decoded.whereType<Map>().map(
            (product) => Map<String, dynamic>.from(product),
          ),
        );
      }
    } catch (e) {
      // Keep the default products if loading fails.
    }
  }

  Future<bool> saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return await prefs.setString(storageKey, jsonEncode(products.toList()));
    } catch (e) {
      return false;
    }
  }

  Future<bool> addProduct(Map<String, dynamic> product) async {
    final newProduct = Map<String, dynamic>.from(product);

    newProduct['id'] ??= DateTime.now().millisecondsSinceEpoch.toString();

    products.add(newProduct);

    final saved = await saveProducts();

    if (!saved) {
      products.removeWhere((item) => item['id'] == newProduct['id']);
    }

    return saved;
  }

  Future<bool> updateProduct(
    String id,
    Map<String, dynamic> updatedProduct,
  ) async {
    final index = products.indexWhere(
      (product) => product['id'].toString() == id,
    );

    if (index == -1) return false;

    final oldProduct = Map<String, dynamic>.from(products[index]);

    products[index] = {...oldProduct, ...updatedProduct, 'id': id};

    final saved = await saveProducts();

    if (!saved) {
      products[index] = oldProduct;
    }

    return saved;
  }

  Future<bool> deleteProduct(String id) async {
    final index = products.indexWhere(
      (product) => product['id'].toString() == id,
    );

    if (index == -1) return false;

    final removedProduct = products.removeAt(index);

    final saved = await saveProducts();

    if (!saved) {
      products.insert(index, removedProduct);
    }

    return saved;
  }
}
