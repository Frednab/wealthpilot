// lib/models/portfolio.dart

import 'user_profile.dart';

class PortfolioAllocation {
  final String name;
  final double percentage;
  final String description;
  final String ticker; // example ETF/stock
  final String color;

  const PortfolioAllocation({
    required this.name,
    required this.percentage,
    required this.description,
    required this.ticker,
    required this.color,
  });
}

class BrokerRecommendation {
  final String name;
  final String description;
  final String bestFor;
  final String minInvestment;
  final String fees;
  final String affiliateUrl;

  const BrokerRecommendation({
    required this.name,
    required this.description,
    required this.bestFor,
    required this.minInvestment,
    required this.fees,
    required this.affiliateUrl,
  });
}

class PortfolioService {
  /// Returns AI-suggested portfolio based on risk + experience
  static List<PortfolioAllocation> getRecommendedPortfolio(UserProfile profile) {
    switch (profile.riskTolerance) {
      case RiskTolerance.low:
        return _conservativePortfolio;
      case RiskTolerance.high:
        return _aggressivePortfolio;
      default:
        return _balancedPortfolio;
    }
  }

  static List<BrokerRecommendation> getRecommendedBrokers(UserProfile profile) {
    if (profile.experienceLevel == ExperienceLevel.beginner) {
      return _beginnerBrokers;
    }
    return _allBrokers;
  }

  // Conservative: bonds-heavy
  static const List<PortfolioAllocation> _conservativePortfolio = [
    PortfolioAllocation(
      name: 'Bond ETF',
      percentage: 40,
      description: 'Stable income, low volatility',
      ticker: 'BND',
      color: '#2D5BE3',
    ),
    PortfolioAllocation(
      name: 'S&P 500 Index',
      percentage: 35,
      description: 'Broad US market exposure',
      ticker: 'VOO',
      color: '#27AE60',
    ),
    PortfolioAllocation(
      name: 'Dividend Stocks',
      percentage: 15,
      description: 'Regular income + growth',
      ticker: 'VYM',
      color: '#F5A623',
    ),
    PortfolioAllocation(
      name: 'Cash / HYSA',
      percentage: 10,
      description: 'Emergency & opportunity fund',
      ticker: 'CASH',
      color: '#95A5A6',
    ),
  ];

  // Balanced
  static const List<PortfolioAllocation> _balancedPortfolio = [
    PortfolioAllocation(
      name: 'S&P 500 Index',
      percentage: 50,
      description: 'Core US market growth',
      ticker: 'VOO',
      color: '#2D5BE3',
    ),
    PortfolioAllocation(
      name: 'Tech ETF',
      percentage: 25,
      description: 'High-growth tech exposure',
      ticker: 'QQQ',
      color: '#27AE60',
    ),
    PortfolioAllocation(
      name: 'Dividend Stocks',
      percentage: 15,
      description: 'Regular passive income',
      ticker: 'VYM',
      color: '#F5A623',
    ),
    PortfolioAllocation(
      name: 'Cash / HYSA',
      percentage: 10,
      description: 'Stability buffer',
      ticker: 'CASH',
      color: '#95A5A6',
    ),
  ];

  // Aggressive: growth-heavy
  static const List<PortfolioAllocation> _aggressivePortfolio = [
    PortfolioAllocation(
      name: 'Tech ETF',
      percentage: 40,
      description: 'High-growth tech',
      ticker: 'QQQ',
      color: '#2D5BE3',
    ),
    PortfolioAllocation(
      name: 'S&P 500 Index',
      percentage: 30,
      description: 'Broad market anchor',
      ticker: 'VOO',
      color: '#27AE60',
    ),
    PortfolioAllocation(
      name: 'International ETF',
      percentage: 20,
      description: 'Global diversification',
      ticker: 'VXUS',
      color: '#F5A623',
    ),
    PortfolioAllocation(
      name: 'Small Cap',
      percentage: 10,
      description: 'High upside potential',
      ticker: 'VB',
      color: '#9B59B6',
    ),
  ];

  static const List<BrokerRecommendation> _beginnerBrokers = [
    BrokerRecommendation(
      name: 'Fidelity',
      description: 'Best overall for beginners. No account minimums, excellent education.',
      bestFor: 'Long-term investing & retirement',
      minInvestment: '\$0',
      fees: '\$0 commissions',
      affiliateUrl: 'https://fidelity.com',
    ),
    BrokerRecommendation(
      name: 'Charles Schwab',
      description: 'Great for ETF investing with strong research tools.',
      bestFor: 'ETFs & index funds',
      minInvestment: '\$0',
      fees: '\$0 commissions',
      affiliateUrl: 'https://schwab.com',
    ),
    BrokerRecommendation(
      name: 'M1 Finance',
      description: 'Automates portfolio investing. Perfect for set-and-forget.',
      bestFor: 'Automated monthly investing',
      minInvestment: '\$100',
      fees: 'Free (premium available)',
      affiliateUrl: 'https://m1finance.com',
    ),
  ];

  static const List<BrokerRecommendation> _allBrokers = [
    ..._beginnerBrokers,
    BrokerRecommendation(
      name: 'Interactive Brokers',
      description: 'Professional-grade platform for serious investors.',
      bestFor: 'Advanced trading & international',
      minInvestment: '\$0',
      fees: 'Very low',
      affiliateUrl: 'https://interactivebrokers.com',
    ),
  ];
}
