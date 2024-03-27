// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/constants/colors.dart';
import 'package:graduation_project/models/book_model.dart';
import 'package:graduation_project/models/review_model.dart';
import 'package:graduation_project/services/apis/reviews_service.dart';
import 'package:graduation_project/services/cubits/auth/auth_cubit.dart';
import 'package:graduation_project/services/cubits/auth/auth_state.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  Future<void> _dialogBuilder(BuildContext context, int bookId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ReviewFormDialog(
          bookId: bookId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)!.settings.arguments) as BookModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookDetailsWidget(arguments: arguments),
              const SizedBox(height: 20),
              //* Book Description
              Text(
                'Description: ${arguments.description!}',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                  color: paragraphColor,
                ),
              ),
              //* END Book Description
              const SizedBox(height: 20),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return Column(
                      children: [
                        ContactButtons(
                          sellerId: arguments.userId!,
                          bookId: arguments.id!,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _dialogBuilder(context, arguments.id!.toInt());
                          },
                          child: const Text("Submit a review"),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: const Text('Login to contact the owner'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text('Reviews', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              //* Reviews
              FutureBuilder<List<ReviewModel>>(
                  future: ReviewsService().getReviews(arguments.id!.toInt()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      return snapshot.data!.isEmpty
                          ? const Text('No reviews')
                          : ReviewsList(reviews: snapshot.data!);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewFormDialog extends StatefulWidget {
  const ReviewFormDialog({
    super.key,
    required this.bookId,
  });
  final int bookId;

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  TextEditingController reviewController = TextEditingController();
  double rating = 3.5;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Submit a review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Rate the book'),
          RatingBar.builder(
            initialRating: 3.5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                this.rating = rating;
              });
              log(rating.toString());
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: reviewController,
            decoration: const InputDecoration(
              hintText: 'Write your review here',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Submit'),
          onPressed: () async {
            bool success = await ReviewsService().addReview(
              bookId: widget.bookId,
              rating: rating,
              review: reviewController.text,
              token: BlocProvider.of<AuthCubit>(context).userData!.token!,
            );
            if (success) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review submitted successfully'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to submit review'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class ReviewsList extends StatelessWidget {
  const ReviewsList({
    super.key,
    required this.reviews,
  });
  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return ReviewWidget(
          review: reviews[index],
        );
      },
    );
  }
}

class ContactButtons extends StatelessWidget {
  const ContactButtons({
    super.key,
    required this.sellerId,
    required this.bookId,
  });
  final num sellerId;
  final num bookId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/chat', arguments: {
                'sellerId': sellerId,
                'buyerId':
                    BlocProvider.of<AuthCubit>(context).userData!.data!.id,
                'bookId': bookId,
              });
            },
            child: const Text(
              'Chat',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('Call'),
          ),
        ),
      ],
    );
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
    required this.review,
  });
  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.network(
              review.user!.profilePicture!,
              width: 40,
            ),
            const SizedBox(width: 20),
            Text(review.user!.name!),
            const Spacer(),
            Builder(
              builder: (context) {
                if (review.userId ==
                    BlocProvider.of<AuthCubit>(context).userData?.data?.id) {
                  return IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool success = await ReviewsService().deleteReview(
                        reviewId: review.id!.toInt(),
                        token: BlocProvider.of<AuthCubit>(context)
                            .userData!
                            .token!,
                      );
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Review deleted successfully'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete review'),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          review.reviewText ?? '',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text('Rating: ${review.rating}'),
            const SizedBox(width: 10),
            RatingBarIndicator(
                rating: review.rating!.toDouble(),
                itemBuilder: (context, index) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemSize: 20),
            const SizedBox(width: 20),
            Text('Date: ${review.createdAt}'),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class BookDetailsWidget extends StatelessWidget {
  const BookDetailsWidget({
    super.key,
    required this.arguments,
  });

  final BookModel arguments;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            arguments.image!,
            height: 200,
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(arguments.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 20)),
              Text(
                arguments.author!,
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Text(
                'Category: ${arguments.category!.name!}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                  'for ${arguments.availability!}: ${arguments.availability == "sale" ? "${arguments.price}EGP" : "🔄"}'),
              const SizedBox(height: 4),
              Text('Posted by: ${arguments.user!.name}',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(
                  'Reviews: ${arguments.reviewsAvgRating != null ? '${arguments.reviewsAvgRating!.toStringAsFixed(2)} ⭐' : 'no reviews'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
