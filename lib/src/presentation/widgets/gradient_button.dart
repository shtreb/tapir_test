import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;


  const GradientButton({
    required this.text,
    required this.onPressed,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return SizedBox(
      width: width ?? double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(
                  colors: <Color>[Color(0xFFB7D800), Color(0xFF708902)],
                  stops: <double>[0.1299, 1.0],
                  begin: Alignment(-0.968, -0.250),
                  end: Alignment(0.968, 0.250),
                )
              : null,
          color: isEnabled ? null : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(50),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isEnabled ? Colors.white : const Color(0xFF757575),
            ),
          ),
        ),
      ),
    );
  }
}
