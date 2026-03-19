import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.count,
    required this.current,
    super.key,
  });

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        count,
        (int index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == current ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == current
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
