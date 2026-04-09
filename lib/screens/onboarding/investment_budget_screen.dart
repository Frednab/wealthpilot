// lib/screens/onboarding/investment_budget_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class InvestmentBudgetScreen extends StatefulWidget {
  const InvestmentBudgetScreen({super.key});
  @override
  State<InvestmentBudgetScreen> createState() => _InvestmentBudgetScreenState();
}

class _InvestmentBudgetScreenState extends State<InvestmentBudgetScreen> {
  final _controller = TextEditingController(text: '300');
  InvestmentFrequency _frequency = InvestmentFrequency.monthly;
  final _formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  double get _amount => double.tryParse(_controller.text) ?? 0;

  double get _projectedAnnual {
    switch (_frequency) {
      case InvestmentFrequency.daily:
        return _amount * 365;
      case InvestmentFrequency.weekly:
        return _amount * 52;
      case InvestmentFrequency.monthly:
        return _amount * 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WPOnboardingScaffold(
      title: 'Investment Budget',
      subtitle: 'How much can you invest regularly?',
      bottomAction: WPPrimaryButton(
        label: 'Continue',
        onPressed: () async {
          await context.read<UserProfileProvider>().updateInvestmentBudget(
                amount: _amount,
                frequency: _frequency,
              );
          context.push('/onboarding/safety-fund');
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Amount',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: WealthPilotTheme.textDark)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          const Text('Frequency',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: WealthPilotTheme.textDark)),
          const SizedBox(height: 12),
          Row(
            children: InvestmentFrequency.values.map((f) {
              final label = f.name[0].toUpperCase() + f.name.substring(1);
              final isSelected = _frequency == f;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _frequency = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? WealthPilotTheme.primaryNavy
                            : WealthPilotTheme.cardWhite,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : WealthPilotTheme.textDark,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: WealthPilotTheme.cardWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Projected annual investment',
                    style: TextStyle(
                        color: WealthPilotTheme.textGray, fontSize: 13)),
                const SizedBox(height: 8),
                Text(
                  _formatter.format(_projectedAnnual),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: WealthPilotTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
