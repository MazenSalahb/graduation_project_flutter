import 'package:flutter/material.dart';

class BooksCategory extends StatelessWidget {
  const BooksCategory({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text("See all"),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
