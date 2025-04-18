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
  try {
    await supabase.from('votes').insert({
      'model': modelName,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    print('[Supabase] Vote recorded for model: $modelName');
  } catch (e) {
    print('[Supabase] Error voting: $e');
  }
}
Future<int> getTranslationCount() async {
  try {
    print('[Supabase] Fetching count via RPC...');
    final data = await supabase.rpc('get_translation_count');
    print('[Supabase] Got count: $data');
    return data as int;
  } catch (e) {
    print('[Supabase] Error calling RPC get_translation_count: $e');
    return 0;
  }
}


Future<String?> getMostVotedModel() async {
  try {
    final response = await supabase.from('most_voted_model').select().limit(1);
    if (response.isNotEmpty) {
      return response.first['model'] as String?;
    }
    return null;
  } catch (e) {
    print('[Supabase] Error fetching most voted model: $e');
    return null;
  }
}

