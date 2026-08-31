# LibasAI

An AI-powered, multi-agent conversational shopping assistant for Pakistani apparel brands — a
Final Year Project at FAST-NUCES (session 2026–2027).

LibasAI is a **discovery-and-redirect** platform: users search, compare, and get recommendations
in-app, then are redirected to a brand's own site to complete the purchase. There is no in-app
checkout, payment, or order management.

## This repository

The Flutter client — a high-fidelity build of the 40-screen mobile prototype from the design
handoff. Android-first, with the web target used for quick preview.

### Tech

| Layer | Choice |
|---|---|
| Framework | Flutter (Android-first, web preview) |
| State | single app-wide `ChangeNotifier` (`AppState`) exposed via `InheritedNotifier` |
| Navigation | `Navigator` named routes (see `lib/main.dart`) |
| Fonts | Playfair Display + Manrope via `google_fonts` |

### Layout

```
lib/
  theme.dart        design tokens, typography, ThemeData
  data.dart         Product/Brand models, sample catalogue, AppState store
  app_scope.dart    AppScope (InheritedNotifier) + nav helpers
  widgets.dart      shared UI: ScreenHeader, LibasBottomNav, ProductCard, chips, placeholders
  ios_frame.dart    status bar / home indicator; phone frame on wide screens
  main.dart         MaterialApp + route table
  screens/          all 40 screens, grouped by flow
```

## Running

```bash
flutter pub get
flutter run                 # attached device / emulator
flutter run -d chrome       # web preview
```

### On a physical Android device over Wi-Fi

```bash
adb pair <ip>:<pair-port> <code>      # one time, from the phone's Wireless debugging screen
adb connect <ip>:<connect-port>
flutter run
```

> On low-RAM machines, close the IDE / spare browser tabs during the first Android build and set
> `DART_VM_OPTIONS=--old_gen_heap_size=3072`. `android/gradle.properties` is already tuned for ~8 GB.

## Status

UI only. Sample data is hard-coded in `lib/data.dart`; the FastAPI backend, recommendation engine,
and live catalogue are separate work.
