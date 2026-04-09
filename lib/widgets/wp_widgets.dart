// lib/widgets/wp_button.dart
// Shared WealthPilot UI components

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Standard full-width primary button
class WPPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const WPPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(label),
      ),
    );
  }
}

/// Outlined secondary button
class WPOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const WPOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

/// Text-style skip button
class WPSkipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const WPSkipButton({
    super.key,
    this.label = 'Skip for now',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: WealthPilotTheme.textGray,
          fontSize: 14,
        ),
      ),
    );
  }
}

/// Selectable option card (used in goal type, risk, experience screens)
class WPOptionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool isSelected;
  final VoidCallback onTap;

  const WPOptionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WealthPilotTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? WealthPilotTheme.primaryBlue
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: WealthPilotTheme.primaryBlue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? WealthPilotTheme.primaryNavy
                          : WealthPilotTheme.textDark,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: WealthPilotTheme.textGray,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon container for option cards
class WPOptionIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const WPOptionIcon({
    super.key,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isSelected
            ? WealthPilotTheme.primaryNavy
            : WealthPilotTheme.backgroundLight,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : WealthPilotTheme.textGray,
        size: 22,
      ),
    );
  }
}

/// Onboarding scaffold — consistent layout for all onboarding screens
class WPOnboardingScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? bottomAction;
  final bool showBack;

  const WPOnboardingScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.bottomAction,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WealthPilotTheme.backgroundLight,
      appBar: showBack
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: WealthPilotTheme.textDark),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(title,
                  style: Theme.of(context).textTheme.displayMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!,
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
              const SizedBox(height: 24),
              Expanded(child: body),
              if (bottomAction != null) ...[
                const SizedBox(height: 16),
                bottomAction!,
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Progress indicator card
class WPProgressCard extends StatelessWidget {
  final String label;
  final double current;
  final double target;
  final String currency;

  const WPProgressCard({
    super.key,
    required this.label,
    required this.current,
    required this.target,
    this.currency = '\$',
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (current / target).clamp(0.0, 1.0);
    final int percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WealthPilotTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: WealthPilotTheme.textGray, fontSize: 14)),
              Text(
                '$currency${target.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: WealthPilotTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Current Progress',
                  style: TextStyle(
                      color: WealthPilotTheme.textGray, fontSize: 13)),
              Text(
                '$currency${current.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: WealthPilotTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: WealthPilotTheme.backgroundLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  WealthPilotTheme.primaryBlue),
            ),
          ),
          const SizedBox(height: 4),
          Text('$percent% complete',
              style: const TextStyle(
                  color: WealthPilotTheme.textGray, fontSize: 12)),
        ],
      ),
    );
  }
}
