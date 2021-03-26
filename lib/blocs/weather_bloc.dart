import 'package:fl_weather_bloc/blocs/blocs.dart';
import 'package:fl_weather_bloc/models/models.dart';
import 'package:fl_weather_bloc/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({
    required this.weatherRepository
  }) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is WeatherRequested) {
      yield WeatherLoadInProgress();
      try {
        final Weather weather = await weatherRepository.getWeather(event.city);
        yield WeatherLoadSuccess(weather: weather);
      } catch (_) {
        yield WeatherLoadFailure();
      }
    }
  }

}