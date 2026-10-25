import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ecommerceapp1/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  static const bg = Color(0xFFFFF7FF);
  static const orange = Color(0xFFFF9800);

  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadOrders();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final loggedInEmail = prefs.getString('logged_in_email') ?? '';
    final savedData = prefs.getString('registered_accounts') ?? '[]';
    final List<dynamic> accounts = jsonDecode(savedData);

    for (var account in accounts) {
      if (account['email'] == loggedInEmail) {
        nameController.text = account['name'] ?? '';
        emailController.text = account['email'] ?? '';
        addressController.text = account['address'] ?? '';
        break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final savedOrders = prefs.getString('orders') ?? '[]';
    final List<dynamic> allOrders = jsonDecode(savedOrders);
    final loggedInEmail = prefs.getString('logged_in_email') ?? '';

    if (!mounted) return;

    setState(() {
      orders = allOrders
          .where((order) => order['email'] == loggedInEmail)
          .map((order) => Map<String, dynamic>.from(order))
          .toList();
    });
  }

  Future<void> cancelOrder(int index) async {
    final prefs = await SharedPreferences.getInstance();

    final savedOrders = prefs.getString('orders') ?? '[]';
    final List<dynamic> allOrders = jsonDecode(savedOrders);
    final orderId = orders[index]['id'];

    for (var order in allOrders) {
      if (order['id'] == orderId && order['status'] == 'Pending') {
        order['status'] = 'Cancelled';
      }
    }

    await prefs.setString('orders', jsonEncode(allOrders));

    await loadOrders();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order cancelled successfully')),
    );
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('registered_accounts') ?? '[]';
    final List<dynamic> accounts = jsonDecode(savedData);

    final oldEmail = prefs.getString('logged_in_email') ?? '';
    final newEmail = emailController.text.trim().toLowerCase();

    for (var account in accounts) {
      if (account['email'] == newEmail && newEmail != oldEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This email is already registered')),
        );
        return;
      }
    }

    bool accountFound = false;

    for (var account in accounts) {
      if (account['email'] == oldEmail) {
        account['name'] = nameController.text.trim();
        account['email'] = newEmail;
        account['address'] = addressController.text.trim();
        accountFound = true;
        break;
      }
    }

    if (!accountFound) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Account not found')));
      return;
    }

    await prefs.setString('registered_accounts', jsonEncode(accounts));
    await prefs.setString('logged_in_email', newEmail);

    if (!mounted) return;

    setState(() {
      emailController.text = newEmail;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_email');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, size: 65, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      nameController.text.isEmpty
                          ? 'My Account'
                          : nameController.text,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      emailController.text,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Full Name',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: inputDecoration(
                  'Enter your name',
                  Icons.person_outline,
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 20),

              const Text(
                'Email Address',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                  'Enter your email',
                  Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                maxLines: 3,
                decoration: inputDecoration(
                  'Enter your address',
                  Icons.location_on_outlined,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 35),
              const Divider(),
              const SizedBox(height: 15),

              const Text(
                'My Orders',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              if (orders.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'You have no orders yet.',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ),

              ...orders.asMap().entries.map((entry) {
                final index = entry.key;
                final order = entry.value;
                final items = order['items'] ?? [];
                final status = order['status'] ?? 'Pending';

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shopping_bag_outlined),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Order #${order['id']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ...items.map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '${item['name']} x${item['quantity']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }),

                        const SizedBox(height: 8),
                        Text(
                          'Total: ${order['total']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: status == 'Pending'
                                    ? orange
                                    : status == 'Cancelled'
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        if (status == 'Pending') ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => cancelOrder(index),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                              child: const Text('Cancel Order'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: logout,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0D9E3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0D9E3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: orange),
      ),
    );
  }
}
