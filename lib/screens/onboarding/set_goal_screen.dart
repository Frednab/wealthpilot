// lib/screens/onboarding/set_goal_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class SetGoalScreen extends StatefulWidget {
  const SetGoalScreen({super.key});

  @override
  State<SetGoalScreen> createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  final _controller = TextEditingController(text: '100000');
  GoalType? _selectedGoal;

  final _goals = [
    (GoalType.retirement, 'Retirement'),
    (GoalType.wealthBuilding, 'Wealth Building'),
    (GoalType.businessVenture, 'Business Venture'),
    (GoalType.realEstate, 'Real Estate'),
    (GoalType.financialFreedom, 'Financial Freedom'),
    (GoalType.educationFund, 'Education Fund'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final amount = double.tryParse(_controller.text.replaceAll(',', ''));
    if (amount == null || _selectedGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount and select a goal type')),
      );
      return;
    }
    await context.read<UserProfileProvider>().updateGoal(
          targetAmount: amount,
          goalType: _selectedGoal,
        );
    context.push('/onboarding/timeline');
  }

  @override
  Widget build(BuildContext context) {
    return WPOnboardingScaffold(
      title: 'Set Your Goal',
      subtitle: 'What are you building wealth for?',
      bottomAction: WPPrimaryButton(
        label: 'Continue',
        onPressed: _selectedGoal != null ? _continue : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Target Amount',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: WealthPilotTheme.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                prefixText: '\$',
                hintText: '100,000',
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            const Text('Goal Type',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: WealthPilotTheme.textDark)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.8,
              children: _goals.map((g) {
                final isSelected = _selectedGoal == g.$1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGoal = g.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? WealthPilotTheme.primaryNavy
                          : WealthPilotTheme.cardWhite,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isSelected
                            ? WealthPilotTheme.primaryNavy
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      g.$2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : WealthPilotTheme.textDark,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
