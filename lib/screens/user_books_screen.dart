// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/screens/widgets/primary_button.dart';
import 'package:graduation_project/services/apis/books_service.dart';

import '../services/cubits/auth/auth_cubit.dart';

class UserBooksScreen extends StatelessWidget {
  const UserBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Books'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            PrimaryButton(
                text: 'Add book',
                onPressed: () {
                  Navigator.of(context).pushNamed('/add-book');
                }),
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
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No books found'),
                      );
                    }
                    final books = snapshot.data;
                    return ListView.builder(
                      itemCount: books!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(books[index].title!),
                          subtitle: Text(books[index].author!),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              // delete book
                              bool isDeleted =
                                  await BooksServiceApi().deleteBook(
                                bookId: books[index].id!,
                                token: BlocProvider.of<AuthCubit>(context)
                                    .userData!
                                    .token!,
                              );
                              if (isDeleted) {
                                await FirebaseStorage.instance
                                    .refFromURL(books[index].image!)
                                    .delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Book deleted successfully'),
                                  ),
                                );
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error deleting book'),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
