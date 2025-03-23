///{@template StringUtils}
/// Utility class for string operations and validations
///{@endtemplate}
final class StringUtils {
  ///Capitalizes the first letter of a string
  static String capitalize(String text) =>
      text[0].toUpperCase() + text.substring(1);

  ///Checks if a string is a valid email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  ///Checks if a string is a valid phone number
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phone);
  }

  ///Checks if a string is a valid phone code (1 to 3 digits)
  static bool isValidPhoneCode(String phoneCode) {
    final phoneCodeRegex = RegExp(r'^\d{1,3}$');
    return phoneCodeRegex.hasMatch(phoneCode);
  }
}
