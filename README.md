# MAD - Riphah Student Portal

A Flutter Student Portal with local demo accounts, individual student profiles, a shared purple Material 3 theme and interactive animations.

## Demo accounts

| Student | University email | Demo password | Profile image |
| --- | --- | --- | --- |
| Muhammad Zain Khan | 66157@students.riphah.edu.pk | 1234 | `image/img.png` |
| Sameer Abdullah | 64860@students.riphah.edu.pk | 1234 | `image/profile.jpg` |

Email matching ignores surrounding whitespace and letter case. Passwords must match exactly. Unknown accounts and wrong passwords receive the same friendly error message.

This is a local teaching demonstration: the accounts are hard-coded and are not connected to the university or a production authentication service.

## Student Portal features

- Curved purple gradient login header with a university portal icon.
- Inline email/password validation, password visibility toggle, keyboard Next → Done flow and a guarded loading state.
- Each account opens its own name, photograph, SAP ID, email and introduction.
- Compact profile with Role, SAP ID, Email, University, Program, Semester and About me.
- Semester is shown as **Not specified** until the actual value is supplied.
- Logout confirmation; switching accounts creates a fresh profile screen and clears the old navigation history.
- A separate **Projects** screen preserves skills, contact phone and the Fee, Attendance and Inventory Management System portfolio entries.
- One shared theme for colors, cards, inputs, buttons and dialogs.
- A phone-frame preview on larger Chrome windows.

The management systems are portfolio entries rather than functional management modules.

## HCI and animations

Visible field labels, recognizable icons, actionable validation messages, a visible loading state and 48-pixel button targets support consistency, recognition over recall and accessible interaction. Passive information rows use smaller text and compact spacing; content can scroll on smaller screens or when expanded.

- **AnimatedContainer:** tap the profile photograph to enlarge it from 110 to 150 logical pixels; card padding and tone animate too.
- **AnimatedOpacity:** **Hide / Show** fades personal information between full visibility and 0% opacity. Hidden content cannot receive taps or screen-reader focus.
- **AnimatedCrossFade:** **Read more / Show less** transitions between the short and full introduction.
- **PageRouteBuilder + FadeTransition:** profile, login and project navigation use smooth fades.
- Transitions last 400 milliseconds and respect the device's reduced-motion setting.

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

Tests cover both accounts, invalid credentials, isolation when switching students, loading state, password and keyboard controls, logout confirmation, animations, projects and reduced motion on a narrow screen.

## Project structure

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | App entry point |
| `lib/theme/app_theme.dart` | Shared palette and component themes |
| `lib/models/student.dart` | Immutable student profile model |
| `lib/data/student_accounts.dart` | Hard-coded demo accounts |
| `lib/screens/` | Login, student profile and skills/projects |
| `lib/navigation/fade_route.dart` | Page fade and reduced-motion helpers |
| `lib/widgets/mobile_preview.dart` | Web phone-frame preview |
| `image/` | Student photographs |
| `test/widget_test.dart` | Portal behavior and animation tests |
| `output/linkedin/` | Earlier showcase images, captions and prompts |

The existing LinkedIn images show earlier app versions. Build output, SDK caches, IDE settings and local configuration are excluded from Git.