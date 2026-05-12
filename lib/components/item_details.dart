import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import 'cart_control.dart';

class ItemDetails extends StatefulWidget {
  final Item item;
  final CartManager cartManager;
  final void Function() quantityUpdated;

  const ItemDetails(
      {super.key,
      required this.item,
      required this.cartManager,
      required this.quantityUpdated});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${widget.item.price.toStringAsFixed(2)}',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _mostLikedBadge(colorScheme),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.item.description,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          _itemImage(widget.item.imageUrl, colorScheme),
          const SizedBox(height: 24),
          _addToCartControl(widget.item),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _mostLikedBadge(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.thumb_up, size: 14, color: colorScheme.onPrimaryContainer),
          const SizedBox(width: 4),
          Text(
            'Popular',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemImage(String imageUrl, ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(
        imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 220,
            width: double.infinity,
            color: colorScheme.surfaceVariant,
            child: Icon(Icons.book, size: 64, color: colorScheme.outline),
          );
        },
      ),
    );
  }

  Widget _addToCartControl(Item item) {
    return CartControl(
      addToCart: (number) {
        const uuid = Uuid();
        final uniqueId = uuid.v4();
        final cartItem = CartItem(
            id: uniqueId, name: item.name, price: item.price, quantity: number);
        setState(() {
          widget.cartManager.addItem(cartItem);
          widget.quantityUpdated();
        });
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} added to cart'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                widget.cartManager.removeItem(uniqueId);
                widget.quantityUpdated();
              },
            ),
          ),
        );
      },
    );
  }
}
