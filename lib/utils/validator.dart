String? validateEmail(String value) {
  // Regular expression for email validation
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePassword(String value) {
  // Regular expression for password validation
  //For documentation
  //final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*]).{8,}$');

  if (value.length < 8 ) {
    return 'Password must at least 8 characters long';
  }
  return null;
}

String? validateConfirmPassword(String password, String confirmPassword) {
  if (password != confirmPassword) {
    return 'Passwords do not match';
  }
  return null;
}

String? validateLength(String value) {
  if (value.isEmpty) {
    return 'Value is too short';
  }
  return null;
}