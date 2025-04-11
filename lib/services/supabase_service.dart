// Supabase service for stats and voting
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> incrementTranslationCount() async {
  // TODO: Call Supabase to increment translation count (no content stored)
}

Future<void> voteBest(String modelName) async {
  // TODO: Call Supabase to record vote for best model
}

