import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final String title;
  final String message;
  final String updateLabel;
  final String laterLabel;
  final String updateUrl;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.message,
    required this.updateLabel,
    required this.laterLabel,
    required this.updateUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(laterLabel),
        ),
        TextButton(
          onPressed: () => launchUrl(Uri.parse(updateUrl)),
          child: Text(updateLabel),
        ),
      ],
    );
  }
}
