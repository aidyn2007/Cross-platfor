import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../constants.dart';

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
                return SizedBox(
                    width: 300,
                    child: BookstoreLandscapeCard(
                      bookstore: bookstores[index],
                      onTap: () {
                        context.go('/${YummyTab.home.value}/bookstore/${bookstores[index].id}');
                      },
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
