import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/screens/books_screen.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';

class SignleBookWidget extends StatelessWidget {
  const SignleBookWidget({
    super.key,
    required this.books,
  });
  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: books[index].userId ==
                  BlocProvider.of<AuthCubit>(context).userData!.data!.id
              ? () {
                  Navigator.of(context).pushNamed(
                    '/edit-book',
                    arguments: books[index],
                  );
                }
              : () {
                  Navigator.of(context)
                      .pushNamed('/book-details', arguments: books[index]);
                },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9B8B8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: const Offset(6, 3),
                        ),
                      ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          books[index].image!,
                          height: 150,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Title
                Text(
                  books[index].title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Author
                Text(
                  books[index].author!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BookChips(
                      text: Text(
                        "⭐ ${books[index].reviewsAvgRating == null ? 0 : books[index].reviewsAvgRating!.toStringAsFixed(1)}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: const Color(0xFFFF8888),
                    ),
                    BookChips(
                      text: Text(
                        books[index].availability == "swap"
                            ? '🤝'
                            : 'EGP ${books[index].price}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    const BookChips(
                      text: Icon(
                        Icons.bookmark,
                        color: Color(0xFF414143),
                      ),
                      color: Color(0xFFFF8888),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
