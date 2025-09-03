import 'package:flutter/material.dart';

class FeaturedOption extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  FeaturedOption({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // height boro korechi
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return InkWell(
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("${cat['name']} clicked")));
            },
            child: Container(
              width:
                  MediaQuery.of(context).size.width / 3, // ek line e boro card
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        color: Colors.grey.shade200,
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        size: 70, // icon boro korechi
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    cat["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, // text size boro korechi
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  Text(
                    "${cat["items"]} items",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "BUY NOW",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // button text boro korechi
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
