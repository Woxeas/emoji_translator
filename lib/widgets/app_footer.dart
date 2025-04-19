import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  bool _hoverLabs = false;
  bool _hoverGitHub = false;
  bool _hoverNarrativva = false;

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
    // darken o 20 % směsí s černou
    final hoverColor = Color.lerp(baseColor, Colors.black, 0.2)!;
    final color = isHover ? hoverColor : baseColor;

    return TextSpan(
      text: label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: color,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w600,
      ),
      recognizer: TapGestureRecognizer()..onTap = () => _open(url),
      mouseCursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: '🔧 Built by ', style: baseStyle),
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
              TextSpan(text: '⭐️ Star us on ', style: baseStyle),
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
              TextSpan(text: '© 2025 ❤️ ', style: baseStyle),
              _linkSpan(
                'Narrativva',
                'https://narrativva.com',
                _hoverNarrativva,
                (h) => setState(() => _hoverNarrativva = h),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
