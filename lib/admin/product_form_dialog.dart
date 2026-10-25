import 'package:flutter/material.dart';

class ProductFormDialog extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController subtitleController;
  late final TextEditingController priceController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.product?['title']?.toString() ?? '',
    );

    subtitleController = TextEditingController(
      text: widget.product?['subtitle']?.toString() ?? '',
    );

    priceController = TextEditingController(
      text: widget.product?['price']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    subtitleController.dispose();
    priceController.dispose();
  }

  void saveForm() {
    if (!formKey.currentState!.validate()) return;

    final price = double.parse(priceController.text.trim());

    Navigator.pop(context, <String, dynamic>{
      'title': titleController.text.trim(),
      'subtitle': subtitleController.text.trim(),
      'price': price,
      'image': widget.product?['image'] ?? 'images/headphone.png',
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  final price = double.tryParse(value ?? '');

                  if (price == null || price <= 0) {
                    return 'Enter a valid price';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: saveForm, child: const Text('Save')),
      ],
    );
  }
}
