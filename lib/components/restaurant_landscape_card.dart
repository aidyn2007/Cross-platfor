import 'package:flutter/material.dart';
import '../models/models.dart';

class RestaurantLandscapeCard extends StatelessWidget {
  final Restaurant restaurant;
  final Function() onTap;

  const RestaurantLandscapeCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: AspectRatio(
                  aspectRatio: 2,
                  child: Hero(
                    tag: 'restaurant-image-${restaurant.id}',
                    child: Image.asset(restaurant.imageUrl, fit: BoxFit.cover),
                  ),
                ),
            ),
            ListTile(
              title: Text(restaurant.name, style: textTheme.titleSmall),
              subtitle: Text(restaurant.attributes,
                  maxLines: 1, style: textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
