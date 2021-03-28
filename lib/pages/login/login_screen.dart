import 'package:authentication_repository/authentication_repository.dart';
import 'package:fl_weather_bloc/blocs/blocs.dart';
import 'package:fl_weather_bloc/pages/login/views/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return LoginBloc(authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context));
          },
          child: LoginForm(),
        ),
      ),
    );
  }
}
