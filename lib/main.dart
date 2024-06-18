import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_justplay_player/api/spotify_api.dart';
import 'package:flutter_justplay_player/screen/home/home_page.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> connect() async {
    await SpotifySdk.connectToSpotifyRemote(clientId: SpotifyAPI().clientId, redirectUrl: SpotifyAPI().redirectUrl);
    SpotifySdk.subscribePlayerState();
    SpotifySdk.subscribePlayerContext();
  }

  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme().start();
    return const ChocolateCookiesMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
