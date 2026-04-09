// lib/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'screens/onboarding/splash_screen.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/why_wealthpilot_screen.dart';
import 'screens/onboarding/set_goal_screen.dart';
import 'screens/onboarding/set_timeline_screen.dart';
import 'screens/onboarding/risk_tolerance_screen.dart';
import 'screens/onboarding/experience_level_screen.dart';
import 'screens/onboarding/income_screen.dart';
import 'screens/onboarding/investment_budget_screen.dart';
import 'screens/onboarding/safety_fund_screen.dart';
import 'screens/onboarding/reality_check_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'services/user_profile_provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final provider = context.read<UserProfileProvider>();
    if (provider.isLoading) return '/splash';
    if (provider.onboardingComplete && state.uri.path.startsWith('/onboarding')) {
      return '/dashboard';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding/why',
      builder: (context, state) => const WhyWealthPilotScreen(),
    ),
    GoRoute(
      path: '/onboarding/goal',
      builder: (context, state) => const SetGoalScreen(),
    ),
    GoRoute(
      path: '/onboarding/timeline',
      builder: (context, state) => const SetTimelineScreen(),
    ),
    GoRoute(
      path: '/onboarding/risk',
      builder: (context, state) => const RiskToleranceScreen(),
    ),
    GoRoute(
      path: '/onboarding/experience',
      builder: (context, state) => const ExperienceLevelScreen(),
    ),
    GoRoute(
      path: '/onboarding/income',
      builder: (context, state) => const IncomeScreen(),
    ),
    GoRoute(
      path: '/onboarding/budget',
      builder: (context, state) => const InvestmentBudgetScreen(),
    ),
    GoRoute(
      path: '/onboarding/safety-fund',
      builder: (context, state) => const SafetyFundScreen(),
    ),
    GoRoute(
      path: '/onboarding/reality-check',
      builder: (context, state) => const RealityCheckScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
