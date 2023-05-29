/*
Copyright (c) 2022 Razeware LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
distribute, sublicense, create a derivative work, and/or sell copies of the
Software in any work that is designed, intended, or marketed for pedagogical or
instructional purposes related to programming, coding, application development,
or information technology.  Permission for such use, copying, modification,
merger, publication, distribution, sublicensing, creation of derivative works,
or sale is expressly withheld.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */

import 'dart:math';

import 'package:flutter/foundation.dart';

import 'weather_data_detail.dart';
import 'weather_type.dart';

class WeatherData {
  final DateTime date;
  final DateTime sunset;
  final DateTime sunrise;
  final List<WeatherDataDetail> details;

  WeatherData({
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.details,
  });

  double get maxTemperature => details
      .map((d) => d.temperature)
      .fold(0, (previousValue, element) => max(previousValue, element));

  double get minTemperature => details
      .map((d) => d.temperature)
      .fold(0, (previousValue, element) => min(previousValue, element));

  double get avgWind => (details.map((d) => d.wind).fold<double>(
              0, (previousValue, element) => previousValue + element) /
          max(details.length, 1)) // avoid division by 0 using max function
      .roundToDouble();

  double? temperature(DateTime time) => _closer(time)?.temperature;

  double? wind(DateTime time) => _closer(time)?.wind;

  WeatherType? weatherType(DateTime time) => _closer(time)?.weatherType;

  String? weatherTypeText(DateTime time) {
    final type = weatherType(time);
    if (type == null) return null;
    return describeEnum(type);
  }

  /// Returns the most present WeatherType in the [details]
  WeatherType get avgWeatherType {
    final weatherTypeCount = {
      for (var d in details)
        d.weatherType:
            details.where((e) => e.weatherType == d.weatherType).length
    };
    var maxNb = 0;
    WeatherType? maxKey;

    weatherTypeCount.forEach((k, v) {
      if (v > maxNb) {
        maxNb = v;
        maxKey = k;
      }
    });
    return maxKey!;
  }

  /// Returns the closest WeatherDataDetail of [time]
  WeatherDataDetail? _closer(DateTime time) {
    WeatherDataDetail? closer;
    for (var i = 0; i < details.length; i++) {
      if (i == 0) {
        closer = details[i];
      } else {
        if (closer!.time.difference(time) > details[i].time.difference(time)) {
          closer = details[i];
        }
      }
    }
    return closer;
  }
}
