import 'package:authentication_repository/authentication_repository.dart';
import 'package:fl_weather_bloc/blocs/blocs.dart';
import 'package:fl_weather_bloc/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final AuthenticationRepository _authenticationRepository;

  LoginBloc({required AuthenticationRepository authenticationRepository}): _authenticationRepository = authenticationRepository,
  super(const LoginState());


  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapUsernameChangedToState(LoginUsernameChanged event, LoginState state) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, username])
    );
  }

  LoginState _mapPasswordChangedToState(LoginPasswordChanged event, LoginState state) {
    final password = Password.dirty(event.password);
    return state.copyWith(
        password: password,
        status: Formz.validate([password, state.username])
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(LoginSubmitted event, LoginState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository.logIn(username: state.username.value, password: state.password.value);
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}