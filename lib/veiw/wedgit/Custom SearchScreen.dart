import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../veiw_model/helper/thems/TextStyle.dart';
import '../../veiw_model/helper/thems/color.dart';

class CustomSearchscreen extends StatelessWidget {
  const CustomSearchscreen({
    super.key,
    required this.text,
    required this.ontap,
  });
  final String text;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        textDirection:
            TextDirection.rtl,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp('[a-zA-Z0-9\u0600-\u06FF\s]'),
          ),
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          // '     ابحث عن الاذكار',
          hintStyle: selectedAyahStyle(),
          prefixIcon: const Icon(Icons.search, color: primaryDark),
          prefixIconConstraints: BoxConstraints(
            minWidth: 40,
          ),
        ),
        textAlign: TextAlign.right,
        onTap: ontap,
      ),
    );
  }
}
