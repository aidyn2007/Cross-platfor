import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../models/models.dart';
import 'animated_widgets.dart';
import 'bookstore_landscape_card.dart';

class BookstoreSection extends StatelessWidget {
  final List<Bookstore> bookstores;
  final CartManager cartManager;
  final OrderManager orderManager;

  const BookstoreSection(
      {super.key,
      required this.bookstores,
      required this.cartManager,
      required this.orderManager});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              'Genre',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bookstores.length,
              itemBuilder: (context, index) {
                return AnimatedSlideFade(
                  delay: Duration(milliseconds: 70 * (index > 6 ? 6 : index)),
                  beginOffset: const Offset(0.12, 0),
                  child: SizedBox(
                    width: 300,
                    child: BookstoreLandscapeCard(
                      bookstore: bookstores[index],
                      onTap: () {
                        context.go(
                            '/${BooksTab.home.value}/bookstore/${bookstores[index].id}');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
