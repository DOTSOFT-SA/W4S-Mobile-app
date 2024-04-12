import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../globals/app_bar.dart';
import '../globals/side_menu.dart';
import '../helpers/colors.dart';
import '../helpers/sizer_utils.dart';
import '../providers/weather_provider.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  @override
  void initState() {
    initializeDateFormatting('el', null);
    callWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: LayoutBuilder(builder: (BuildContext, BoxConstraints) {
          screenWidth = BoxConstraints.maxWidth;
          screenHeight = BoxConstraints.maxHeight;
          return Scaffold(
              backgroundColor: Palette.mainGreyColor,
              resizeToAvoidBottomInset: false,
              body: SizedBox(
                child: Stack(
                  children: [
                    customAppBar(context, 'Περιβαλλοντικά Δεδομένα'),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          sideMenu(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                context
                                        .watch<WeatherProvider>()
                                        .weatherList
                                        .isEmpty
                                    ? const Expanded(
                                        child: SizedBox(
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: Palette.mainBlackColor,
                                          )),
                                        ),
                                      )
                                    : getWeatherGrid(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }

  void callWeather() {
    // Future.delayed(const Duration(milliseconds: 200)).then((value) =>
    //     Provider.of<WeatherProvider>(context, listen: false)
    //         .fetchWeather(context));
  }

  getWeatherGrid() {
    return Expanded(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Center(
                child: Wrap(
                    children:
                        Provider.of<WeatherProvider>(context, listen: false)
                            .weatherList
                            .map<Widget>((weather) => getWeatherCard(weather))
                            .toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getWeatherCard(WeatherModel weather) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(weather.timeStamp);
    DateFormat dateFormat = DateFormat.MMMMEEEEd('el');
    String time =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    if (date.hour >= 12) {
      time = '$time Μ.Μ';
    } else {
      time = '$time Π.Μ';
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02, vertical: screenHeight * 0.03),
      child: Container(
        width: screenWidth * 0.4,
        decoration: BoxDecoration(
            color: Palette.mainWhiteColor,
            borderRadius: BorderRadius.circular(4.sp),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              weather.timeStamp != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Text(
                            dateFormat.format(date),
                            style: TextStyle(
                                color: Palette.mainBlackColor,
                                fontSize: 5.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.032),
                          child: SizedBox(
                            child: Text(
                              time,
                              style: TextStyle(
                                  color: Palette.mainBlackColor,
                                  fontSize: 5.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              weather.weatherStatus.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.02),
                          child: SizedBox(
                            width: screenWidth * 0.08,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const SizedBox(),
                              errorWidget: (context, url, error) => SizedBox(
                                width: screenWidth * 0.1,
                              ),
                              imageUrl:
                                  'https://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Text(
                                  "Πρόγνωση: ${weather.weatherStatus}",
                                  style: TextStyle(
                                      color: Palette.mainBlackColor,
                                      fontSize: 5.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.005,
                              ),
                              SizedBox(
                                child: Text(
                                  "Θερμοκρασία: ${weather.temp.toStringAsFixed(0)}°C",
                                  style: TextStyle(
                                      color: Palette.mainBlackColor,
                                      fontSize: 5.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.005,
                              ),
                              SizedBox(
                                child: Text(
                                  "Υγρασία: ${weather.humidity}%",
                                  style: TextStyle(
                                      color: Palette.mainBlackColor,
                                      fontSize: 5.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
