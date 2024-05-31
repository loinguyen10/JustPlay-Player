import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_chocolatecookies/helper/navigator_helper.dart';
import 'package:flutter_musicplayer/screen/player/youtube/youtube_player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildItem(icon: Icons.play_circle, title: 'Youtube', page: const YoutubePlayerPage()),
          _buildItem(icon: Icons.wifi_rounded, title: 'Spotify', page: Container()),
          _buildItem(icon: Icons.cloud, title: 'Soundcloud', page: Container()),
        ],
      ),
    );
  }

  _buildItem({required IconData icon, required String title, required Widget page}) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => NavigatorHelper().pushNext(page),
        child: Container(
          width: mediaSize.width,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.all(12),
          color: Colors.red,
          child: Row(
            children: [Icon(icon), space(2), Text(title)],
          ),
        ),
      ),
    );
  }
}
