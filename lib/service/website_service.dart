import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteService {

  static Future<void> launchWebsite(BuildContext context, Uri url) async {
    if (await canLaunchUrl(url)) {
      final bool isInApp = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(child: Text('Open Website options')),
          content: const Text('Where do you want to open the website?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('In App', style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('In Browser',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                ),
              ],
            )
          ],
        ),
      );
      if (isInApp) {
        await launchUrl(url, mode: LaunchMode.inAppWebView);
      } else {
        await launch(url.toString());
      }
    } else {
      throw Exception('Could not launch $url');
    }
  }
}