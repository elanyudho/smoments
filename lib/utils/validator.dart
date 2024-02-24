String? validateEmail(String value) {
  // Regular expression for email validation
  final emailRegex =
  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePassword(String value) {
  // Regular expression for password validation
  final passwordRegex =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*]).{8,}$');

  if (!passwordRegex.hasMatch(value)) {
    return 'Password must contain 1 uppercase letter, 1 lowercase letter, 1 number, 1 special character, and be at least 8 characters long';
  }
  return null;
}

String? validateConfirmPassword(String password, String confirmPassword) {
  if (password != confirmPassword) {
    return 'Passwords do not match';
  }
  return null;
}

String? validateName(String value) {
  if (value.length <= 3) {
    return 'Name is to short';
  }
  return null;
}