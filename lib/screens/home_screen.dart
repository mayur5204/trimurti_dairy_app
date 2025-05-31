import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../services/firebase_auth_service.dart';
import 'customers/customer_list_screen.dart';
import 'milk_types/milk_type_list_screen.dart';
import 'sales/sale_list_screen.dart';
import 'payments/payment_list_screen.dart';

/// Home screen displayed after successful authentication
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _authService = FirebaseAuthService();

  /// Handle sign out
  Future<void> _handleSignOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        // Use GetX navigation for consistency and proper controller cleanup
        Get.offAllNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Sign Out Error',
          'Error signing out: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dairy App'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.green[700], size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back!',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? 'User',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions Section
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Feature Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildFeatureCard(
                    icon: Icons.local_drink,
                    title: 'Milk Types',
                    subtitle: 'Manage milk varieties',
                    color: Colors.blue,
                    onTap: () => Get.to(() => const MilkTypeListScreen()),
                  ),
                  _buildFeatureCard(
                    icon: Icons.people,
                    title: 'Customers',
                    subtitle: 'Customer management',
                    color: Colors.orange,
                    onTap: () => Get.to(() => const CustomerListScreen()),
                  ),
                  _buildFeatureCard(
                    icon: Icons.shopping_cart,
                    title: 'Sales',
                    subtitle: 'Record sales',
                    color: Colors.purple,
                    onTap: () => Get.to(() => const SaleListScreen()),
                  ),
                  _buildFeatureCard(
                    icon: Icons.payment,
                    title: 'Payments',
                    subtitle: 'Track payments',
                    color: Colors.green,
                    onTap: () => Get.to(() => const PaymentListScreen()),
                  ),
                  _buildFeatureCard(
                    icon: Icons.analytics,
                    title: 'Reports',
                    subtitle: 'Sales & analytics',
                    color: Colors.teal,
                    onTap: () => _showComingSoon('Reports'),
                  ),
                  _buildFeatureCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    color: Colors.grey,
                    onTap: () => _showComingSoon('Settings'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build feature card widget
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show coming soon dialog
  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature Feature'),
        content: Text(
          '$feature functionality will be available in Phase 2 of development.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
