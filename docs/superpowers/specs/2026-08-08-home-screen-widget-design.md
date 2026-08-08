# Home Screen Widget — Design

Date: 2026-08-08
Status: Approved (user), implemented on `feature/home-screen-widget`

## Goal

Android home screen widget showing today's cigarette count and a "Log
Cigarette" button matching the in-app counter behavior. No new Flutter
dependencies.

## Approach

Pure Kotlin `AppWidgetProvider` + `MethodChannel` sync. Chosen over
`home_widget` plugin (extra dependency, background isolate complexity) and
`flutter_homescreen_widget` (tap opens app, Android 12+ only, battery
overhead).

## Behavior contract

1. Tapping widget button logs a cigarette **without launching the app**:
   native SharedPreferences mirror (`smoke_widget`: `count`, `date_key`)
   increments and the widget refreshes immediately via `AppWidgetManager`.
2. Stale day: if stored `date_key` differs from today, count displays 0, and
   a button press starts a fresh day (count=1, date_key=today).
3. Merge on app open: on first frame and on every app resume
   (`WidgetsBindingObserver`), Flutter reads native state and reconciles the
   higher count for today's key; widget-only presses appear in app logs/stats.
4. Live push: while the app runs, every `logCigarette`/`undoLog` pushes
   today's count to native, keeping the widget in sync.
5. Day rollover without app use: 30-minute `updatePeriodMillis` re-renders
   widget (0 for a new day).

## Native files

- `SmokeWidgetProvider.kt` — AppWidgetProvider, prefs mirror, `ACTION_INCREMENT`
  broadcast, `updateFromApp()` companion.
- `MainActivity.kt` — MethodChannel `smoke_counter/widget`:
  `getState()` → `{count, dateKey}`, `setState(count, dateKey)`.
- `res/layout/smoke_widget.xml` — count, "Cigarettes Today", ember button.
- `res/xml/smoke_widget_info.xml` — 2×1, 30-min update interval, resizable.
- `res/drawable/` `widget_bg.xml`, `widget_button_bg.xml`, `widget_icon.xml`
  (brand: bg #F7F3EE, accent #E8623D).
- `AndroidManifest.xml` — receiver with APPWIDGET_UPDATE + custom action.

## Flutter files

- `lib/core/sync/widget_sync_service.dart` — MethodChannel wrapper + pure
  `reconcile()` decision function (unit-tested).
- `lib/core/sync/widget_sync_bridge.dart` — stateful `WidgetLifecycleObserver`
  mounted in `main.dart`; first-frame + resume sync, cubit stream push
  listener. `LogsCubit` itself stays untouched.

## Release

- `pubspec.yaml` version `1.0.0+1` → `1.1.0+2` (Shorebird release).
- After merge to `development`: user-driven release flow
  `release/1.1.0` → `master` → tag `v1.1.0`. Branch `feature/home-screen-widget`
  is never deleted.

## Testing

- Unit: `reconcile()` (widget-ahead → adopt diff, app-ahead → push, stale
  widget date → reset, equal → none).
- Widget test: bridge wires channel + cubit listener.
- FULL gate before merge: `dart format`, `flutter analyze` (0 issues),
  `flutter test`, `flutter build apk --debug`.