import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri url0 = Uri.parse(url);
    if (!await canLaunch(url0.toString())) {
      throw 'Impossible de lancer $url';
    } else {
      await launch(url0.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('À Propos'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Quelle est cette application ?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),
            const Text(
              'Brawlhalla Ohara est une application de statistiques standard pour Brawlhalla. [...] Cette application est encore en phase de bêta précoce, il pourrait donc y avoir des bogues qui se promènent. Vous pouvez les signaler si vous le souhaitez à l\'adresse e-mail officielle gregorystfa023@gmail.com.',
            ),
            const SizedBox(height: 20),
            const Text(
              'FAQ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 20),
            const Text(
              'Liens Brawlhalla',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            ListTile(
              leading: const Icon(Icons.web),
              title: const Text('Site Web'),
              onTap: () => _launchURL('https://gregreborn.github.io/my-portfolio'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('E-mail'),
              onTap: () => _launchURL('mailto:gregorystfa023@gmail.com'),
            ),
          ],
        ),
      ),
    );
  }
}
