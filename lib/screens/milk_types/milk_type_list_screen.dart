import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/milk_type_controller.dart';
import '../../database/app_database.dart';
import '../../widgets/entity_card.dart';
import 'milk_type_form_screen.dart';

class MilkTypeListScreen extends StatelessWidget {
  const MilkTypeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MilkTypeController controller = Get.put(MilkTypeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Milk Types'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            onPressed: controller.loadMilkTypes,
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
              hintText: 'Search milk types...',
              leading: const Icon(Icons.search),
              onChanged: (query) {
                // Implement search functionality if needed
              },
            ),
          ),
          // Milk types list
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) => const LoadingEntityCard(),
                );
              }

              if (controller.error.isNotEmpty) {
                return ErrorDisplayWidget(
                  title: 'Error Loading Milk Types',
                  description: controller.error,
                  onRetry: controller.loadMilkTypes,
                );
              }

              if (controller.milkTypes.isEmpty) {
                return EmptyListWidget(
                  title: 'No Milk Types Yet',
                  description:
                      'Add different types of milk with their rates to manage your dairy inventory.',
                  icon: Icons.local_drink_outlined,
                  actionText: 'Add Milk Type',
                  onActionPressed: () => _showMilkTypeForm(context, controller),
                );
              }

              return ListView.builder(
                itemCount: controller.milkTypes.length,
                itemBuilder: (context, index) {
                  final milkType = controller.milkTypes[index];
                  return _buildMilkTypeCard(context, milkType, controller);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMilkTypeForm(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Add Milk Type'),
      ),
    );
  }

  Widget _buildMilkTypeCard(
    BuildContext context,
    MilkType milkType,
    MilkTypeController controller,
  ) {
    return EntityCard(
      title: milkType.name,
      subtitle: '₹${milkType.ratePerLiter.toStringAsFixed(2)} per liter',
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: Icon(
          Icons.local_drink,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      details: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withAlpha(128),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Rate: ₹${milkType.ratePerLiter.toStringAsFixed(2)}/L',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!milkType.isSynced)
            Icon(
              Icons.cloud_off,
              size: 16,
              color: Theme.of(context).colorScheme.outline,
            ),
        ],
      ),
      onEdit: () => _showMilkTypeForm(context, controller, milkType: milkType),
      onDelete: () => _showDeleteDialog(context, milkType, controller),
    );
  }

  void _showMilkTypeForm(
    BuildContext context,
    MilkTypeController controller, {
    MilkType? milkType,
  }) {
    Get.to(
      () => MilkTypeFormScreen(milkType: milkType),
      transition: Transition.rightToLeft,
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    MilkType milkType,
    MilkTypeController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Milk Type'),
        content: Text(
          'Are you sure you want to delete ${milkType.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.deleteMilkType(milkType.id);
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
