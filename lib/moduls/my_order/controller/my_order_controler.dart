import 'package:get/get.dart';

class MyOrderController extends GetxController {
  // Dummy list of orders
  var orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // Fake data load (API call এর জায়গায় আসল API দিবে)
  void fetchOrders() {
    orders.value = [
      {
        "id": "ORD123",
        "date": "2025-09-01",
        "status": "Delivered",
        "total": 2500,
      },
      {
        "id": "ORD124",
        "date": "2025-09-02",
        "status": "Pending",
        "total": 1800,
      },
    ];
  }
}
