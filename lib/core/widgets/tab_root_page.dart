import 'package:flutter/material.dart';

class TabRootPage extends StatelessWidget {
  const TabRootPage({super.key, required this.title, required this.onOpenDetail});

  final String title;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title Tab')),
      body: Center(
        child: ElevatedButton(
          onPressed: onOpenDetail,
          child: const Text('Open Detail (no bottom bar)'),
        ),
      ),
    );
  }
}
