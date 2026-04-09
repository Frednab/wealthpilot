// lib/screens/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/portfolio.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/wp_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    final profile = provider.profile;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: WealthPilotTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: WealthPilotTheme.backgroundLight,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${profile.name ?? 'Investor'} 👋',
              style: const TextStyle(
                fontSize: 16,
                color: WealthPilotTheme.textGray,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Text(
              'WealthPilot',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: WealthPilotTheme.primaryNavy,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: WealthPilotTheme.primaryNavy),
            onPressed: () {
              // TODO: Notifications screen
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentTab,
        children: [
          _HomeTab(profile: profile),
          _PortfolioTab(profile: profile),
          _LearnTab(),
          _SettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: WealthPilotTheme.primaryNavy,
        unselectedItemColor: WealthPilotTheme.textGray,
        backgroundColor: WealthPilotTheme.cardWhite,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline), label: 'Portfolio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined), label: 'Learn'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─── Home Tab ───────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final UserProfile profile;
  const _HomeTab({required this.profile});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final projected = profile.projectedValue();
    final projections = profile.getYearlyProjections();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal Progress Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  WealthPilotTheme.primaryNavy,
                  WealthPilotTheme.primaryBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Goal',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  formatter.format(profile.targetAmount ?? 0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GoalStat(
                      label: 'Projected',
                      value: formatter.format(projected),
                    ),
                    _GoalStat(
                      label: 'Timeline',
                      value: '${profile.timelineYears ?? 0} yrs',
                    ),
                    _GoalStat(
                      label: 'Monthly',
                      value: formatter.format(
                          profile.monthlyInvestmentBudget ?? 0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Projection Chart
          if (projections.isNotEmpty) ...[
            const Text('Growth Projection',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: WealthPilotTheme.textDark)),
            const SizedBox(height: 12),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: WealthPilotTheme.cardWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _ProjectionChart(projections: projections),
            ),
            const SizedBox(height: 20),
          ],

          // Monthly Action Plan
          const Text('This Month\'s Plan',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: WealthPilotTheme.textDark)),
          const SizedBox(height: 12),
          _MonthlyPlanCard(profile: profile),
          const SizedBox(height: 20),

          // Coaching nudge
          _CoachingCard(profile: profile),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _GoalStat extends StatelessWidget {
  final String label;
  final String value;
  const _GoalStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ],
    );
  }
}

class _ProjectionChart extends StatelessWidget {
  final List<YearlyProjection> projections;
  const _ProjectionChart({required this.projections});

  @override
  Widget build(BuildContext context) {
    final spots = projections
        .map((p) => FlSpot(p.year.toDouble(), p.value / 1000))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value % 5 != 0) return const SizedBox();
                return Text('Yr ${value.toInt()}',
                    style: const TextStyle(
                        fontSize: 10, color: WealthPilotTheme.textGray));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: WealthPilotTheme.primaryBlue,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: WealthPilotTheme.primaryBlue.withOpacity(0.1),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

class _MonthlyPlanCard extends StatelessWidget {
  final UserProfile profile;
  const _MonthlyPlanCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final allocations =
        PortfolioService.getRecommendedPortfolio(profile);
    final budget = profile.monthlyInvestmentBudget ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WealthPilotTheme.cardWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: allocations.map((a) {
          final amount = budget * (a.percentage / 100);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(
                        int.parse(a.color.replaceFirst('#', '0xFF'))),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(a.name,
                        style: const TextStyle(
                            color: WealthPilotTheme.textDark))),
                Text('${a.percentage.toInt()}%',
                    style: const TextStyle(
                        color: WealthPilotTheme.textGray, fontSize: 13)),
                const SizedBox(width: 12),
                Text(
                  formatter.format(amount),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: WealthPilotTheme.primaryNavy),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CoachingCard extends StatelessWidget {
  final UserProfile profile;
  const _CoachingCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final messages = [
      '📈 Stay consistent — compounding rewards patience.',
      '🧘 Market dips are normal. Don\'t panic sell.',
      '🎯 You\'re building real wealth. Keep going.',
      '💡 Time in market beats timing the market.',
    ];
    final msg = messages[DateTime.now().day % messages.length];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WealthPilotTheme.primaryNavy.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: WealthPilotTheme.primaryNavy.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          const Text('🤖', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('WealthPilot Coach',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: WealthPilotTheme.primaryNavy,
                        fontSize: 13)),
                const SizedBox(height: 4),
                Text(msg,
                    style: const TextStyle(
                        color: WealthPilotTheme.textGray, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Portfolio Tab ────────────────────────────────────────────────────────────

class _PortfolioTab extends StatelessWidget {
  final UserProfile profile;
  const _PortfolioTab({required this.profile});

  @override
  Widget build(BuildContext context) {
    final allocations = PortfolioService.getRecommendedPortfolio(profile);
    final brokers = PortfolioService.getRecommendedBrokers(profile);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recommended Portfolio',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: WealthPilotTheme.textDark)),
          Text(
            'Based on your ${profile.riskTolerance?.name ?? 'balanced'} risk profile',
            style: const TextStyle(
                color: WealthPilotTheme.textGray, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Allocation cards
          ...allocations.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: WealthPilotTheme.cardWhite,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                                  a.color.replaceFirst('#', '0xFF')))
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(a.ticker,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Color(int.parse(
                                  a.color.replaceFirst('#', '0xFF'))),
                            )),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: WealthPilotTheme.textDark)),
                            Text(a.description,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: WealthPilotTheme.textGray)),
                          ],
                        ),
                      ),
                      Text('${a.percentage.toInt()}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: WealthPilotTheme.primaryNavy)),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: 24),
          const Text('Recommended Brokers',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: WealthPilotTheme.textDark)),
          const SizedBox(height: 12),

