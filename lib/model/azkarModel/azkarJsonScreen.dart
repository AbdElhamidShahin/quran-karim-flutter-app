import 'dart:convert';

import 'package:flutter/services.dart';

import 'AzkarCategoryModel.dart';
import 'ItemAzkatr.dart';

Future<List<AzkarCategoryModel>> fetchAzkarCategoryFromJson() async {

  try {
    final String response = await rootBundle.loadString('assets/azkar.json');
    final List<dynamic> data = json.decode(response); // assuming it's a list

    return data.map((item) => AzkarCategoryModel.fromJson(item)).toList();
  } catch (e) {
    print("Error fetching data: $e");
    throw e;

  }
}
