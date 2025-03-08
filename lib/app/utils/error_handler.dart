import 'package:get/get.dart';

class ErrorHandler {
  static void handleError(dynamic error, {String prefix = 'Error'}) {
    final message = _getErrorMessage(error);
    Get.snackbar(prefix, message);
  }

  static String _getErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error is Exception) return error.toString();
    return 'An unexpected error occurred';
  }
}
