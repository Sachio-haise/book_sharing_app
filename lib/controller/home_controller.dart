import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxString token = ''.obs;
  Future<void> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? '';
    authenticate();
  }

  void authenticate() {
    if (token.value.isNotEmpty) {
      Get.toNamed('/book_lists');
    } else {
      Get.offAllNamed('/auth');
    }
  }
  Future<dynamic> navigateToBookCreatePage() async{
    final result = await Get.toNamed('/upload');
    return result;
  }
}
