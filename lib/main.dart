import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:async';
import 'app.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initSupabase();

    const sentryDsn = String.fromEnvironment('SENTRY_DSN');

    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.tracesSampleRate = 1.0;
        options.debug = true;
      },
    );

    runApp(const EmojiTranslatorApp());
  }, (error, stackTrace) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  });
}
