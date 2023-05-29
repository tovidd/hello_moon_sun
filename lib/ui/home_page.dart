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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodnightmoonhellosun/model/fade_away.dart';
import 'package:intl/intl.dart';

import '../model/weather_data.dart';
import '../model/weather_type.dart';
import '../sample_data_generator.dart';
import 'bottom_card.dart';
import 'cloudy_widget.dart';
import 'moon_widget.dart';
import 'sun_widget.dart';
import 'today_details_widget.dart';

class HomePage extends StatefulWidget {
  /// Knowing the [width] of the widget will allow us to make the UI responsive
  final double width;

  const HomePage({Key? key, this.width = 500}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _isDayTheme = true;
  List<WeatherData> weatherData = SampleDataGenerator.getData(
    todayWeatherType: WeatherType.Snowy,
  );

  // These DateFormat come from the [intl] package
  DateFormat hourFormat = DateFormat.Hm();
  DateFormat dayFormat = DateFormat.EEEE();

  late ThemeData _dayTheme;
  late ThemeData _nightTheme;

  late AnimationController _animationController;
  late Animation<Offset> _sunMoveAnim;
  late Animation<Offset> _moonMoveAnim;
  late Animation<ThemeData> _themeAnim;

  late TweenSequence<FadeAway> _temperatureAnim;
  late TweenSequence<FadeAway> _weatherDetailsAnim;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dayTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.cyan,
        brightness: Brightness.light,
        backgroundColor: const Color(0xFFB8FBFF),
      ),
    ).copyWith(
        // We use the textTheme of the base Material theme by using
        // Theme.of(context).textTheme. Properties like
        // Theme.of(context).textTheme.headline1 will be set according to
        // Material Design.
        // See the docs: https://api.flutter.dev/flutter/material/TextTheme-class.html
        textTheme: Theme.of(context).textTheme.apply(
              // When on light theme, we set the text color to black
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ));
    _nightTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.cyan,
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF070429),
      ),
    ).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              // When on dark theme, we set the text color to white
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ));

    _isDayTheme = Theme.of(context).brightness == Brightness.light;
    _initThemeAnims(dayToNight: _isDayTheme);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeAnim,
      child: _content(),
      builder: (context, child) {
        return Theme(
          data: _themeAnim.value,
          child: Builder(
            builder: (BuildContext otherContext) {
              return child!;
            },
          ),
        );
      },
    );
  }

  void _initThemeAnims({required bool dayToNight}) {
    final disappearAnim = Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset(-widget.width, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.0,
        0.3,
        curve: Curves.ease,
      ),
    ));

    final appearAnim = Tween<Offset>(
      begin: Offset(widget.width, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.7,
        1.0,
        curve: Curves.ease,
      ),
    ));

    _themeAnim = (dayToNight
            ? ThemeDataTween(begin: _dayTheme, end: _nightTheme)
            : ThemeDataTween(begin: _nightTheme, end: _dayTheme))
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.3,
          0.7,
          curve: Curves.easeIn,
        ),
      ),
    );

    _temperatureAnim = TweenSequence<FadeAway>([
      TweenSequenceItem(
        tween: Tween<FadeAway>(
          begin: const FadeAway(Offset(0, 0), 1.0),
          end: const FadeAway(Offset(-100, 0), 0.0),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: ConstantTween<FadeAway>(const FadeAway(Offset(-100, 0), 0.0)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<FadeAway>(
          begin: const FadeAway(Offset(-100, 0), 0.0),
          end: const FadeAway(Offset(0, 0), 1.0),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]);

    _weatherDetailsAnim = TweenSequence<FadeAway>([
      TweenSequenceItem(
        tween: Tween<FadeAway>(
          begin: const FadeAway(Offset(0, 0), 1.0),
          end: const FadeAway(Offset(100, 0), 0.0),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: ConstantTween<FadeAway>(const FadeAway(Offset(100, 0), 0.0)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<FadeAway>(
          begin: const FadeAway(Offset(100, 0), 0.0),
          end: const FadeAway(Offset(0, 0), 1.0),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]);

    _sunMoveAnim = dayToNight ? disappearAnim : appearAnim;
    _moonMoveAnim = dayToNight ? appearAnim : disappearAnim;
  }

  Widget _content() {
    final todayWeather = weatherData.first;
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dayFormat.format(now)),
                  Text(hourFormat.format(now)),
                ],
              ),
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: 40,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            child: _sunOrMoon(),
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        if (todayWeather.avgWeatherType != WeatherType.Sunny)
                          Positioned.fill(
                            child: Align(
                              child: CloudyWidget(
                                weatherType: todayWeather.avgWeatherType,
                              ),
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        Positioned.fill(
                          child: Align(
                            child: Padding(
                              child: _animationButton(),
                              padding: const EdgeInsets.only(left: 20),
                            ),
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TodayDetailsWidget(
              weatherData: todayWeather,
              progress: _animationController,
              temperatureTween: _temperatureAnim,
              detailsTween: _weatherDetailsAnim,
            ),
            BottomCard(
              weatherData: weatherData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sunOrMoon() {
    if (_isDayTheme) {
      return SunWidget(listenable: _sunMoveAnim);
    } else {
      return MoonWidget(listenable: _moonMoveAnim);
    }
  }

  Widget _animationButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.play_arrow),
      onPressed: () {
        _switchTheme();
      },
      label: const Text('SWITCH THEMES'),
    );
  }

  void _switchTheme() {
    // 1
    if (_isDayTheme) {
      _animationController.removeListener(_nightToDayAnimListener);
      _animationController.addListener(_dayToNightAnimListener);
    } else {
      _animationController.removeListener(_dayToNightAnimListener);
      _animationController.addListener(_nightToDayAnimListener);
    }
    // 2
    _initThemeAnims(dayToNight: _isDayTheme);
    // 3
    setState(() {
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _dayToNightAnimListener() {
    _animListener(true);
  }

  void _nightToDayAnimListener() {
    _animListener(false);
  }

  void _animListener(bool dayToNight) {
    // 4
    if ((_isDayTheme && dayToNight || !_isDayTheme && !dayToNight) && _animationController.value >= 0.5) {
      setState(() {
        _isDayTheme = !dayToNight;
      });
    }
  }
}
