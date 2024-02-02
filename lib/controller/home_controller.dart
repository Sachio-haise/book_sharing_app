import 'package:book_sharing_app/controller/book_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_sharing_app/controller/auth_controller.dart';

class HomeController extends GetxController {
  RxString token = ''.obs;
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());
  final BookController _bookController = Get.put(BookController());

  Future<void> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? '';
    authenticate();
  }

  void authenticate() async {
    if (token.value.isNotEmpty) {
      await _authenticationController.fetchUserData();
      await _bookController.loadBooks(load: true);
      print("authentication ${_authenticationController.user?.name}");
      Get.toNamed('/');
    } else {
      Get.offAllNamed('/auth');
    }
  }

  Future<dynamic> navigateToBookCreatePage() async{
    final result = await Get.toNamed('/upload');
    return result;
  }
}
