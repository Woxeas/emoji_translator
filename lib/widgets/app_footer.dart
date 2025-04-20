import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  bool _hoverLabs = false;
  bool _hoverGitHub = false;
  bool _hoverNarrativva = false;
  bool _isButtonPressed = false;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  TextSpan _linkSpan(
    String label,
    String url,
    bool isHover,
    ValueChanged<bool> onHover,
  ) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.primary;
    final hoverColor = Color.lerp(baseColor, Colors.black, 0.2)!;
    final color = isHover ? hoverColor : baseColor;

    return TextSpan(
      text: label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.none,
      ),
      recognizer: TapGestureRecognizer()..onTap = () => _open(url),
      mouseCursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodySmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    final year = DateTime.now().year.toString();

    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: loc.builtBy(''), style: baseStyle),
              _linkSpan(
                'Narrativva Labs',
                'https://labs.narrativva.com',
                _hoverLabs,
                (h) => setState(() => _hoverLabs = h),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: loc.starUs(''), style: baseStyle),
              _linkSpan(
                'GitHub',
                'https://github.com/bujnovskyf/emoji_translator',
                _hoverGitHub,
                (h) => setState(() => _hoverGitHub = h),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: loc.copyright(year),
                style: baseStyle,
              ),
              _linkSpan(
                ' Narrativva',
                'https://narrativva.com',
                _hoverNarrativva,
                (h) => setState(() => _hoverNarrativva = h),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          if (!_isButtonPressed)
            TextButton(
              onPressed: () {
                Sentry.captureException(Exception('Testovací chyba ze Sentry tlačítka'));
                setState(() {
                  _isButtonPressed = true;
                });
              },
              child: const Text(
                'Send error',
                style: TextStyle(fontSize: 12),
              ),
            ),
          if (_isButtonPressed)
            Text(
              'Error sent',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
