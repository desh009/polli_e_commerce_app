import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  var selectedItem = "".obs;
  var cartCount = 0.obs;
  
  void updateCartCount(int count) {
    cartCount.value = count;
    print('🛒 Cart count updated to: $count');
  }
  
  void selectItem(String item) {
    selectedItem.value = item;
    print('📌 Selected item: $item');
  }
  
  void clearCart() {
    cartCount.value = 0;
    print('🗑️ Cart cleared');
  }
  
  @override
  void onInit() {
    super.onInit();
    print('🎯 DrawerControllerX initialized');
  }
}