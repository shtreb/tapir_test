import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    required this.title,
    required this.description,
    this.imagePath,
    super.key,
  });

  final String? imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 21),
          Text(
            title,
            style: style,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Text(
            description,
            style: style,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (imagePath != null)
            Image.asset(
              imagePath!,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 64, color: Colors.grey),
                ),
              ),
            )
          else
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 64, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
