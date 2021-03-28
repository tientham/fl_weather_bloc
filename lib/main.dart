import 'package:authentication_repository/authentication_repository.dart';
import 'package:fl_weather_bloc/blocs/authentication/authentication_bloc.dart';
import 'package:fl_weather_bloc/blocs/blocs.dart';
import 'package:fl_weather_bloc/pages/base_screen.dart';
import 'package:fl_weather_bloc/repositories/repositories.dart';
import 'package:fl_weather_bloc/simple_bloc_observer.dart';
import 'package:fl_weather_bloc/pages/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:user_repository/user_repository.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(httpClient: http.Client()));

  final authenticationRepository = AuthenticationRepository();
  final userRepository = UserRepository();

  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
          BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
        ],
        child: MyApp(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
          weatherRepository: weatherRepository,
        )),
  );
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  MyApp(
      {Key? key,
      required this.weatherRepository,
      required this.authenticationRepository,
      required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return RepositoryProvider.value(
          value: authenticationRepository,
          child: BlocProvider(
            create: (_) => AuthenticationBloc(
                authenticationRepository: authenticationRepository,
                userRepository: userRepository),
            child: MaterialApp(
                title: 'Flutter Weather',
                theme: themeState.theme,
                home: BlocProvider(
                  create: (context) =>
                      WeatherBloc(weatherRepository: weatherRepository),
                  child: BaseScreen(),
                )),
          ),
        );
      },
    );
  }
}
