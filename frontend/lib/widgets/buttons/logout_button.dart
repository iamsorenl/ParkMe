import 'package:flutter/material.dart';

class ApplyChangesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ApplyChangesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // ignore: prefer_const_constructors
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
      ),
      child: const Text('Apply Changes'),
    );
  }
}
