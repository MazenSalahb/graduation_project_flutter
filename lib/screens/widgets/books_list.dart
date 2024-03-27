import 'package:flutter/material.dart';
import 'package:graduation_project/models/book_model.dart';
import 'book_widget.dart';

class BooksList extends StatelessWidget {
  const BooksList({
    super.key,
    required this.books,
  });
  final Future<List<BookModel>> books;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 190,
      child: FutureBuilder<List<BookModel>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return BookWidget(
                  book: snapshot.data![index],
                );
              },
              itemCount: snapshot.data!.length,
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}
