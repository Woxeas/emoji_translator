import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

final supabase = Supabase.instance.client;

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
}

Future<void> incrementTranslationCount() async {
  try {
    await supabase.from('translations').insert({
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
    print('[Supabase] Logged translation event');
  } catch (e) {
    print('[Supabase] Error logging translation: $e');
  }
}

Future<void> voteBest(String modelName) async {
  // TODO: Call Supabase to record vote for best model
}

