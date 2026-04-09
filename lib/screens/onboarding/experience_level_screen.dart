// lib/screens/onboarding/experience_level_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_provider.dart';
import '../../widgets/wp_widgets.dart';

class ExperienceLevelScreen extends StatefulWidget {
  const ExperienceLevelScreen({super.key});
  @override
  State<ExperienceLevelScreen> createState() => _ExperienceLevelScreenState();
}

class _ExperienceLevelScreenState extends State<ExperienceLevelScreen> {
  ExperienceLevel? _selected;

  final _options = [
    (ExperienceLevel.beginner, 'Beginner', 'New to investing, learning the basics', Icons.auto_awesome),
    (ExperienceLevel.intermediate, 'Intermediate', 'Some experience, building knowledge', Icons.menu_book),
    (ExperienceLevel.advanced, 'Advanced', 'Experienced investor, understand markets', Icons.school),
  ];

  @override
  Widget build(BuildContext context) {
    return WPOnboardingScaffold(
      title: 'Experience Level',
      subtitle: 'Tell us about your investing experience',
      bottomAction: WPPrimaryButton(
        label: 'Continue',
        onPressed: _selected != null
            ? () async {
                await context.read<UserProfileProvider>().updateExperience(_selected!);
                context.push('/onboarding/income');
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
              subtitle: o.$3,
              leading: WPOptionIcon(icon: o.$4, isSelected: isSelected),
              isSelected: isSelected,
              onTap: () => setState(() => _selected = o.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}
