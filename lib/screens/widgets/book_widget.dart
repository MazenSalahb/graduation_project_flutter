import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:graduation_project/models/book_model.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({
    super.key,
    required this.book,
  });
  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        ScaleEffect(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 200),
        ),
        FadeEffect(
          duration: Duration(milliseconds: 200),
        ),
      ],
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        width: 100,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/book-details',
              arguments: book,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add your book item widgets here
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  child: Image.network(
                    book.image!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                flex: 1,
                child: Text(
                  book.title!,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    '${book.reviewsAvgRating != null ? book.reviewsAvgRating!.toStringAsFixed(2) : '0'} ⭐',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  Text(book.availability == 'sale' ? '${book.price}EGP' : '🔄',
                      style: const TextStyle(fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
