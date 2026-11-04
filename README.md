# MAD - Riphah Student Portfolio

A Flutter student portfolio with two local demo accounts, individual student profiles, a shared purple and lavender Material 3 theme, and interactive animations.

## Demo accounts

| Student | University email | Password | Profile image |
| --- | --- | --- | --- |
| Muhammad Zain Khan | 66157@students.riphah.edu.pk | 1234 | `image/img.png` |
| Sameer Abdullah | 64860@students.riphah.edu.pk | 1234 | `image/profile.jpg` |

Sign in with the university email or the numeric SAP ID. Email matching ignores surrounding whitespace and letter case; passwords must match exactly. Unknown accounts and wrong passwords receive the same friendly error message.

These hard-coded accounts are for a local teaching demonstration. They are not connected to a university authentication service.

## Interface and features

- A flat lavender login screen with Riphah branding, the heading **Your portfolio, all in one place**, and an **Open my portfolio** button.
- A centered photograph, student name, program and email on a purple gradient profile card.
- About me, Skills, My projects and Personal information cards on the same scrollable portfolio page.
- A fixed bottom navigation bar with **Profile, Skills, Projects and Info** shortcuts. Tapping a destination scrolls to that section, and the selected destination follows manual scrolling. Expanded photos and introductions keep their state.
- Inline validation, password visibility, keyboard Next → Done flow and a guarded loading spinner.
- Separate profile data and photographs for both students, plus logout confirmation.
- Role, SAP ID, email, university, program, semester and phone in Personal information; tap a detail to copy it.
- Both students are in the **5th semester**.
- Portfolio entries for Fee, Attendance and Inventory Management Systems. These are showcase entries, rather than functional management modules.
- A shared theme for colors, cards, inputs, buttons and dialogs.
- A phone-frame preview on larger Chrome windows.

## Animations

- **AnimatedContainer:** tap the profile card to animate its padding, purple tone and photograph from 110 to 150 logical pixels; tap again to collapse it.
- **AnimatedOpacity:** **Hide / Show** fades personal information between full visibility and 0% opacity. Hidden details cannot receive taps or screen-reader focus.
- **AnimatedCrossFade:** **Read more / Show less** switches between the short and full introduction.
- **PageRouteBuilder + FadeTransition:** login and logout use smooth fades.
- Animations last 400 milliseconds and respect the device's reduced-motion setting.

## Run locally

Install Flutter with a Dart SDK compatible with `^3.13.1`, then:

```sh
git clone https://github.com/itx-Samii/MAD.git
cd MAD
flutter pub get
flutter run -d chrome
```

Use `flutter devices` and `flutter run -d <device-id>` for another device.

## Check the project

```sh
flutter analyze
flutter test
```

Tests cover both accounts, SAP ID aliases, invalid credentials, account switching, loading state, keyboard/password controls, logout, animations, inline projects and reduced motion on narrow screens.

## Project structure

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | App entry point |
| `lib/theme/app_theme.dart` | Shared palette and component themes |
| `lib/models/student.dart` | Immutable profile model |
| `lib/data/student_accounts.dart` | Local demo accounts |
| `lib/screens/` | Login and student portfolio |
| `lib/navigation/fade_route.dart` | Route fade and reduced-motion helpers |
| `lib/widgets/portfolio_sections.dart` | Shared portfolio cards, skills and projects |
| `lib/widgets/mobile_preview.dart` | Web phone-frame preview |
| `image/` | Student photographs |
| `test/widget_test.dart` | Account, form and animation tests |
| `output/linkedin/` | Showcase images, captions and prompts |

Build output, SDK caches, IDE settings and local configuration are excluded from Git.
