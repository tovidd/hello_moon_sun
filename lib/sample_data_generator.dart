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

import 'model/weather_data.dart';
import 'model/weather_data_detail.dart';
import 'model/weather_type.dart';

class SampleDataGenerator {
  /// Get randomly generated weather data
  ///
  /// [todayWeatherType] is today's WeatherType and is not randomized for
  /// testing purposes
  static List<WeatherData> getData({WeatherType? todayWeatherType}) {
    final now = DateTime.now();
    final rand = Random();
    final data = <WeatherData>[
      WeatherData(
          date: now,
          sunrise: DateTime(now.year, now.month, now.day, 6, 50, 0),
          sunset: DateTime(now.year, now.month, now.day, 19, 20, 0),
          details: [
            for (int h = 0; h < 24; h++)
              WeatherDataDetail(
                  temperature: 18.0 +
                      (h > 12 ? 0.3 * (12 - h) : -0.3 * (12 - h)).round(),
                  wind: 11 + rand.nextInt(10) * (rand.nextBool() ? -1 : 1),
                  time: DateTime(now.year, now.month, now.day, h),
                  weatherType: todayWeatherType ?? WeatherType.Sunny)
          ]),
    ];

    for (var i = 0; i < 5; i++) {
      data.add(WeatherData(
          date: now.add(Duration(days: i + 1)),
          sunrise: DateTime(now.year, now.month, now.day, 6, 60, 0)
              .add(Duration(days: i + 1)),
          sunset: DateTime(now.year, now.month, now.day, 19, 20, 0)
              .add(Duration(days: i + 1)),
          details: [
            for (int h = 0; h < 24; h++)
              WeatherDataDetail(
                  temperature: 10.0 +
                      rand.nextInt(10) +
                      (h > 12 ? 0.3 * (12 - h) : -0.3 * (12 - h)).round(),
                  wind: 11 + rand.nextInt(10) * (rand.nextBool() ? -1 : 1),
                  time: DateTime(now.year, now.month, now.day, h)
                      .add(Duration(days: i + 1)),
                  weatherType: WeatherType
                      .values[rand.nextInt(WeatherType.values.length)])
          ]));
    }
    return data;
  }
}
