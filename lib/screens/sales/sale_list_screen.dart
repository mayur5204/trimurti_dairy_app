import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sale_controller.dart';
import '../../database/app_database.dart';
import '../../widgets/entity_card.dart';
import 'sale_form_screen.dart';

class SaleListScreen extends StatelessWidget {
  const SaleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SaleController controller = Get.put(SaleController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            onPressed: controller.loadData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary cards
          Obx(() => _buildSummaryCards(context, controller)),

          const SizedBox(height: 8),

          // Search and filter bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    hintText: 'Search sales...',
                    leading: const Icon(Icons.search),
                    onChanged: (query) {
                      // Implement search functionality if needed
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showFilterOptions(context),
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Sales list
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
                  title: 'Error Loading Sales',
                  description: controller.error,
                  onRetry: controller.loadData,
                );
              }

              if (controller.sales.isEmpty) {
                return EmptyListWidget(
                  title: 'No Sales Recorded',
                  description:
                      'Start recording your daily milk sales to track your business.',
                  icon: Icons.receipt_long_outlined,
                  actionText: 'Record Sale',
                  onActionPressed: () => _showSaleForm(context, controller),
                );
              }

              // Sort sales by date (newest first)
              final sortedSales = List<Sale>.from(controller.sales)
                ..sort((a, b) => b.date.compareTo(a.date));

              return ListView.builder(
                itemCount: sortedSales.length,
                itemBuilder: (context, index) {
                  final sale = sortedSales[index];
                  return _buildSaleCard(context, sale, controller);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSaleForm(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Record Sale'),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, SaleController controller) {
    if (controller.sales.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 120,
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              context,
              'Total Sales',
              '₹${controller.totalRevenue.toStringAsFixed(2)}',
              Icons.currency_rupee,
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              context,
              'Total Quantity',
              '${controller.totalQuantity.toStringAsFixed(1)}L',
              Icons.local_drink,
              Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleCard(
    BuildContext context,
    Sale sale,
    SaleController controller,
  ) {
    final customerName = controller.getCustomerName(sale.customerId);
    final milkTypeName = controller.getMilkTypeName(sale.milkTypeId);
    final totalAmount = sale.quantity * sale.rate;

    return EntityCard(
      title: customerName,
      subtitle: '${sale.quantity.toStringAsFixed(1)}L of $milkTypeName',
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: Icon(
          Icons.receipt,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ),
      details: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              '${sale.date.day}/${sale.date.month}/${sale.date.year}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.local_drink_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              '${sale.quantity.toStringAsFixed(1)}L × ₹${sale.rate.toStringAsFixed(2)}/L',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (sale.notes != null && sale.notes!.isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.note_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sale.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!sale.isSynced)
            Icon(
              Icons.cloud_off,
              size: 16,
              color: Theme.of(context).colorScheme.outline,
            ),
        ],
      ),
      onEdit: () => _showSaleForm(context, controller, sale: sale),
      onDelete: () => _showDeleteDialog(context, sale, controller),
    );
  }

  void _showSaleForm(
    BuildContext context,
    SaleController controller, {
    Sale? sale,
  }) {
    Get.to(
      () => SaleFormScreen(sale: sale),
      transition: Transition.rightToLeft,
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Sale sale,
    SaleController controller,
  ) {
    final customerName = controller.getCustomerName(sale.customerId);

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Sale'),
        content: Text(
          'Are you sure you want to delete this sale record for $customerName? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.deleteSale(sale.id);
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

  void _showFilterOptions(BuildContext context) {
    Get.snackbar(
      'Coming Soon',
      'Filter options will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
