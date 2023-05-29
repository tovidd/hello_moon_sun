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
import 'package:goodnightmoonhellosun/model/fade_away.dart';

import '../asset_path.dart';
import '../model/weather_data.dart';

class TodayDetailsWidget extends AnimatedWidget {
  final WeatherData weatherData;

  const TodayDetailsWidget({
    Key? key,
    required this.weatherData,
    required Animation<double> progress,
    required this.temperatureTween,
    required this.detailsTween,
  }) : super(key: key, listenable: progress);

  final Animatable<FadeAway> temperatureTween;
  final Animatable<FadeAway> detailsTween;

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final temperatureCurrentValue = temperatureTween.evaluate(_animation);
    final detailsCurrentValue = detailsTween.evaluate(_animation);

    final now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: temperatureCurrentValue.offset,
          child: Opacity(
            child: _temperature(context, now),
            opacity: temperatureCurrentValue.opacity,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Transform.translate(
          offset: detailsCurrentValue.offset,
          child: Opacity(
            child: _windAndWeatherText(context, now),
            opacity: detailsCurrentValue.opacity,
          ),
        ),
      ],
    );
  }

  Widget _temperature(BuildContext context, DateTime now) {
    return Text('${weatherData.temperature(now)}°', style: Theme.of(context).textTheme.headline2);
  }

  Widget _windAndWeatherText(BuildContext context, DateTime now) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Image.asset(AssetPath.weatherAsset(weatherData.weatherType(now)!), width: 24, height: 24),
        const SizedBox(
          width: 8,
        ),
        Text('${weatherData.weatherTypeText(now) ?? ''}', style: Theme.of(context).textTheme.headline6),
      ]),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.air_outlined),
          const SizedBox(
            width: 8,
          ),
          Text(
            '${weatherData.wind(now)} km/h',
            style: Theme.of(context).textTheme.subtitle1,
          )
        ],
      ),
    ]);
  }
}
