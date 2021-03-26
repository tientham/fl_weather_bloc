import 'package:fl_weather_bloc/models/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:fl_weather_bloc/widgets/widgets.dart';

class CombinedWeatherTemperature extends StatelessWidget {
  final model.Weather weather;

  CombinedWeatherTemperature({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: WeatherConditions(condition: weather.condition),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Temperature(
                  temperature: weather.temp,
                  high: weather.maxTemp,
                  low: weather.minTemp),
            )
          ],
        ),
        Center(
          child: Text(
            weather.formattedCondition,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w200, color: Colors.white),
          ),
        )
      ],
    );
  }
}
