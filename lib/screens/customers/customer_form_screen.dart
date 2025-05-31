import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/customer_controller.dart';
import '../../database/app_database.dart';
import '../../widgets/custom_form_field.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;

  const CustomerFormScreen({super.key, this.customer});

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  bool get isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.customer!.name;
      _addressController.text = widget.customer!.address ?? '';
      _phoneController.text = widget.customer!.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CustomerController controller = Get.find<CustomerController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Customer' : 'Add Customer'),
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
                ).colorScheme.primaryContainer.withAlpha(128),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.person_add,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEditing
                        ? 'Update customer information'
                        : 'Add a new customer to your dairy',
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
              label: 'Customer Name *',
              hint: 'Enter customer name',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Customer name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              prefixIcon: const Icon(Icons.person),
            ),

            const SizedBox(height: 16),

            // Phone field
            CustomFormField(
              label: 'Phone Number',
              hint: 'Enter phone number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length < 10) {
                    return 'Phone number must be at least 10 digits';
                  }
                  if (!RegExp(r'^[\d\s\+\-\(\)]+$').hasMatch(value)) {
                    return 'Invalid phone number format';
                  }
                }
                return null;
              },
              prefixIcon: const Icon(Icons.phone),
            ),

            const SizedBox(height: 16),

            // Address field
            CustomFormField(
              label: 'Address',
              hint: 'Enter customer address',
              controller: _addressController,
              maxLines: 3,
              prefixIcon: const Icon(Icons.location_on),
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
                                _saveCustomer();
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
                                isEditing ? 'Update Customer' : 'Add Customer',
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
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Fields marked with * are required. Customer information can be updated anytime.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
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

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    final CustomerController controller = Get.find<CustomerController>();

    final name = _nameController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();
    final phone = _phoneController.text.trim().isEmpty
        ? null
        : _phoneController.text.trim();

    print('🚀 Starting save operation for customer: $name');

    try {
      // Perform database operation asynchronously
      if (isEditing) {
        print('📝 Updating existing customer with ID: ${widget.customer!.id}');
        await controller.updateCustomer(
          id: widget.customer!.id,
          name: name,
          address: address,
          phone: phone,
        );
      } else {
        print('➕ Creating new customer');
        await controller.createCustomer(
          name: name,
          address: address,
          phone: phone,
        );
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
                ? 'Customer updated successfully'
                : 'Customer added successfully',
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
          'Failed to save customer: ${e.toString()}',
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
