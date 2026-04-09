// lib/screens/onboarding/reality_check_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class RealityCheckScreen extends StatelessWidget {
  const RealityCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    final profile = provider.profile;
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    if (profile == null) return const SizedBox();

    final projected = profile.projectedValue();
    final isRealistic = profile.isGoalRealistic;
    final required = profile.requiredMonthlyInvestment();

    return WPOnboardingScaffold(
      title: 'Reality Check',
      subtitle: "Let's see if your goal is achievable",
      bottomAction: Column(
        children: [
          WPPrimaryButton(
            label: 'Continue with Plan',
            onPressed: () async {
              await provider.completeOnboarding();
              context.go('/dashboard');
            },
          ),
          const SizedBox(height: 12),
          WPOutlinedButton(
            label: 'Adjust My Inputs',
            onPressed: () => context.go('/onboarding/goal'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Feasibility badge
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WealthPilotTheme.cardWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    isRealistic ? Icons.check_circle : Icons.cancel,
                    color: isRealistic
                        ? WealthPilotTheme.successGreen
                        : WealthPilotTheme.errorRed,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRealistic ? 'Realistic!' : 'Unrealistic',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isRealistic
                                ? WealthPilotTheme.successGreen
                                : WealthPilotTheme.errorRed,
                          ),
                        ),
                        const Text(
                          'Goal Feasibility',
                          style: TextStyle(
                              color: WealthPilotTheme.textGray, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isRealistic
                              ? 'Great news! Your plan can reach your goal. Stay consistent.'
                              : 'Your current plan may not reach your goal. Consider adjusting your target amount, timeline, or monthly investment.',
                          style: const TextStyle(
                              color: WealthPilotTheme.textGray, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Your Plan summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: WealthPilotTheme.cardWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Plan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: WealthPilotTheme.textDark)),
                  const SizedBox(height: 16),
                  _PlanRow(
                    label: 'Target Amount',
                    value: formatter.format(profile.targetAmount ?? 0),
                  ),
                  const Divider(height: 24),
                  _PlanRow(
                    label: 'Timeline',
                    value: '${profile.timelineYears ?? 0} years',
                  ),
                  const Divider(height: 24),
                  _PlanRow(
                    label: 'Monthly Investment',
                    value: formatter.format(profile.monthlyInvestmentBudget ?? 0),
                  ),
                  const Divider(height: 24),
                  _PlanRow(
                    label: 'Projected Total',
                    value: formatter.format(projected),
                    valueColor: WealthPilotTheme.primaryBlue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Recommendation card
            if (!isRealistic && required != null)
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
                        Text('💡 ', style: TextStyle(fontSize: 18)),
                        Text('Recommendation',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: WealthPilotTheme.textDark)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'To reach your ${formatter.format(profile.targetAmount ?? 0)} goal in ${profile.timelineYears ?? 0} years, you need:',
                      style: const TextStyle(
                          color: WealthPilotTheme.textGray, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _RecommendationItem(
                      icon: Icons.payments_outlined,
                      label: 'Monthly investment of',
                      value: formatter.format(required),
                    ),
                    const SizedBox(height: 8),
                    _RecommendationItem(
                      icon: Icons.percent,
                      label: 'Expected annual return',
                      value:
                          '${(profile.expectedReturnRate * 100).toStringAsFixed(0)}%',
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

class _PlanRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PlanRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: WealthPilotTheme.textGray, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: valueColor ?? WealthPilotTheme.textDark,
          ),
        ),
      ],
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RecommendationItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: WealthPilotTheme.primaryBlue),
        const SizedBox(width: 8),
        Text('$label ',
            style: const TextStyle(
                color: WealthPilotTheme.textGray, fontSize: 14)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: WealthPilotTheme.primaryNavy,
                fontSize: 14)),
      ],
    );
  }
}
