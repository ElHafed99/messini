import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AppThemes {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  final IconData backIcon = translator.activeLanguageCode == 'ar'
      ? Ionicons.chevron_forward
      : Ionicons.chevron_back;

  static const primaryColor = Color(0xff019267);
  static const mainColor = Color(0xff00C897);
  static const darkColor = Color(0xff252A34);
  static const greyColor = Color(0xff6a7081);
  static const lightGreyColor = Color(0xffF4F6FF);

  static TextTheme lightTextTheme() {
    return const TextTheme(
      headline1: TextStyle(color: darkColor, fontSize: 112),
      headline2: TextStyle(color: darkColor, fontSize: 56),
      headline3: TextStyle(color: darkColor, fontSize: 45),
      headline4: TextStyle(color: darkColor, fontSize: 34),
      headline5: TextStyle(color: darkColor, fontSize: 24),
      headline6: TextStyle(color: darkColor, fontSize: 20),
      subtitle1: TextStyle(color: darkColor, fontSize: 16),
      subtitle2: TextStyle(color: darkColor, fontSize: 14),
      bodyText1: TextStyle(color: darkColor, fontSize: 14),
      bodyText2: TextStyle(color: darkColor, fontSize: 14),
      overline: TextStyle(color: darkColor, fontSize: 10),
      caption: TextStyle(color: darkColor, fontSize: 12),
    );
  }

  static TextTheme darkTextTheme() {
    return const TextTheme(
      headline1: TextStyle(color: lightGreyColor, fontSize: 112),
      headline2: TextStyle(color: lightGreyColor, fontSize: 56),
      headline3: TextStyle(color: lightGreyColor, fontSize: 45),
      headline4: TextStyle(color: lightGreyColor, fontSize: 34),
      headline5: TextStyle(color: lightGreyColor, fontSize: 24),
      headline6: TextStyle(color: lightGreyColor, fontSize: 20),
      subtitle1: TextStyle(color: lightGreyColor, fontSize: 16),
      subtitle2: TextStyle(color: lightGreyColor, fontSize: 14),
      bodyText1: TextStyle(color: lightGreyColor, fontSize: 14),
      bodyText2: TextStyle(color: lightGreyColor, fontSize: 14),
      overline: TextStyle(color: lightGreyColor, fontSize: 10),
      caption: TextStyle(color: lightGreyColor, fontSize: 12),
    );
  }

  ///Light theme
  static ThemeData lightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        fontFamily: translator.activeLanguageCode == 'ar' ? 'Cairo' : 'Poppins',
        scaffoldBackgroundColor: lightGreyColor,
        textTheme: lightTextTheme(),
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: lightGreyColor),
            elevation: 0.0,
            centerTitle: true),
        dividerTheme: const DividerThemeData(
          color: greyColor,
        ),
        tabBarTheme: const TabBarTheme(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: primaryColor,
            unselectedLabelColor: darkColor),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: AppThemes.darkColor,
          selectedItemColor: AppThemes.primaryColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
            padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
            elevation: MaterialStateProperty.all(0.0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            behavior: SnackBarBehavior.floating,
            contentTextStyle: TextStyle(
                fontFamily: translator.activeLanguageCode == 'ar'
                    ? 'Cairo'
                    : "Poppins")),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
        ),
        colorScheme: ColorScheme.fromSwatch(
                brightness: Brightness.light,
                primarySwatch: createMaterialColor(primaryColor))
            .copyWith(secondary: mainColor),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ));
  }

  ///Dark theme
  static ThemeData darkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        fontFamily: translator.activeLanguageCode == 'ar' ? 'Cairo' : 'Poppins',
        scaffoldBackgroundColor: darkColor,
        textTheme: darkTextTheme(),
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: lightGreyColor),
            elevation: 0.0,
            centerTitle: true),
        dividerTheme: const DividerThemeData(
          color: greyColor,
        ),
        tabBarTheme: const TabBarTheme(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: primaryColor,
            unselectedLabelColor: darkColor),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: AppThemes.lightGreyColor,
          selectedItemColor: AppThemes.primaryColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
            //padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
            elevation: MaterialStateProperty.all(0.0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
            backgroundColor: darkColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            behavior: SnackBarBehavior.floating,
            contentTextStyle: TextStyle(
                fontFamily: translator.activeLanguageCode == 'ar'
                    ? 'Cairo'
                    : "Poppins")),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          focusColor: Colors.white,
          labelStyle: TextStyle(color: lightGreyColor),
        ),
        colorScheme: ColorScheme.fromSwatch(
                brightness: Brightness.dark,
                primarySwatch: createMaterialColor(primaryColor))
            .copyWith(secondary: mainColor),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ));
  }
}
