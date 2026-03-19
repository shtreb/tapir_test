import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  const GenderSelector({required this.selected, required this.onChanged, super.key});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  State<StatefulWidget> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller.index = widget.selected == 'male' ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Муж', 'Жен'];
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 36,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0x7676801F)),
        child: TabBar(
          controller: _controller,
          indicator: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
          indicatorPadding: const EdgeInsets.symmetric(vertical: 2),
          labelPadding: const EdgeInsets.symmetric(horizontal: 2),
          onTap: (index) {
            widget.onChanged(index == 0 ? 'male' : 'female');
          },
          tabs: tabs
              .map(
                (item) => Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(item, style: TextStyle(fontSize: 13.33, fontWeight: FontWeight.w600))],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
