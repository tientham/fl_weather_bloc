import 'package:fl_weather_bloc/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_weather_bloc/widgets/widgets.dart';

class Weather extends StatelessWidget {
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
              })
        ],
      ),
      body: Center(
        child: BlocBuilder<WeatherBloc, WeatherState>(
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

              return ListView(
                children: [
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
