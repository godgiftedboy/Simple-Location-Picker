import 'package:flutter/material.dart';
import 'package:simple_location_picker/biometric/biometric_service.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({super.key});

  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  final authService = BiometricAuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Auth Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // Simulate storing refresh token after normal login
                await authService.storeRefreshToken(
                    context, 'my_refresh_token_from_server');
              },
              child: const Text('Store Refresh Token'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Retrieve access token via biometric authentication
                final accessToken = await authService.getAccessToken(context);
                if (accessToken != null) {
                  print("Access Token: $accessToken");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Access Token retrieved! $accessToken'),
                    ),
                  );
                }
              },
              child: const Text('Get Access Token'),
            ),
            ElevatedButton(
              onPressed: () async {
                await authService.clearRefreshToken(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Refresh token cleared')),
                );
              },
              child: const Text('Clear Refresh Token'),
            ),
          ],
        ),
      ),
    );
  }
}
