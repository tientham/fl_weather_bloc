import 'package:formz/formz.dart';

enum PasswordValidatorError {empty}

class Password extends FormzInput<String, PasswordValidatorError> {
  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidatorError? validator(String? value) {
    return value?.isNotEmpty == true ? null : PasswordValidatorError.empty;
  }
}