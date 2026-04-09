# WealthPilot — Flutter Starter

> "Your AI guide to smarter investing."

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android

# Run on web (for testing)
flutter run -d chrome
```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── router.dart                        # GoRouter navigation
├── theme/
│   └── app_theme.dart                 # Brand colors, typography, button styles
├── models/
│   ├── user_profile.dart              # Core data model + compound math
│   └── portfolio.dart                 # Portfolio allocations + broker list
├── services/
│   ├── user_profile_provider.dart     # State management (ChangeNotifier)
│   └── notification_service.dart     # Push notification reminders
├── widgets/
│   └── wp_widgets.dart                # Reusable UI components
└── screens/
    ├── onboarding/
    │   ├── splash_screen.dart
    │   ├── welcome_screen.dart
    │   ├── why_wealthpilot_screen.dart
    │   ├── set_goal_screen.dart
    │   ├── set_timeline_screen.dart
    │   ├── risk_tolerance_screen.dart
    │   ├── experience_level_screen.dart
    │   ├── income_screen.dart
    │   ├── investment_budget_screen.dart
    │   ├── safety_fund_screen.dart
    │   └── reality_check_screen.dart
    └── dashboard/
        └── dashboard_screen.dart      # Home, Portfolio, Learn, Profile tabs
```

## ✅ What's Built

- [x] Full onboarding flow (11 screens matching your mockups)
- [x] Compound interest math engine
- [x] Reality Check — realistic vs. unrealistic goal detection
- [x] Risk-based portfolio allocation (Low / Medium / High)
- [x] Broker recommendations by experience level
- [x] Growth projection chart (fl_chart)
- [x] Monthly investment plan breakdown
- [x] AI coaching nudge card
- [x] Learn tab with locked/unlocked lessons
- [x] Persistent storage with SharedPreferences
- [x] Push notification service skeleton
- [x] Brand theme (navy + blue + gold)
- [x] All reusable components (buttons, cards, scaffolds)

---

## 🔧 What You Need to Add

### Priority 1 — Core UX
- [ ] **Hero image** — Add `assets/images/hero_illustration.png` (you have this from ChatGPT)
- [ ] **App icon** — Add your WealthPilot logo to `android/app/src/main/res/` and `ios/Runner/Assets.xcassets/`
- [ ] **Splash screen** — Configure `flutter_native_splash` with navy background + logo
- [ ] **Real notification scheduling** — Wire up monthly reminders using `timezone` package in `notification_service.dart`

### Priority 2 — Missing Screens
- [ ] **Portfolio progress screen** — Show real invested amount vs. projected (needs user to log contributions)
- [ ] **Contribution logging** — Let users mark "I invested this month" to track real progress
- [ ] **Individual learn lesson screens** — Each lesson needs its own detail screen
- [ ] **Account/login screen** — Sign in / Sign up with email or Apple/Google

### Priority 3 — Business Logic
- [ ] **Affiliate broker links** — Replace placeholder URLs in `portfolio.dart` with real affiliate links
- [ ] **AI coaching API** — Replace static coaching messages with real Claude API calls
- [ ] **Country/region selector** — For Ghana, Nigeria, Kenya market localization (brokers change)
- [ ] **Premium paywall** — Freemium gate for advanced projections, custom portfolios

### Priority 4 — Polish
- [ ] **Animations** — Add `flutter_animate` transitions between onboarding screens
- [ ] **Haptic feedback** — Add `HapticFeedback.lightImpact()` on selections
- [ ] **Dark mode** — Add dark theme variant in `app_theme.dart`
- [ ] **Onboarding progress bar** — Show step X of Y at top of onboarding screens

---

## 📦 Dependencies (pubspec.yaml)

| Package | Purpose |
|---|---|
| `provider` | State management |
| `go_router` | Navigation |
| `shared_preferences` | Local data persistence |
| `fl_chart` | Growth projection chart |
| `flutter_animate` | Smooth animations |
| `flutter_local_notifications` | Investment reminders |
| `intl` | Currency formatting |
| `percent_indicator` | Progress bars |

---

## 🎨 Brand Colors

| Name | Hex |
|---|---|
| Primary Navy | `#1A2A6C` |
| Primary Blue | `#2D5BE3` |
| Accent Gold | `#F5A623` |
| Background | `#D6E4F7` |
| Card White | `#FFFFFF` |

---

## 💰 Monetization Hooks (ready to wire up)

1. **Freemium gate** — Premium flag in `UserProfile` model, gate Learn lessons 2+
2. **Affiliate brokers** — Update URLs in `PortfolioService._beginnerBrokers`
3. **AI coaching** — Replace static messages with Claude API for personalized advice

---

*Built for WealthPilot — helping everyday people build real wealth, one step at a time.*
