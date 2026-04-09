// lib/screens/onboarding/risk_tolerance_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class RiskToleranceScreen extends StatefulWidget {
  const RiskToleranceScreen({super.key});
  @override
  State<RiskToleranceScreen> createState() => _RiskToleranceScreenState();
}

class _RiskToleranceScreenState extends State<RiskToleranceScreen> {
  RiskTolerance? _selected;

  final _options = [
    (
      RiskTolerance.low,
      'Low Risk',
      'Stable growth, minimal volatility',
      '4–6% annual return',
      Icons.show_chart,
    ),
    (
      RiskTolerance.medium,
      'Medium Risk',
      'Balanced risk and reward',
      '7–10% annual return',
      Icons.timeline,
    ),
    (
      RiskTolerance.high,
      'High Risk',
      'Maximum growth potential',
      '10–15% annual return',
      Icons.trending_up,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WPOnboardingScaffold(
      title: 'Risk Tolerance',
      subtitle: 'How comfortable are you with market fluctuations?',
      bottomAction: WPPrimaryButton(
        label: 'Continue',
        onPressed: _selected != null
            ? () async {
                await context
                    .read<UserProfileProvider>()
                    .updateRiskTolerance(_selected!);
                context.push('/onboarding/experience');
              }
            : null,
      ),
      body: Column(
        children: _options.map((o) {
          final isSelected = _selected == o.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: WPOptionCard(
              title: o.$2,
              subtitle: '${o.$3}\n',
              leading: WPOptionIcon(icon: o.$5, isSelected: isSelected),
              isSelected: isSelected,
              onTap: () => setState(() => _selected = o.$1),
            ),
          );
        }).toList()
          ..addAll([]), // extra items added inline via map
      ),
    );
  }
}
