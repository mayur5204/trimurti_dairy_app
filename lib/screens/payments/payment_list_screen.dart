import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/payment_controller.dart';
import '../../database/app_database.dart';
import '../../widgets/entity_card.dart' as widgets;
import 'payment_form_screen.dart';

class PaymentListScreen extends StatelessWidget {
  const PaymentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () => paymentController.loadPayments(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Obx(() {
            if (paymentController.isLoading &&
                paymentController.payments.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Payments',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(179),
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${paymentController.totalPayments.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.payments,
                          color: colorScheme.onPrimaryContainer,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Payment List
          Expanded(
            child: Obx(() {
              if (paymentController.isLoading &&
                  paymentController.payments.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (paymentController.error.isNotEmpty) {
                return widgets.ErrorDisplayWidget(
                  title: 'Error Loading Payments',
                  description: paymentController.error,
                  onRetry: () => paymentController.loadPayments(),
                );
              }

              if (paymentController.payments.isEmpty) {
                return widgets.EmptyListWidget(
                  icon: Icons.payments,
                  title: 'No Payments Found',
                  description: 'Start by recording your first payment',
                  actionText: 'Add Payment',
                  onActionPressed: () =>
                      _showPaymentForm(context, paymentController),
                );
              }

              return RefreshIndicator(
                onRefresh: () => paymentController.loadPayments(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: paymentController.payments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final payment = paymentController.payments[index];
                    return PaymentCard(
                      payment: payment,
                      customerName: paymentController.getCustomerName(
                        payment.customerId,
                      ),
                      onEdit: () => _showPaymentForm(
                        context,
                        paymentController,
                        payment: payment,
                      ),
                      onDelete: () => _showDeleteDialog(
                        context,
                        paymentController,
                        payment,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPaymentForm(context, paymentController),
        icon: const Icon(Icons.add),
        label: const Text('Add Payment'),
      ),
    );
  }

  void _showPaymentForm(
    BuildContext context,
    PaymentController controller, {
    Payment? payment,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentFormScreen(payment: payment),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    PaymentController controller,
    Payment payment,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Payment'),
          content: Text(
            'Are you sure you want to delete this payment of ₹${payment.amount.toStringAsFixed(2)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deletePayment(payment.id);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class PaymentCard extends StatelessWidget {
  final Payment payment;
  final String customerName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PaymentCard({
    super.key,
    required this.payment,
    required this.customerName,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.payment,
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatDate(payment.date),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${payment.amount.toStringAsFixed(2)}',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (payment.description != null &&
                  payment.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    payment.description!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(179),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit,
                      color: colorScheme.onSurface.withAlpha(179),
                      size: 20,
                    ),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
