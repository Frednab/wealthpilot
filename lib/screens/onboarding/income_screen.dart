// lib/screens/onboarding/income_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});
  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  String? _selectedIncome;
  PayFrequency? _selectedFrequency;

  final _incomeRanges = [
    'Under \$1,000',
    '\$1,000 – \$2,500',
    '\$2,500 – \$5,000',
    '\$5,000 – \$10,000',
    '\$10,000+',
  ];

  final _frequencies = [
    (PayFrequency.weekly, Icons.calendar_today, 'Weekly'),
    (PayFrequency.biweekly, Icons.calendar_today, 'Every 2 Weeks'),
    (PayFrequency.twiceMonthly, Icons.calendar_today, 'Twice a Month'),
    (PayFrequency.monthly, Icons.calendar_today, 'Monthly'),
    (PayFrequency.irregular, Icons.calendar_today, 'Irregular / Freelance'),
  ];

  @override
  Widget build(BuildContext context) {
    final canContinue = _selectedIncome != null && _selectedFrequency != null;

    return WPOnboardingScaffold(
      title: "Let's Match Your Plan\nto Your Life",
      subtitle: 'So we only suggest what\'s comfortable for you',
      bottomAction: Column(
        children: [
          WPPrimaryButton(
            label: 'Continue',
            onPressed: canContinue
                ? () async {
                    await context.read<UserProfileProvider>().updateIncome(
                          incomeRange: _selectedIncome,
                          payFrequency: _selectedFrequency,
                        );
                    context.push('/onboarding/budget');
                  }
                : null,
          ),
          const SizedBox(height: 8),
          WPSkipButton(
            onPressed: () => context.push('/onboarding/budget'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How much do you usually earn per month?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 12),
            ..._incomeRanges.map((range) {
              final isSelected = _selectedIncome == range;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIncome = range),
                  child: _SelectableRow(label: range, isSelected: isSelected),
                ),
              );
            }),
            const SizedBox(height: 20),
            const Text('How do you usually get paid?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 12),
            ..._frequencies.map((f) {
              final isSelected = _selectedFrequency == f.$1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFrequency = f.$1),
                  child: _SelectableRow(
                      label: f.$3,
                      icon: f.$2,
                      isSelected: isSelected),
                ),
              );
            }),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: WealthPilotTheme.cardWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock_outline,
                      color: WealthPilotTheme.textGray, size: 18),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your income information is private and only used to personalize your plan. We never share your data.',
                      style: TextStyle(
                          fontSize: 12, color: WealthPilotTheme.textGray),
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

class _SelectableRow extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;

  const _SelectableRow({
    required this.label,
    this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: WealthPilotTheme.cardWhite,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isSelected
              ? WealthPilotTheme.primaryBlue
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 18,
                color: isSelected
                    ? WealthPilotTheme.primaryBlue
                    : WealthPilotTheme.textGray),
            const SizedBox(width: 12),
          ],
          Text(
            label,
            style: TextStyle(
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? WealthPilotTheme.primaryNavy
                  : WealthPilotTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