          // Broker cards
          ...brokers.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: WealthPilotTheme.cardWhite,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(b.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: WealthPilotTheme.textDark)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: WealthPilotTheme.successGreen
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(b.fees,
                                style: const TextStyle(
                                    color: WealthPilotTheme.successGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(b.description,
                          style: const TextStyle(
                              fontSize: 13,
                              color: WealthPilotTheme.textGray)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 14,
                              color: WealthPilotTheme.successGreen),
                          const SizedBox(width: 4),
                          Text('Best for: ${b.bestFor}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: WealthPilotTheme.textGray)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Open affiliate URL
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 40),
                          ),
                          child: Text('Open ${b.name}'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Learn Tab ────────────────────────────────────────────────────────────────

class _LearnTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lessons = [
      ('🏦', 'What is Compound Interest?', 'The 8th wonder of the world'),
      ('📊', 'Index Funds Explained', 'Why Warren Buffett recommends them'),
      ('🛡️', 'Building an Emergency Fund', 'Your financial safety net'),
      ('📈', 'Dollar-Cost Averaging', 'Investing without timing the market'),
      ('🌍', 'Diversification 101', 'Don\'t put all eggs in one basket'),
      ('💸', 'Avoiding Lifestyle Inflation', 'Grow wealth, not expenses'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Investing Fundamentals',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: WealthPilotTheme.textDark)),
          const SizedBox(height: 4),
          const Text('Build your knowledge step by step',
              style:
                  TextStyle(color: WealthPilotTheme.textGray, fontSize: 13)),
          const SizedBox(height: 16),
          ...lessons.asMap().entries.map((e) {
            final idx = e.key;
            final lesson = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WealthPilotTheme.cardWhite,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(lesson.$1, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lesson.$2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: WealthPilotTheme.textDark)),
                          Text(lesson.$3,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: WealthPilotTheme.textGray)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: idx == 0
                            ? WealthPilotTheme.primaryBlue
                            : WealthPilotTheme.backgroundLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        idx == 0 ? Icons.play_arrow : Icons.lock_outline,
                        size: 16,
                        color: idx == 0
                            ? Colors.white
                            : WealthPilotTheme.textGray,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Settings Tab ─────────────────────────────────────────────────────────────

class _SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Profile & Settings',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: WealthPilotTheme.textDark)),
          const SizedBox(height: 16),
          _SettingsTile(
              icon: Icons.flag_outlined,
              label: 'Update My Goal',
              onTap: () => context.push('/onboarding/goal')),
          _SettingsTile(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Update Budget',
              onTap: () => context.push('/onboarding/budget')),
          _SettingsTile(
              icon: Icons.notifications_outlined,
              label: 'Notification Preferences',
              onTap: () {}),
          _SettingsTile(
              icon: Icons.security_outlined,
              label: 'Privacy & Security',
              onTap: () {}),
          _SettingsTile(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () {}),
          const SizedBox(height: 20),
          WPOutlinedButton(
            label: 'Reset Onboarding',
            onPressed: () async {
              await context.read<UserProfileProvider>().resetProfile();
              context.go('/welcome');
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: WealthPilotTheme.backgroundLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: WealthPilotTheme.primaryNavy, size: 20),
      ),
      title: Text(label,
          style: const TextStyle(
              color: WealthPilotTheme.textDark,
              fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right,
          color: WealthPilotTheme.textGray),
      onTap: onTap,
    );
  }
}
