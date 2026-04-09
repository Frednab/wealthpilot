// lib/screens/onboarding/safety_fund_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class SafetyFundScreen extends StatelessWidget {
  const SafetyFundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WPOnboardingScaffold(
      title: 'Build Your Safety Fund',
      subtitle: 'Before investing, secure your foundation',
      bottomAction: WPPrimaryButton(
        label: 'Start Saving',
        onPressed: () => context.push('/onboarding/reality-check'),
      ),
      body: Column(
        children: [
          WPProgressCard(
            label: 'Target Amount',
            current: 1200,
            target: 5000,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: WealthPilotTheme.cardWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.attach_money,
                        color: WealthPilotTheme.primaryBlue),
                    SizedBox(width: 8),
                    Text('Suggested Savings Apps',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: WealthPilotTheme.textDark)),
                  ],
                ),
                const SizedBox(height: 12),
                ...[
                  'Ally Bank',
                  'Marcus by Goldman Sachs',
                  'Discover Savings',
                ].map((name) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: WealthPilotTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(name,
                          style: const TextStyle(
                              color: WealthPilotTheme.textDark)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
