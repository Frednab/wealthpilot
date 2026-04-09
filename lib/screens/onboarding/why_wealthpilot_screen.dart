// lib/screens/onboarding/why_wealthpilot_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class WhyWealthPilotScreen extends StatelessWidget {
  const WhyWealthPilotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WPOnboardingScaffold(
      title: 'Why WealthPilot?',
      subtitle: 'Your personal AI investment coach',
      showBack: false,
      bottomAction: WPPrimaryButton(
        label: 'Continue',
        onPressed: () => context.push('/onboarding/goal'),
      ),
      body: Column(
        children: [
          _FeatureCard(
            icon: Icons.track_changes,
            title: 'Smart Guidance',
            subtitle: 'AI-powered investment advice tailored to your goals',
            iconColor: WealthPilotTheme.primaryNavy,
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.trending_up,
            title: 'Build Discipline',
            subtitle: 'Stay consistent with your wealth-building journey',
            iconColor: WealthPilotTheme.primaryNavy,
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.shield_outlined,
            title: 'Realistic Plans',
            subtitle: 'Achieve your goals with practical, achievable steps',
            iconColor: WealthPilotTheme.primaryNavy,
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WealthPilotTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: WealthPilotTheme.textDark)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 13, color: WealthPilotTheme.textGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
