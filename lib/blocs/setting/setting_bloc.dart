import 'package:fl_weather_bloc/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(): super(SettingsState(temperatureUnits: TemperatureUnits.celsius));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is TemperatureUnitsToggled) {
      yield SettingsState(temperatureUnits: state.temperatureUnits == TemperatureUnits.celsius ?
      TemperatureUnits.fahrenheit : TemperatureUnits.celsius);
    }
  }
}