import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hi, I\'m told, all iOS app designer. I create resources to help you design better apps. If you\'re my most useful, please support me to keep making more.'),
            const SizedBox(height: 20),
            const Text('Links'),
            TextButton(
              onPressed: () {
                // Handle Buy Me A Coffee link
              },
              child: const Text('Buy Me A Coffee'),
            ),
            TextButton(
              onPressed: () {
                // Handle BusinessofTics.com link
              },
              child: const Text('BusinessofTics.com/1234567899'),
            ),
            const SizedBox(height: 20),
            const Text('Contact'),
            const Text('pcsic.CV - @blogculture'),
            const Text('sj.com/blog/?visitor = @blogculture'),
          ],
        ),
      ),
    );
  }
}