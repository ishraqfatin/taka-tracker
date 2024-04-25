

class ValidatorClass {
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Please enter an email";
    } else if (!RegExp('^[a-zA-Z0-9_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validateUserName(String? value) {
    if (value!.isEmpty) {
      return "Please enter your user name";
      //} else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(value)) {
    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%]').hasMatch(value)) {
      return "Please enter a valid user name";
    }
    return null;
  }


  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Please enter your password";
    } else if (value.length < 6) {
      return "Please enter a password length grater then 6 characters";
    }
    return null;
  }

  String? validateEmptyField(String? value) {
    if (value!.isEmpty) {
      return "Please enter the required input";
    }
    return null;
  }

  String? noValidationRequired(String? value) {
    return null;
  }
}
