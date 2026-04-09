// lib/models/user_profile.dart

enum GoalType {
  retirement,
  wealthBuilding,
  businessVenture,
  realEstate,
  financialFreedom,
  educationFund,
}

enum RiskTolerance { low, medium, high }

enum ExperienceLevel { beginner, intermediate, advanced }

enum PayFrequency { weekly, biweekly, twiceMonthly, monthly, irregular }

enum InvestmentFrequency { daily, weekly, monthly }

class UserProfile {
  final String id;
  String? name;
  String? email;

  // Goal Setup
  double? targetAmount;
  GoalType? goalType;
  int? timelineYears;

  // Financial Profile
  String? monthlyIncomeRange; // e.g. "$2,500 – $5,000"
  PayFrequency? payFrequency;
  double? monthlyInvestmentBudget;
  InvestmentFrequency investmentFrequency;

  // Investor Profile
  RiskTolerance? riskTolerance;
  ExperienceLevel? experienceLevel;

  // Safety Fund
  double safetyFundTarget;
  double safetyFundCurrent;

  // Onboarding progress
  bool onboardingComplete;
  DateTime createdAt;

  UserProfile({
    required this.id,
    this.name,
    this.email,
    this.targetAmount,
    this.goalType,
    this.timelineYears,
    this.monthlyIncomeRange,
    this.payFrequency,
    this.monthlyInvestmentBudget,
    this.investmentFrequency = InvestmentFrequency.monthly,
    this.riskTolerance,
    this.experienceLevel,
    this.safetyFundTarget = 5000,
    this.safetyFundCurrent = 0,
    this.onboardingComplete = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Returns expected annual return % based on risk tolerance
  double get expectedReturnRate {
    switch (riskTolerance) {
      case RiskTolerance.low:
        return 0.05; // 4–6%
      case RiskTolerance.medium:
        return 0.085; // 7–10%
      case RiskTolerance.high:
        return 0.125; // 10–15%
      default:
        return 0.085;
    }
  }

  /// Compound interest projection: FV = PV(1+r)^n + PMT * [((1+r)^n - 1) / r]
  double get projectedTotal {
    if (monthlyInvestmentBudget == null || timelineYears == null) return 0;
    final double r = expectedReturnRate / 12; // monthly rate
    final int n = timelineYears! * 12; // total months
    final double pmt = monthlyInvestmentBudget!;
    return pmt * ((((1 + r) * (1 - ((1 + r) * (1 + r) * n))) / (-r)));
    // Simplified: FV of annuity
  }

  /// Simpler, correct compound calculation
  double projectedValue() {
    if (monthlyInvestmentBudget == null || timelineYears == null) return 0;
    final double monthlyRate = expectedReturnRate / 12;
    final int months = timelineYears! * 12;
    double total = 0;
    for (int i = 0; i < months; i++) {
      total = (total + monthlyInvestmentBudget!) * (1 + monthlyRate);
    }
    return total;
  }

  bool get isGoalRealistic {
    if (targetAmount == null) return true;
    return projectedValue() >= targetAmount!;
  }

  /// Monthly investment needed to hit target
  double? requiredMonthlyInvestment() {
    if (targetAmount == null || timelineYears == null) return null;
    final double r = expectedReturnRate / 12;
    final int n = timelineYears! * 12;
    if (r == 0) return targetAmount! / n;
    return (targetAmount! * r) / (((1 + r) * n) - 1);
  }

  /// Year-by-year projection for chart
  List<YearlyProjection> getYearlyProjections() {
    final List<YearlyProjection> projections = [];
    if (monthlyInvestmentBudget == null || timelineYears == null) return [];
    final double monthlyRate = expectedReturnRate / 12;
    double total = 0;
    for (int year = 1; year <= timelineYears!; year++) {
      for (int m = 0; m < 12; m++) {
        total = (total + monthlyInvestmentBudget!) * (1 + monthlyRate);
      }
      projections.add(YearlyProjection(year: year, value: total));
    }
    return projections;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'targetAmount': targetAmount,
        'goalType': goalType?.index,
        'timelineYears': timelineYears,
        'monthlyIncomeRange': monthlyIncomeRange,
        'payFrequency': payFrequency?.index,
        'monthlyInvestmentBudget': monthlyInvestmentBudget,
        'investmentFrequency': investmentFrequency.index,
        'riskTolerance': riskTolerance?.index,
        'experienceLevel': experienceLevel?.index,
        'safetyFundTarget': safetyFundTarget,
        'safetyFundCurrent': safetyFundCurrent,
        'onboardingComplete': onboardingComplete,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        targetAmount: json['targetAmount']?.toDouble(),
        goalType:
            json['goalType'] != null ? GoalType.values[json['goalType']] : null,
        timelineYears: json['timelineYears'],
        monthlyIncomeRange: json['monthlyIncomeRange'],
        payFrequency: json['payFrequency'] != null
            ? PayFrequency.values[json['payFrequency']]
            : null,
        monthlyInvestmentBudget:
            json['monthlyInvestmentBudget']?.toDouble(),
        investmentFrequency:
            InvestmentFrequency.values[json['investmentFrequency'] ?? 2],
        riskTolerance: json['riskTolerance'] != null
            ? RiskTolerance.values[json['riskTolerance']]
            : null,
        experienceLevel: json['experienceLevel'] != null
            ? ExperienceLevel.values[json['experienceLevel']]
            : null,
        safetyFundTarget: json['safetyFundTarget']?.toDouble() ?? 5000,
        safetyFundCurrent: json['safetyFundCurrent']?.toDouble() ?? 0,
        onboardingComplete: json['onboardingComplete'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
      );
}

class YearlyProjection {
  final int year;
  final double value;
  YearlyProjection({required this.year, required this.value});
}
