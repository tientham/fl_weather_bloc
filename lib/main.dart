import 'package:fl_weather_bloc/blocs/blocs.dart';
import 'package:fl_weather_bloc/repositories/repositories.dart';
import 'package:fl_weather_bloc/simple_bloc_observer.dart';
import 'package:fl_weather_bloc/widgets/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = SimpleBlocObserver();

  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(httpClient: http.Client()));

  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
          BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
        ],
        child: MyApp(
          weatherRepository: weatherRepository,
        )),
  );
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;

  MyApp({required this.weatherRepository});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
            title: 'Flutter Weather',
            theme: themeState.theme,
            home: BlocProvider(
              create: (context) =>
                  WeatherBloc(weatherRepository: weatherRepository),
              child: Weather(),
            ));
      },
    );
  }
}
