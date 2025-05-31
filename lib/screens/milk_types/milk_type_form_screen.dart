import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/milk_type_controller.dart';
import '../../database/app_database.dart';
import '../../widgets/custom_form_field.dart';

class MilkTypeFormScreen extends StatefulWidget {
  final MilkType? milkType;

  const MilkTypeFormScreen({super.key, this.milkType});

  @override
  State<MilkTypeFormScreen> createState() => _MilkTypeFormScreenState();
}

class _MilkTypeFormScreenState extends State<MilkTypeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rateController = TextEditingController();

  bool get isEditing => widget.milkType != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.milkType!.name;
      _rateController.text = widget.milkType!.ratePerLiter.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MilkTypeController controller = Get.find<MilkTypeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Milk Type' : 'Add Milk Type'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header with icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondaryContainer.withAlpha(128),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.local_drink,
                    size: 48,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEditing
                        ? 'Update milk type and pricing information'
                        : 'Add a new milk type with its rate per liter',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Name field
            CustomFormField(
              label: 'Milk Type Name *',
              hint: 'e.g., Full Cream, Toned, Double Toned',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Milk type name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              prefixIcon: const Icon(Icons.local_drink),
            ),

            const SizedBox(height: 16),

            // Rate field
            CustomFormField(
              label: 'Rate per Liter *',
              hint: 'Enter rate in ₹',
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Rate per liter is required';
                }
                final rate = double.tryParse(value);
                if (rate == null) {
                  return 'Please enter a valid number';
                }
                if (rate <= 0) {
                  return 'Rate must be greater than 0';
                }
                if (rate > 1000) {
                  return 'Rate seems too high. Please check.';
                }
                return null;
              },
              prefixIcon: const Icon(Icons.currency_rupee),
              suffixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'per L',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: RepaintBoundary(
                    child: Obx(
                      () => FilledButton(
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                // Provide immediate haptic feedback
                                HapticFeedback.lightImpact();
                                _saveMilkType();
                              },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          disabledBackgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(128),
                        ),
                        child: controller.isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isEditing ? 'Updating...' : 'Adding...',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                isEditing
                                    ? 'Update Milk Type'
                                    : 'Add Milk Type',
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Form validation info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withAlpha(128),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Milk Type Guidelines',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Use clear names like "Full Cream", "Toned", etc.\n'
                    '• Set competitive rates based on quality and market prices\n'
                    '• Rates can be updated anytime based on market changes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMilkType() async {
    if (!_formKey.currentState!.validate()) return;

    final MilkTypeController controller = Get.find<MilkTypeController>();

    final name = _nameController.text.trim();
    final rate = double.parse(_rateController.text.trim());

    print('🚀 Starting save operation for milk type: $name at rate: ₹$rate');

    try {
      // Perform database operation asynchronously
      if (isEditing) {
        print('📝 Updating existing milk type with ID: ${widget.milkType!.id}');
        await controller.updateMilkType(
          id: widget.milkType!.id,
          name: name,
          ratePerLiter: rate,
        );
      } else {
        print('➕ Creating new milk type');
        await controller.createMilkType(name: name, ratePerLiter: rate);
      }

      print('✅ Save operation completed successfully');

      // Navigate back only after successful operation
      if (mounted) {
        print('🔄 Navigating back to list');
        // Close the form first
        Get.back();

        // Then show success message with a slight delay for better UX
        Future.delayed(const Duration(milliseconds: 300), () {
          print('🎉 Showing success message');
          Get.snackbar(
            'Success',
            isEditing
                ? 'Milk type updated successfully'
                : 'Milk type added successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            shouldIconPulse: true,
          );
        });
      }
    } catch (e) {
      print('❌ Error during save operation: $e');

      // Show error message if widget is still mounted
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to save milk type: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          icon: const Icon(Icons.error, color: Colors.white),
          shouldIconPulse: true,
        );
      }
    }
  }
}
