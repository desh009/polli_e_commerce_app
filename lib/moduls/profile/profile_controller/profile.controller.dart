import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User Info (dummy data, পরে API থেকে আসবে)
  var name = "Arian".obs;
  var email = "arian@example.com".obs;
  var phone = "+880 1234-567890".obs;
  var image = "assets/images/profile.png".obs;

  // Update name (example)
  void updateName(String newName) {
    name.value = newName;
  }

  // Update email
  void updateEmail(String newEmail) {
    email.value = newEmail;
  }

  // Update phone
  void updatePhone(String newPhone) {
    phone.value = newPhone;
  }
}
