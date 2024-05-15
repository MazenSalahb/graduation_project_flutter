import 'package:flutter/material.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:shimmer/shimmer.dart';
import 'book_widget.dart';

class BooksList extends StatelessWidget {
  const BooksList({
    super.key,
    required this.books,
    required this.isSwapBook,
  });
  final Future<List<BookModel>> books;
  final bool isSwapBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: isSwapBook ? 320 : 200,
      decoration: isSwapBook
          ? const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/books_bg.png'),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: FutureBuilder<List<BookModel>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BooksSimmer(
              isSwapBook: isSwapBook,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return BookWidget(
                    book: snapshot.data![index],
                    isSwapBook: isSwapBook,
                  );
                },
                itemCount: snapshot.data!.length,
              ),
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

class BooksSimmer extends StatelessWidget {
  const BooksSimmer({
    super.key,
    required this.isSwapBook,
  });
  final bool isSwapBook;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surfaceVariant,
          child: BookWidget(
            isSwapBook: isSwapBook,
            book: BookModel(
              id: -1,
              title: 'Loading...',
              author: '',
              image:
                  'https://marketplace.canva.com/EAFaQMYuZbo/1/0/1003w/canva-brown-rusty-mystery-novel-book-cover-hG1QhA7BiBU.jpg',
              price: 0,
              availability: '',
              category: null,
            ),
          ),
        );
      },
    );
  }
}
