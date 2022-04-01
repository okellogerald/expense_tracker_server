import 'dart:math';

class Utils {
  static String generateOTP() {
    final random = Random();
    var otp = '';

    for (var i = 1; i <= 5; i++) {
      otp += random.nextInt(9).toString();
    }
    return otp;
  }
}
