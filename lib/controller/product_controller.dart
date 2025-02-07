import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_app/models/category_model.dart';

class ProductController extends GetxController {
  var subcat = <String>[].obs; // Reactive list for subcategories

  Future<void> getSubCategories(String title) async {
    try {
      // Load and decode JSON
      var data = await rootBundle.loadString("lib/services/category_model.json");
      var decoded = categoryModelFromJson(data);

      // Clear existing subcategories to avoid duplicates
      subcat.clear();

      // Find the category by title and add its subcategories
      var matchedCategory = decoded.categories.firstWhereOrNull((e) => e.name == title);
      if (matchedCategory != null) {
        subcat.addAll(matchedCategory.subcategory);
      }
    } catch (e) {
      print("Error loading categories: $e");
    }
  }
}
