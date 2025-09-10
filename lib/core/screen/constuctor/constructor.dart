import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String? initialSelectedCategory; // << add koro

  CategoryScreen({this.initialSelectedCategory, required initialSelectedOption}); // constructor

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialSelectedCategory; // << auto select hobe
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
