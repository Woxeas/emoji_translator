import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  TextSpan _linkSpan(String label, String url, BuildContext context) {
    return TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = () => _open(url),
      onEnter: (_) => MouseRegion(cursor: SystemMouseCursors.click),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _footerLine(
            context,
            const TextSpan(text: 'Built by '),
            _linkSpan('Narrativva Labs', 'https://labs.narrativva.com', context),
          ),
          const SizedBox(height: 8),
          _footerLine(
            context,
            const TextSpan(text: 'Star us on '),
            _linkSpan('GitHub', 'https://github.com/bujnovskyf/emoji_translator', context),
          ),
          const SizedBox(height: 8),
          _footerLine(
            context,
            const TextSpan(text: '© 2025 '),
            _linkSpan('Narrativva', 'https://narrativva.com', context),
          ),
        ],
      ),
    );
  }

  Widget _footerLine(BuildContext context, TextSpan prefix, TextSpan link) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        children: [prefix, link],
      ),
    );
  }
}
