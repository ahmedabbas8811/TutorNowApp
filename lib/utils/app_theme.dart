import 'package:flutter/material.dart';

ThemeData appTheme() {
  const Color primaryColor = Color(0xFF87E64B);  
  const Color unselectedFieldColor = Color(0xFFF0F0F0);  

  return ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(
        primaryColor.value,
        <int, Color>{
          50: Color(0xFFEAF7E1),
          100: Color(0xFFD4EDB6),
          200: Color(0xFFBBE48B),
          300: Color(0xFFA1DB5E),
          400: Color(0xFF8CD643),
          500: primaryColor,
          600: Color(0xFF7CDD44),
          700: Color(0xFF70D040),
          800: Color(0xFF64C43C),
          900: Color(0xFF50B934),
        },
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      dialHandColor: primaryColor,
      dialBackgroundColor: primaryColor.withOpacity(0.2),
      hourMinuteColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;  
        }
        return unselectedFieldColor;  
      }),
      hourMinuteTextColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white; 
        }
        return Colors.black;  
      }),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryColor,
      circularTrackColor: primaryColor.withOpacity(0.2),
    ),
   
  );
}
