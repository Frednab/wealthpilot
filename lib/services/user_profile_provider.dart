// lib/services/user_profile_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = true;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get hasProfile => _profile != null;
  bool get onboardingComplete => _profile?.onboardingComplete ?? false;

  UserProfileProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileJson = prefs.getString('user_profile');
    if (profileJson != null) {
      _profile = UserProfile.fromJson(jsonDecode(profileJson));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveProfile() async {
    if (_profile == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(_profile!.toJson()));
  }

  Future<void> createProfile() async {
    _profile = UserProfile(id: const Uuid().v4());
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateGoal({
    double? targetAmount,
    GoalType? goalType,
  }) async {
    _profile?.targetAmount = targetAmount;
    _profile?.goalType = goalType;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateTimeline(int years) async {
    _profile?.timelineYears = years;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateRiskTolerance(RiskTolerance risk) async {
    _profile?.riskTolerance = risk;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateExperience(ExperienceLevel level) async {
    _profile?.experienceLevel = level;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateIncome({
    String? incomeRange,
    PayFrequency? payFrequency,
  }) async {
    _profile?.monthlyIncomeRange = incomeRange;
    _profile?.payFrequency = payFrequency;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateInvestmentBudget({
    required double amount,
    required InvestmentFrequency frequency,
  }) async {
    _profile?.monthlyInvestmentBudget = amount;
    _profile?.investmentFrequency = frequency;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateSafetyFund({
    double? target,
    double? current,
  }) async {
    if (target != null) _profile?.safetyFundTarget = target;
    if (current != null) _profile?.safetyFundCurrent = current;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _profile?.onboardingComplete = true;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> resetProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
    _profile = null;
    notifyListeners();
  }
}
