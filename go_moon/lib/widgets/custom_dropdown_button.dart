import 'package:flutter/material.dart';

class CustomDropdownButtonClass extends StatelessWidget {
  List<String> values;
  double width;

  CustomDropdownButtonClass({required this.values, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(53, 53, 53, 1),
          borderRadius: BorderRadius.circular(
            10,
          )),
      child: DropdownButton(
        underline: Container(),
        value: values.first,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        onChanged: (_) {},
        items: values.map(
          (e) {
            return DropdownMenuItem(
              child: Text(e),
              value: e,
            );
          },
        ).toList(),
        dropdownColor: const Color.fromRGBO(
          53,
          53,
          53,
          1,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
