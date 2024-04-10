import 'package:flutter/material.dart';

// import '../../constants/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isDisabled = false});
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // disabledBackgroundColor: paragraphColor,
        disabledForegroundColor: Colors.grey,
        minimumSize: const Size.fromHeight(55),
        side: const BorderSide(color: Colors.black),
        // backgroundColor: primaryRed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: Text(
        text,
        style: const TextStyle(
          // color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
