import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: Color(0xFF303F9F), // Professional dark blue primary color
    scaffoldBackgroundColor:
        Color(0xFFF6F5F5), // Dark background for a serious tone
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFFDE700), // Matches the primary color
      foregroundColor: Colors.black, // White text/icons for contrast
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xF7211933), // Subtle blue for buttons
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF64B5F6), // Light blue for text buttons
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF212121), // Dark fill for text fields
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF3949AB), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF3949AB), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF64B5F6), width: 2),
      ),
      hintStyle: TextStyle(
        color: Colors.white70, // Lighter hint color for readability
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor:
          Color(0xFF64B5F6), // Light blue for floating action buttons
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white70, // Light text for readability
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
      displayLarge: TextStyle(
        color: Color(0xFF3949AB), // Dark blue for main headings
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.white70,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF3949AB), // Blue buttons
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF64B5F6), // Light blue icons for consistency
      size: 24,
    ),
  );
}
