import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../services/fcm_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();
  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/images/default.png';
  String tokenText = 'Fetching token';

  @override
  void initState() {
    super.initState();
    _fcmService.initialize(onData: (message) {
      setState(() {
        statusText = message.notification?.title ?? 'Payload received';
        imagePath = 'assets/images/${message.data['asset'] ?? 'default'}.png';
      });
    });
    _loadToken();
  }

  void _loadToken() async {
  try {
    final token = await _fcmService.getToken();
    setState(() {
      tokenText = token ?? 'No token returned';
    });
    debugPrint('FCM token: $token');
  } catch (e) {
    setState(() {
      tokenText = 'Token error: check network/emulator';
    });
    debugPrint('Token fetch failed: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(statusText),
            const SizedBox(height: 20),
            Image.asset(imagePath, height: 150),
            const SizedBox(height: 20),
            Text(tokenText, style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}