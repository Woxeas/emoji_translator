#!/usr/bin/env bash
set -e  # Exit immediately if a command exits with a non-zero status

# === Step 1: Download or update Flutter SDK ===
if [ -d "flutter" ]; then
  echo "Flutter SDK already exists, updating..."
  cd flutter && git pull && cd ..
else
  echo "=== Cloning Flutter SDK ==="
  git clone https://github.com/flutter/flutter.git
fi

# Add flutter to path
export PATH="$PATH:$(pwd)/flutter/bin"

# === Step 2: Ensure web is enabled and Flutter is up to date ===
echo "=== Switching to stable channel ==="
flutter channel stable
flutter upgrade
flutter config --enable-web

# === Step 3: Build the app with dart-define values from Netlify env ===
echo "=== Building Flutter web (release) ==="
flutter build web --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
  --dart-define=OPENAI_API_KEY=$OPENAI_API_KEY \
  --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
  --dart-define=GROK_API_KEY=$GROK_API_KEY \
  --dart-define=DEEPSEEK_API_KEY=$DEEPSEEK_API_KEY

echo "Flutter web build completed"
