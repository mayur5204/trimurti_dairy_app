import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/sale_controller.dart';
import '../../database/app_database.dart';
import '../../widgets/custom_form_field.dart';

class SaleFormScreen extends StatefulWidget {
  final Sale? sale;

  const SaleFormScreen({super.key, this.sale});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedCustomerId;
  int? _selectedMilkTypeId;
  DateTime _selectedDate = DateTime.now();
  double _calculatedTotal = 0.0;

  bool get isEditing => widget.sale != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _selectedCustomerId = widget.sale!.customerId;
      _selectedMilkTypeId = widget.sale!.milkTypeId;
      _selectedDate = widget.sale!.date;
      _quantityController.text = widget.sale!.quantity.toString();
      _rateController.text = widget.sale!.rate.toString();
      _notesController.text = widget.sale!.notes ?? '';
      _calculateTotal();
    }

    // Add listeners to calculate total
    _quantityController.addListener(_calculateTotal);
    _rateController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _rateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final quantity = double.tryParse(_quantityController.text) ?? 0.0;
    final rate = double.tryParse(_rateController.text) ?? 0.0;
    setState(() {
      _calculatedTotal = quantity * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SaleController controller = Get.find<SaleController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Sale' : 'Record Sale'),
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
                ).colorScheme.tertiaryContainer.withAlpha(128),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.receipt_long,
                    size: 48,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEditing
                        ? 'Update sale information'
                        : 'Record a new milk sale transaction',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Customer dropdown
            CustomDropdownField<int>(
              label: 'Customer *',
              hint: 'Select customer',
              value: _selectedCustomerId,
              items: controller.customers
                  .map(
                    (customer) => DropdownMenuItem<int>(
                      value: customer.id,
                      child: Text(customer.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCustomerId = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a customer';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Milk Type dropdown
            CustomDropdownField<int>(
              label: 'Milk Type *',
              hint: 'Select milk type',
              value: _selectedMilkTypeId,
              items: controller.milkTypes
                  .map(
                    (milkType) => DropdownMenuItem<int>(
                      value: milkType.id,
                      child: Text(
                        '${milkType.name} (₹${milkType.ratePerLiter.toStringAsFixed(2)}/L)',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMilkTypeId = value;
                  // Auto-fill rate when milk type is selected
                  if (value != null) {
                    final milkType = controller.milkTypes.firstWhere(
                      (m) => m.id == value,
                    );
                    _rateController.text = milkType.ratePerLiter.toString();
                  }
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a milk type';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Date field
            CustomDateField(
              label: 'Sale Date *',
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              validator: (date) {
                if (date == null) {
                  return 'Please select a date';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Quantity and Rate in a row
            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    label: 'Quantity (Liters) *',
                    hint: 'Enter quantity',
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Quantity is required';
                      }
                      final quantity = double.tryParse(value);
                      if (quantity == null) {
                        return 'Invalid quantity';
                      }
                      if (quantity <= 0) {
                        return 'Quantity must be > 0';
                      }
                      if (quantity > 1000) {
                        return 'Quantity seems too high';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.local_drink),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomFormField(
                    label: 'Rate per Liter *',
                    hint: 'Enter rate',
                    controller: _rateController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Rate is required';
                      }
                      final rate = double.tryParse(value);
                      if (rate == null) {
                        return 'Invalid rate';
                      }
                      if (rate <= 0) {
                        return 'Rate must be > 0';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.currency_rupee),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Total amount display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withAlpha(128),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withAlpha(100),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calculate,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Total Amount: ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    '₹${_calculatedTotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Notes field
            CustomFormField(
              label: 'Notes (Optional)',
              hint: 'Add any additional notes...',
              controller: _notesController,
              maxLines: 3,
              prefixIcon: const Icon(Icons.note),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => RepaintBoundary(
                      child: FilledButton(
                        onPressed: controller.isLoading ? null : _saveSale,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isEditing ? 'Updating...' : 'Recording...',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            : Text(
                                isEditing ? 'Update Sale' : 'Record Sale',
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Form info
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
                      'The rate will be auto-filled based on the selected milk type, but you can modify it if needed.',
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

  Future<void> _saveSale() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      return;
    }

    // Provide immediate haptic feedback for button press
    HapticFeedback.lightImpact();

    try {
      final SaleController controller = Get.find<SaleController>();

      final quantity = double.parse(_quantityController.text.trim());
      final rate = double.parse(_rateController.text.trim());
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      if (isEditing) {
        await controller.updateSale(
          id: widget.sale!.id,
          customerId: _selectedCustomerId!,
          milkTypeId: _selectedMilkTypeId!,
          date: _selectedDate,
          quantity: quantity,
          rate: rate,
          notes: notes,
        );

        // Success haptic feedback
        HapticFeedback.mediumImpact();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Sale updated successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );

          await Future.delayed(const Duration(milliseconds: 500));
          Get.back();
        }
      } else {
        await controller.createSale(
          customerId: _selectedCustomerId!,
          milkTypeId: _selectedMilkTypeId!,
          date: _selectedDate,
          quantity: quantity,
          rate: rate,
          notes: notes,
        );

        // Success haptic feedback
        HapticFeedback.mediumImpact();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Sale recorded successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );

          await Future.delayed(const Duration(milliseconds: 500));
          Get.back();
        }
      }
    } catch (e) {
      // Error haptic feedback
      HapticFeedback.heavyImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
