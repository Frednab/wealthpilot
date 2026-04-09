// lib/screens/onboarding/set_timeline_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class SetTimelineScreen extends StatefulWidget {
  const SetTimelineScreen({super.key});
  @override
  State<SetTimelineScreen> createState() => _SetTimelineScreenState();
}

class _SetTimelineScreenState extends State<SetTimelineScreen> {
  double _years = 10;

  @override
  Widget build(BuildContext context) {
    final targetYear = DateTime.now().year + _years.round();
    return WPOnboardingScaffold(
      title: 'Set Your Timeline',
      subtitle: 'How long do you plan to invest?',
      bottomAction: WPPrimaryButton(
        label: 'Continue',
        onPressed: () async {
          await context.read<UserProfileProvider>().updateTimeline(_years.round());
          context.push('/onboarding/risk');
        },
      ),
      body: Column(
        children: [
          const Spacer(),
          Text(
            '${_years.round()}',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: WealthPilotTheme.primaryNavy,
            ),
          ),
          const Text('Years',
              style: TextStyle(fontSize: 18, color: WealthPilotTheme.textGray)),
          const SizedBox(height: 32),
          Slider(
            value: _years,
            min: 1,
            max: 30,
            divisions: 29,
            activeColor: WealthPilotTheme.primaryNavy,
            onChanged: (v) => setState(() => _years = v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('1 year',
                    style: TextStyle(color: WealthPilotTheme.textGray)),
                Text('30 years',
                    style: TextStyle(color: WealthPilotTheme.textGray)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: WealthPilotTheme.cardWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Estimated target year: ',
                    style: TextStyle(color: WealthPilotTheme.textGray)),
                Text('$targetYear',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: WealthPilotTheme.primaryNavy)),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
