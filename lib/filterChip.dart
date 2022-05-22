import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  const FilterChips({Key? key, required List<String> categories, required this.onSelectionChanged})
      : _categories = categories,
        super(key: key);


  final Function(List<String>) onSelectionChanged; // +added
  final List<String> _categories;
  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  List<String> selectedChoices = [];
  bool isSelected = false;

  _buildChoiceList() {
    List<Widget> choices = [];
    widget._categories.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices); // +added
            });
          },
        ),
      ));
    });
    return choices;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
