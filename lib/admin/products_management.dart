import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerceapp1/product_controller.dart';
import 'product_form_dialog.dart';

class ProductsManagement extends StatelessWidget {
  const ProductsManagement({super.key});

  Future<void> showProductForm(
    BuildContext context,
    ProductController controller, {
    Map<String, dynamic>? product,
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ProductFormDialog(product: product),
    );

    if (result == null || !context.mounted) return;

    final bool saved;

    if (product == null) {
      saved = await controller.addProduct(result);
    } else {
      saved = await controller.updateProduct(product['id'].toString(), result);
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? product == null
                    ? 'Product added successfully'
                    : 'Product updated successfully'
              : 'Could not save product',
        ),
      ),
    );
  }

  Future<void> deleteProduct(
    BuildContext context,
    ProductController controller,
    Map<String, dynamic> product,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product['title']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final saved = await controller.deleteProduct(product['id'].toString());

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? 'Product deleted successfully' : 'Could not delete product',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Products',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add, edit or delete products',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => showProductForm(context, controller),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              final products = controller.products;

              if (products.isEmpty) {
                return const Center(child: Text('No products available'));
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: Image.asset(
                        product['image']?.toString() ?? '',
                        width: 55,
                        height: 55,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 55,
                            height: 55,
                            child: Icon(Icons.image_not_supported_outlined),
                          );
                        },
                      ),
                      title: Text(
                        product['title']?.toString() ?? 'No title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${product['subtitle'] ?? ''}\n'
                        'Price: \$${product['price']}',
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            showProductForm(
                              context,
                              controller,
                              product: product,
                            );
                          } else if (value == 'delete') {
                            deleteProduct(context, controller, product);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
