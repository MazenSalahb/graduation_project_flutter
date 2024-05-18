import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/screens/widgets/app_bar.dart';
import 'package:graduation_project/screens/widgets/please_login_widget.dart';
import 'package:graduation_project/screens/widgets/single_book_widget.dart';
import 'package:graduation_project/services/apis/books_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

import '../../models/book_model.dart';
import '../../services/cubits/auth/auth_cubit.dart';
import '../widgets/primary_button.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarWidget(
          isHomeScreen: false,
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                      color: null,
                      text: 'Add book',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/add-book');
                      }),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<BookModel>>(
                    future: BooksServiceApi().getUserBooks(
                        userId: BlocProvider.of<AuthCubit>(context)
                            .userData!
                            .data!
                            .id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return UserBookList(
                        books: snapshot.data!,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const PleaseLoginWidget(message: "add books");
          }
        },
      ),
    );
  }
}

class UserBookList extends StatelessWidget {
  const UserBookList({
    super.key,
    required this.books,
  });
  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    return SignleBookWidget(books: books);
  }
}

class UserBookWidget extends StatelessWidget {
  const UserBookWidget({
    super.key,
    required this.book,
  });
  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                book.image!,
                height: 190,
                // width: 100
                // ,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    book.author!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Category: ${book.category}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'for: ${book.availability} ${book.availability == 'sale' ? '${book.price}EGP' : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    book.createdAt!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
