import 'dart:async';

import 'package:fl_weather_bloc/blocs/authentication/authentication_bloc.dart';
import 'package:fl_weather_bloc/blocs/authentication/authentication_event.dart';
import 'package:fl_weather_bloc/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_weather_bloc/widgets/widgets.dart';

class WeatherScreen extends StatefulWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => WeatherScreen());
  }

  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final city = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CitySelection()));

                if (city != null) {
                  BlocProvider.of<WeatherBloc>(context).add(WeatherRequested(city: city));
                }
              }),
          IconButton(icon: Icon(Icons.settings), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
          }),
          IconButton(icon: Icon(Icons.logout), onPressed: () {
            context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
          }),
        ],
      ),
      body: Center(
        child: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherLoadSuccess) {
              BlocProvider.of<ThemeBloc>(context).add(WeatherChanged(condition: state.weather.condition));
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            if (state is WeatherInitial) {
              return Center(
                child: Text('Please Select a Location'),
              );
            }

            if (state is WeatherLoadInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WeatherLoadSuccess) {
              final weather = state.weather;

              return BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  return GradientContainer(
                    color: themeState.color,
                    child: RefreshIndicator(
                      onRefresh: () {
                        BlocProvider.of<WeatherBloc>(context).add(WeatherRefreshRequested(city: state.weather.location));
                        return _refreshCompleter.future;
                      },
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: Builder(
                              builder: (context) {
                                final userId = context.select((AuthenticationBloc authenticationBloc) => authenticationBloc.state.user.id);
                                return Text('UserID: $userId');
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child: Center(
                              child: Location(location: weather.location),
                            ),
                          ),
                          Center(
                            child: LastUpdated(dateTime: weather.lastUpdated),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50.0),
                            child: Center(
                              child: CombinedWeatherTemperature(weather: weather),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is WeatherLoadFailure) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }

            throw Exception('Unknown State');
          },
        ),
      ),
    );
  }
}
