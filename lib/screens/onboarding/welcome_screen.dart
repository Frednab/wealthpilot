// lib/screens/onboarding/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WealthPilotTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.trending_up,
                          color: WealthPilotTheme.primaryNavy, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'WealthPilot',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: WealthPilotTheme.primaryNavy,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Build Wealth With\nConfidence',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your AI guide to smarter investing',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            // Hero illustration area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: WealthPilotTheme.backgroundLight,
                ),
                // TODO: Replace with actual hero image asset
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/hero_illustration.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFB8D4F0),
                            Color(0xFF7BB3E0),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.landscape,
                          size: 120,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFD6E4F7),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Text(
                    'Build Wealth With\nConfidence',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your AI guide to smarter investing',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  WPPrimaryButton(
                    label: 'Get Started',
                    onPressed: () async {
                      final provider = context.read<UserProfileProvider>();
                      await provider.createProfile();
                      context.go('/onboarding/why');
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to login
                    },
                    child: const Text(
                      'I already have an account',
                      style: TextStyle(
                        color: WealthPilotTheme.primaryNavy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
