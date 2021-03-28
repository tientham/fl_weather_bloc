import 'package:formz/formz.dart';

enum UserNameValidatorError { empty }

class Username extends FormzInput<String, UserNameValidatorError> {
  const Username.pure() : super.pure('');

  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  UserNameValidatorError? validator(String? value) {
    return value?.isNotEmpty == true ? null : UserNameValidatorError.empty;
  }
}
