import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class EmojiTranslatorApp extends StatelessWidget {
  const EmojiTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Translator',
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFBB1E),
          onPrimary: Colors.white,
          secondary: Color(0xFFFFBB1E),
          onSecondary: Colors.white,
          surface: Color(0xFFFFFBD4),
          onSurface: Color(0xFF414949),
        ),

        scaffoldBackgroundColor: const Color(0xFFFFFBD4),

        textTheme: TextTheme(
          headlineSmall: GoogleFonts.merriweather(
            color: const Color(0xFF414949),
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          titleMedium: GoogleFonts.merriweather(
            color: const Color(0xFF414949),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          bodyLarge: GoogleFonts.poppins(
            color: const Color(0xFF414949),
            fontSize: 16,
          ),
          bodyMedium: GoogleFonts.poppins(
            color: const Color(0xFF414949),
            fontSize: 14,
          ),
          labelLarge: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFBB1E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),

        cardTheme: CardTheme(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF2EEDB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          labelStyle: GoogleFonts.poppins(color: const Color(0xFF414949)),
        ),
      ),
      home: const HomePage(),
    );
  }
}