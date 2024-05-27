String? passwordValidator(password) {
  if (password == null) {
    return 'filed required';
  } else {
    if (password.length < 6) {
      return 'Password must be more than 6 characters';
    } else {
      return null;
    }
  }
}

String? numbervalidator(num) {
  if (num == null || num.isEmpty) {
    return 'filed required';
  } else {
    if (!RegExp(r'^\d+$').hasMatch(num)) {
      return 'Only numeric values are allowed';
    } else if (!RegExp(r'^(07|06|05)\d{8}$').hasMatch(num)) {
      return 'Number must start with 07 ,or 06,or 05 and be 10 digits long';
    } else {
      return null;
    }
  }
}

String? emailValidator(email) {
  if (email == null) {
    return 'filed required';
  } else {
    if (email.length < 5 || !email.contains('@')) {
      return 'invalid email';
    } else {
      return null;
    }
  }
}

String? ageValidator(ages) {
  if (ages == null || ages.isEmpty) {
    return 'Please enter your age';
  }
  final age = int.tryParse(ages);
  if (age == null) {
    return 'Please enter a valid age';
  } else if (age < 17) {
    return 'You must be at least 18 years old';
  } else {
    return null;
  }
}

String? nameValidator(name) {
  if (name == null || name.isEmpty) {
    return 'filed required';
  } else {
    if (name.length < 3) {
      return 'invalid name';
    } else if (RegExp(r'^\d+$').hasMatch(name)) {
      return 'Only alphabetic values are allowed';
    } else {
      return null;
    }
  }
}

String? yearsValidator(years) {
  if (years == null || years.isEmpty) {
    return 'filed required';
  } else if (!RegExp(r'^\d+$').hasMatch(years) || years.length > 4) {
    return 'Please enter a valid year';
  } else {
    return null;
  }
}

String? amountValidator(amount) {
  if (amount == null || amount.isEmpty) {
    return 'filed required';
  } else if (!RegExp(r'^\d+$').hasMatch(amount)) {
    return 'Only numeric values are allowed';
  } else {
    return null;
  }
}

String? deadlineValidator(deadlines) {
  if (deadlines == null || deadlines.isEmpty) {
    return 'Please enter the deadline(format:YYYY-MM-DD)';
  }
  DateTime? deadline = DateTime.tryParse(deadlines);
  if (deadline == null) {
    return 'Please enter the deadline(format:YYYY-MM-DD)';
  } else if (deadline.isBefore(DateTime.now())) {
    return 'the deadline cannot in the past';
  } else {
    return null;
  }
}
