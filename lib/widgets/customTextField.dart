import 'package:flutter/material.dart';

class CustomTextField {
  final String title;
  final String placeholder;
  final bool ispass;
  String err;
  String _value = "";
  final IconData prefixIcon; // Add the prefixIcon property

  CustomTextField({
    this.title = "",
    this.placeholder = "",
    this.ispass = false,
    this.err = "please complete",
    this.prefixIcon = Icons.person, // Default prefix icon is Icons.person
  });
  TextEditingController controller = TextEditingController();

  TextFormField textFormField() {
    return TextFormField(
      onChanged: (e) {
        _value = e;
      },
      validator: (e) => e!.isEmpty ? err : null,
      obscureText: ispass,
      decoration: InputDecoration(
        labelText: title,
        hintText: placeholder,
        prefixIcon: Icon(prefixIcon), // Use the provided prefixIcon here
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
      ),
    );
  }

  String get value {
    return _value;
  }
}
