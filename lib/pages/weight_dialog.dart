import 'package:flutter/material.dart';

import 'package:weighter/model/weight.dart';
import 'package:weighter/utils/snackbar_widget.dart';

class WeightDialog extends StatefulWidget {
  const WeightDialog({
    Key? key,
    this.weight,
  }) : super(key: key);
  final Weight? weight;

  @override
  State<WeightDialog> createState() => _WeightDialogState();
}

class _WeightDialogState extends State<WeightDialog> {
  late String _textToShow;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.weight?.weight.toString());
    _textToShow = widget.weight != null ? "Edit" : "Add";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("$_textToShow Weight"),
      content: TextFormField(
        keyboardType: TextInputType.number,
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: "Enter weight",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isEmpty) {
              SnackBarWidget.errorSnackBar(context, "Please fill the weight");
              return;
            }
            Navigator.of(context).pop(double.tryParse(_controller.text.trim()));
          },
          child: Text(
            "$_textToShow",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
