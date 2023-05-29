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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../asset_path.dart';
import '../model/weather_data.dart';

class BottomCard extends StatelessWidget {
  final List<WeatherData> weatherData;

  const BottomCard({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todayWeather = weatherData.first;
    final textTheme = Theme.of(context).textTheme;
    final hourFormat = DateFormat.Hm();
    final dayFormat = DateFormat.EEEE();

    return Card(
      child: Padding(
          child: Column(
            children: [
              Text(
                'TODAY',
                style: textTheme.subtitle2,
              ),
              Padding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${todayWeather.maxTemperature}°',
                          style: textTheme.headline6,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${todayWeather.minTemperature}°',
                          style: textTheme.subtitle2,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.air_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('${todayWeather.avgWind} km/h')
                      ],
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              SizedBox(
                child: Row(children: [
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: todayWeather.details.length,
                          itemBuilder: (buildContext, index) {
                            final weatherDetail = todayWeather.details[index];
                            return Padding(
                                child: Column(
                                  children: [
                                    Text(hourFormat.format(weatherDetail.time)),
                                    Image.asset(
                                      AssetPath.weatherAsset(
                                          weatherDetail.weatherType),
                                      width: 32,
                                      height: 32,
                                    ),
                                    Text('${weatherDetail.temperature}°'),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.air_outlined,
                                          size: 16,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '${weatherDetail.wind} km/h',
                                          style: textTheme.caption,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.only(right: 20));
                          }))
                ]),
                height: 100,
              ),
              Text(
                '5 NEXT DAYS',
                style: textTheme.subtitle2,
              ),
              SizedBox(
                child: Row(children: [
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weatherData.length - 1, // skip today
                          itemBuilder: (buildContext, index) {
                            // index + 1 since weatherData[0] is today
                            final weatherDay = weatherData[index + 1];
                            return Padding(
                              child: Column(
                                children: [
                                  Text(dayFormat.format(weatherDay.date)),
                                  Image.asset(
                                    AssetPath.weatherAsset(
                                        weatherDay.avgWeatherType),
                                    width: 32,
                                    height: 32,
                                  ),
                                  Row(children: [
                                    Text('${weatherDay.maxTemperature}°'),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text('${weatherDay.minTemperature}°')
                                  ]),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.air_outlined,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '${weatherDay.avgWind} km/h',
                                        style: textTheme.caption,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(right: 20),
                            );
                          }))
                ]),
                height: 100,
              ),
            ],
          ),
          padding: const EdgeInsets.all(10)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
