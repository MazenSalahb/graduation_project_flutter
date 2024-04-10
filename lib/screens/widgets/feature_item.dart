import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    super.key,
    required this.title,
    required this.image,
    // required this.bgColor,
    // required this.textColor,
  });
  final String title;
  final String image;
  // final Color bgColor;
  // final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          // color: bgColor,
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          )),
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          SvgPicture.asset(
            image,
            width: 100,
          )
        ],
      ),
    );
  }
}
