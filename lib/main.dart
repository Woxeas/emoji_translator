// Entry point + runApp
import 'package:flutter/material.dart';
import 'app.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(const EmojiTranslatorApp());
}