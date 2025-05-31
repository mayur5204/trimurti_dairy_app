import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer_controller.dart';
import '../../database/app_database.dart';
import '../../widgets/entity_card.dart';
import 'customer_form_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController controller = Get.put(CustomerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            onPressed: controller.loadCustomers,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Search customers...',
              leading: const Icon(Icons.search),
              onChanged: (query) {
                // Implement search functionality if needed
                // For now, we'll keep it simple
              },
            ),
          ),
          // Customer list
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) => const LoadingEntityCard(),
                );
              }

              if (controller.error.isNotEmpty) {
                return ErrorDisplayWidget(
                  title: 'Error Loading Customers',
                  description: controller.error,
                  onRetry: controller.loadCustomers,
                );
              }

              if (controller.customers.isEmpty) {
                return EmptyListWidget(
                  title: 'No Customers Yet',
                  description:
                      'Add your first customer to get started with dairy management.',
                  icon: Icons.people_outline,
                  actionText: 'Add Customer',
                  onActionPressed: () => _showCustomerForm(context, controller),
                );
              }

              return ListView.builder(
                itemCount: controller.customers.length,
                itemBuilder: (context, index) {
                  final customer = controller.customers[index];
                  return _buildCustomerCard(context, customer, controller);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCustomerForm(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
      ),
    );
  }

  Widget _buildCustomerCard(
    BuildContext context,
    Customer customer,
    CustomerController controller,
  ) {
    return EntityCard(
      title: customer.name,
      subtitle: customer.phone ?? 'No phone number',
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          customer.name.isNotEmpty ? customer.name[0].toUpperCase() : 'C',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      details: [
        if (customer.address != null && customer.address!.isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  customer.address!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Joined: ${customer.dateJoined.day}/${customer.dateJoined.month}/${customer.dateJoined.year}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!customer.isSynced)
            Icon(
              Icons.cloud_off,
              size: 16,
              color: Theme.of(context).colorScheme.outline,
            ),
        ],
      ),
      onEdit: () => _showCustomerForm(context, controller, customer: customer),
      onDelete: () => _showDeleteDialog(context, customer, controller),
    );
  }

  void _showCustomerForm(
    BuildContext context,
    CustomerController controller, {
    Customer? customer,
  }) {
    Get.to(
      () => CustomerFormScreen(customer: customer),
      transition: Transition.rightToLeft,
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Customer customer,
    CustomerController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Customer'),
        content: Text(
          'Are you sure you want to delete ${customer.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.deleteCustomer(customer.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
