import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wear4safe/helpers/colors.dart';
import 'package:wear4safe/helpers/sizer_utils.dart';
import 'package:wear4safe/providers/weather_provider.dart';

import '../helpers/assets.dart';

Widget customAppBar(context, title) {
  return Hero(
    tag: 'appBar',
    child: Material(
      child: SizedBox(
        child: Container(
            width: screenWidth,
            height: screenHeight * 0.12,
            decoration: BoxDecoration(
                color: Palette.mainWhiteColor,
                border: Border(
                    bottom: BorderSide(
                        color: Palette.mainBlackColor.withOpacity(0.25)))),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.08,
                          top: screenHeight * 0.02,
                          bottom: screenHeight * 0.02),
                      child: Image.asset(Assets.logo),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.05),
                    child: SizedBox(
                      child: Text(
                        '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            color: Palette.mainBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 6.sp),
                      ),
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: SizedBox(
                //     width: screenWidth * 0.16,
                //     child: Padding(
                //         padding: EdgeInsets.only(
                //             right: screenWidth * 0.04,
                //             top: screenHeight * 0.02,
                //             bottom: screenHeight * 0.02),
                //         child: Provider.of<WeatherProvider>(context,
                //                     listen: false)
                //                 .description
                //                 .isEmpty
                //             ? const SizedBox()
                //             : FittedBox(
                //                 fit: BoxFit.scaleDown,
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.end,
                //                   children: [
                //                     // Text(
                //                     //   'Καλαμαριά ',
                //                     //   style: TextStyle(
                //                     //       color: Palette.mainBlackColor,
                //                     //       fontWeight: FontWeight.bold,
                //                     //       fontSize: 4.sp),
                //                     // ),
                //                     SizedBox(
                //                       child: CachedNetworkImage(
                //                         placeholder: (context, url) =>
                //                             const SizedBox(),
                //                         errorWidget: (context, url, error) =>
                //                             SizedBox(
                //                           width: screenWidth * 0.02,
                //                           child: FittedBox(
                //                               fit: BoxFit.fill,
                //                               child: Image.asset(
                //                                   'assets/demo.png')),
                //                         ),
                //                         imageUrl:
                //                             'https://openweathermap.org/img/wn/${Provider.of<WeatherProvider>(context, listen: false).iconID}@2x.png',
                //                       ),
                //                     ),
                //                     Text(
                //                       Provider.of<WeatherProvider>(context,
                //                               listen: false)
                //                           .description,
                //                       style: TextStyle(
                //                           color: Palette.mainBlackColor,
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 4.sp),
                //                     ),
                //                     Provider.of<WeatherProvider>(context,
                //                                     listen: false)
                //                                 .temp !=
                //                             -1000.0
                //                         ? Text(
                //                             " ${Provider.of<WeatherProvider>(context, listen: false).temp.toStringAsFixed(0)} °C",
                //                             style: TextStyle(
                //                                 color: Palette.mainBlackColor,
                //                                 fontWeight: FontWeight.bold,
                //                                 fontSize: 4.sp),
                //                           )
                //                         : const SizedBox(),
                //                   ],
                //                 ),
                //               )),
                //   ),
                // ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.08,
                        top: screenHeight * 0.02,
                        bottom: screenHeight * 0.01),
                    child: SizedBox(
                      width: screenWidth * 0.5,
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Palette.mainBlackColor,
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    ),
  );
}
