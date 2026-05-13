import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/book_details_page.dart';

class CategoryCard extends StatefulWidget {
  final BookCategory category;

  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsPage(category: widget.category),
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'book-image-${widget.category.name}',
              child: Image.asset(
                widget.category.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4.0,
              right: 4.0,
              child: IconButton(
                icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
                color: Colors.red[400],
                onPressed: () {
                  setState(() {
                    _isFavorited = !_isFavorited;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
