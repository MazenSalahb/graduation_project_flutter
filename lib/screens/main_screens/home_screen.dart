import 'package:flutter/material.dart';
import 'package:graduation_project/screens/widgets/book_category.dart';
import 'package:graduation_project/screens/widgets/books_list.dart';
import 'package:graduation_project/screens/widgets/profile_appbar_widget.dart';
import 'package:graduation_project/services/apis/books_service.dart';
import '../widgets/categories_list.dart';
import '../widgets/features_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookDeal'),
        actions: const [
          ProfileAppBarWidget(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*START Search Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for a book, author, or genre",
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    // fillColor: Colors.grey[100],
                  ),
                ),
              ),
              //* END Search Section
              //*START Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Categories", style: TextStyle(fontSize: 16)),
                    TextButton(onPressed: () {}, child: const Text("See all"))
                  ],
                ),
              ),
              const CategoriesList(),
              const SizedBox(height: 10),
              //*End  Categories Section
              const FeaturesList(),
              // *END Feature Section
              // *Books Category
              const BooksCategory(
                title: "Books for sale",
              ),
              BooksList(
                books: BooksServiceApi().getBooks(),
              ),
              // *END Books Category
              // *Books Category
              const BooksCategory(
                title: "Books To Swap With",
              ),
              BooksList(
                books: BooksServiceApi().getBooksForSwap(),
              ),
              // *END Books Category
            ],
          ),
        ),
      ),
    );
  }
}
