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

import 'package:flutter/material.dart';
import '../asset_path.dart';

import '../model/weather_type.dart';

class CloudyWidget extends StatelessWidget {
  final WeatherType weatherType;

  const CloudyWidget({Key? key, required this.weatherType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder widget is handy to get the child's constraints
    return LayoutBuilder(builder: (context, constraints) {
      final minSize = min(constraints.maxWidth, constraints.maxHeight);
      // We use this minSize to make our UI more responsive

      return Stack(children: [
        Positioned.fill(
          child: Center(
            child: Padding(
                child: Image.asset(
                  AssetPath.cloud3,
                  width: minSize / 3.5,
                  height: minSize / 3.5,
                ),
                padding:
                    EdgeInsets.only(bottom: minSize / 10, right: minSize / 2)),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Padding(
                child: Image.asset(
                  AssetPath.cloud2,
                  width: minSize / 3,
                  height: minSize / 3,
                ),
                padding:
                    EdgeInsets.only(bottom: minSize / 6, left: minSize / 2)),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Image.asset(
              AssetPath.cloud1,
              width: minSize / 2,
              height: minSize / 2,
            ),
          ),
        ),
      ]);
    });
  }
}
