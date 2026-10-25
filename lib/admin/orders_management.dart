import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersManagement extends StatefulWidget {
  const OrdersManagement({super.key});

  @override
  State<OrdersManagement> createState() => _OrdersManagementState();
}

class _OrdersManagementState extends State<OrdersManagement> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  final List<String> statuses = [
    'Pending',
    'Processing',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedOrders = prefs.getString('orders');

      List<Map<String, dynamic>> loadedOrders = [];

      if (savedOrders != null && savedOrders.isNotEmpty) {
        final decoded = jsonDecode(savedOrders);

        if (decoded is List) {
          loadedOrders = decoded
              .whereType<Map>()
              .map((order) => Map<String, dynamic>.from(order))
              .toList();
        }
      }

      if (!mounted) return;

      setState(() {
        orders = loadedOrders.reversed.toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not load orders')));
    }
  }

  Future<void> updateOrderStatus(
    Map<String, dynamic> order,
    String newStatus,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedOrders = prefs.getString('orders');

      if (savedOrders == null || savedOrders.isEmpty) {
        throw Exception('No saved orders found');
      }

      final decoded = jsonDecode(savedOrders);

      if (decoded is! List) {
        throw Exception('Invalid orders data');
      }

      final storedOrders = decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      final orderId = order['id']?.toString();

      final index = storedOrders.indexWhere(
        (item) => item['id']?.toString() == orderId,
      );

      if (index == -1) {
        throw Exception('Order not found');
      }

      storedOrders[index]['status'] = newStatus;

      final saved = await prefs.setString('orders', jsonEncode(storedOrders));

      if (!saved) {
        throw Exception('Could not save order status');
      }

      if (!mounted) return;

      setState(() {
        order['status'] = newStatus;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status changed to $newStatus')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );

      await loadOrders();
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Manage Orders',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  loadOrders();
                },
                tooltip: 'Refresh orders',
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Total orders: ${orders.length}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: orders.isEmpty
              ? const Center(child: Text('No orders available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    final orderId = order['id']?.toString() ?? 'Unknown';

                    final email = order['email']?.toString() ?? 'Unknown';

                    final total =
                        double.tryParse(order['total']?.toString() ?? '') ??
                        0.0;

                    final rawStatus = order['status']?.toString() ?? 'Pending';

                    final status = statuses.contains(rawStatus)
                        ? rawStatus
                        : 'Pending';

                    final items = order['items'] is List
                        ? order['items'] as List
                        : [];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #$orderId',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Customer: $email'),
                            const SizedBox(height: 12),
                            const Text(
                              'Products:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            if (items.isEmpty)
                              const Text('No product details')
                            else
                              ...items.map((item) {
                                if (item is! Map) {
                                  return const SizedBox.shrink();
                                }

                                final name =
                                    item['name']?.toString() ?? 'Product';

                                final quantity =
                                    item['quantity']?.toString() ?? '1';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text('$name × $quantity'),
                                );
                              }),
                            const Divider(height: 24),
                            Text(
                              'Total: \$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Status:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButton<String>(
                                    value: status,
                                    isExpanded: true,
                                    items: statuses.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: statusColor(value),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newStatus) {
                                      if (newStatus == null ||
                                          newStatus == status) {
                                        return;
                                      }

                                      updateOrderStatus(order, newStatus);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
