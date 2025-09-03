import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polli_e_commerce_app/moduls/my_wishlist/controller/my_wish_list_contoller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "My Wishlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.wishlist.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border,
                    size: screenWidth * 0.2, color: Colors.grey),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "No items in your wishlist",
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Colors.grey),
                ),
              ],
            ),
          );
        }

      

        return ListView.builder(
          padding: EdgeInsets.all(screenWidth * 0.03),
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            final item = controller.wishlist[index];

            final image = (item["image"] != null && item["image"] != "")
                ? Image.network(
                    item["image"],
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported,
                          color: Colors.grey, size: screenWidth * 0.08),
                    ),
                  )
                : Container(
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey, size: screenWidth * 0.08),
                  );

            return Card(
              margin: EdgeInsets.only(bottom: screenHeight * 0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: image,
                ),
                title: Text(
                  item["name"],
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "৳${item["price"]}",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[700],
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeFromWishlist(item["id"]),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
