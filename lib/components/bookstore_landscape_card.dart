import 'package:flutter/material.dart';
import 'animated_widgets.dart';
import '../models/models.dart';

class BookstoreLandscapeCard extends StatelessWidget {
  final Bookstore bookstore;
  final Function() onTap;

  const BookstoreLandscapeCard({
    super.key,
    required this.bookstore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return AnimatedTapScale(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: AspectRatio(
                aspectRatio: 2,
                child: Hero(
                  tag: 'bookstore-image-${bookstore.id}',
                  child: Image.asset(bookstore.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            ListTile(
              title: Text(bookstore.name, style: textTheme.titleSmall),
              subtitle: Text(bookstore.attributes,
                  maxLines: 1, style: textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
