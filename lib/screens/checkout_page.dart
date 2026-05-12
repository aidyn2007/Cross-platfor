import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class CheckoutPage extends StatefulWidget {
  final CartManager cartManager;
  final Function() didUpdate;
  final Function(Order) onSubmit;

  const CheckoutPage(
      {super.key,
      required this.cartManager,
      required this.didUpdate,
      required this.onSubmit});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Set<int> selectedSegment = {0};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  final DateTime _firstDate = DateTime.now();
  final DateTime _lastDate = DateTime(DateTime.now().year + 1);
  final TextEditingController _nameController = TextEditingController();

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Select Date';
    }
    final formatter = DateFormat('EEE, MMM d');
    return formatter.format(dateTime);
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return 'Select Time';
    }
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void onSegmentSelected(Set<int> segmentIndex) {
    setState(() {
      selectedSegment = segmentIndex;
    });
  }

  Widget _buildOrderSegmentedType() {
    return SegmentedButton<int>(
      showSelectedIcon: true,
      segments: const [
        ButtonSegment(
            value: 0, label: Text('Delivery'), icon: Icon(Icons.delivery_dining)),
        ButtonSegment(
            value: 1, label: Text('Pickup'), icon: Icon(Icons.storefront)),
      ],
      selected: selectedSegment,
      onSelectionChanged: onSegmentSelected,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Contact Name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Widget _buildOrderSummary(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (widget.cartManager.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.shopping_cart_outlined, size: 48, color: colorScheme.outline),
              const SizedBox(height: 16),
              Text('Your cart is empty', style: textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.cartManager.items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = widget.cartManager.itemAt(index);
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            color: colorScheme.errorContainer,
            child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
          ),
          onDismissed: (direction) {
            setState(() {
              widget.cartManager.removeItem(item.id);
            });
            widget.didUpdate();
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              child: Text('${item.quantity}', 
                style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
            ),
            title: Text(item.name, style: textTheme.titleSmall),
            trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', 
              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: widget.cartManager.isEmpty
            ? null
            : () {
          final order = Order(
              selectedSegment: selectedSegment,
              selectedTime: selectedTime,
              selectedDate: selectedDate,
              name: _nameController.text,
              items: widget.cartManager.items);

          widget.cartManager.resetCart();
          widget.onSubmit(order);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline),
            const SizedBox(width: 8),
            Text(
                'Place Order - \$${widget.cartManager.totalCost.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Order Method', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildOrderSegmentedType(),
            const SizedBox(height: 24),
            Text('Delivery Info', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(formatDate(selectedDate)),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.access_time, size: 18),
                    label: Text(formatTimeOfDay(selectedTime)),
                    onPressed: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order Summary', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('${widget.cartManager.items.length} items', style: textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            _buildOrderSummary(context),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: textTheme.bodyLarge),
                Text('\$${widget.cartManager.totalCost.toStringAsFixed(2)}', style: textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Fee', style: textTheme.bodyLarge),
                Text('\$0.00', style: textTheme.bodyLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}
