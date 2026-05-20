import 'package:flutter/material.dart';
import 'animated_widgets.dart';

class CartControl extends StatefulWidget {
  final void Function(int) addToCart;
  const CartControl({required this.addToCart, super.key});

  @override
  State<CartControl> createState() => _CartControlState();
}

class _CartControlState extends State<CartControl> {
  int _cartNumber = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMinusButton(colorScheme),
          _buildCartNumberContainer(colorScheme),
          _buildPlusButton(colorScheme),
          const SizedBox(width: 16),
          _buildAddCartButton(colorScheme),
        ],
      ),
    );
  }

  Widget _buildMinusButton(ColorScheme colorScheme) {
    return IconButton.filledTonal(
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      icon: const Icon(Icons.remove, size: 20),
      onPressed: _cartNumber > 1 ? () => setState(() => _cartNumber--) : null,
      tooltip: 'Decrease quantity',
    );
  }

  Widget _buildCartNumberContainer(ColorScheme colorScheme) {
    return Container(
      constraints: const BoxConstraints(minWidth: 40),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Text(
          _cartNumber.toString(),
          key: ValueKey<int>(_cartNumber),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
        ),
      ),
    );
  }

  Widget _buildPlusButton(ColorScheme colorScheme) {
    return IconButton.filledTonal(
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      icon: const Icon(Icons.add, size: 20),
      onPressed: () => setState(() => _cartNumber++),
      tooltip: 'Increase quantity',
    );
  }

  Widget _buildAddCartButton(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: AnimatedTapScale(
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          onPressed: () => widget.addToCart(_cartNumber),
          icon: const Icon(Icons.add_shopping_cart, size: 18),
          label:
              const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
