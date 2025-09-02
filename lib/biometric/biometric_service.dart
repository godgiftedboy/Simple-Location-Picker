import 'dart:developer';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';

class BiometricAuthService {
  static const _refreshTokenKey = 'refresh_token';

  /// Store refresh token securely with biometric protection
  Future<void> storeRefreshToken(BuildContext context, String token) async {
    final canAuth = await BiometricStorage().canAuthenticate();
    if (canAuth != CanAuthenticateResponse.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Biometric authentication not available: ${canAuth.toString()}")),
      );
      return;
    }

    final storage = await BiometricStorage().getStorage(
      _refreshTokenKey,
      options: StorageFileInitOptions(
        authenticationRequired: true,
      ),
    );

    await storage.write(token);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("✅ Refresh token stored securely with biometrics")),
    );
  }

  /// Retrieve refresh token (prompts biometric authentication)
  Future<String?> getRefreshToken(BuildContext context) async {
    try {
      final storage = await BiometricStorage().getStorage(_refreshTokenKey);
      final token = await storage.read(); // Biometric prompt occurs here
      log("Refresh Token $token");
      return token;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to retrieve refresh token")),
      );
      return null;
    }
  }

  /// Fetch a new access token using the refresh token
  Future<String?> getAccessToken(BuildContext context) async {
    final refreshToken = await getRefreshToken(context);
    if (refreshToken == null) return null;

    try {
      await Future.delayed(const Duration(milliseconds: 700));
      return "new_access_token"; // Simulated new access token
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error during token refresh")),
      );
      return null;
    }
  }

  /// Clear stored refresh token
  Future<void> clearRefreshToken(BuildContext context) async {
    final storage = await BiometricStorage().getStorage(_refreshTokenKey);
    await storage.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Refresh token cleared")),
    );
  }
}
