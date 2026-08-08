# Smoke Counter — Flutter implementation brief

Paste this whole brief to the coding agent as its task.

## 1. What we're building

**Smoke Counter** — a minimal Flutter app that logs how many cigarettes the user smokes per day, and shows simple stats and spend. Three screens total, plus a one-screen onboarding:

1. **Onboarding** (shown once) — asks the user how much a pack costs, saves it, then goes to the Counter screen.
2. **Counter screen** — today's count, a big button to log a cigarette.
3. **Statistics screen** — summary row (cig/day, cig/month, total spent) + one tile per day.
4. **Settings screen** — currently just the pack price, editable.

## 2. Tech stack

- Flutter, latest stable
- State management + local persistence: **hydrated_bloc** (`flutter_bloc` + `hydrated_bloc`)
- `equatable` for state/model equality
- `path_provider` (required for `HydratedStorage` to locate a writable directory)
- `intl` for date formatting

`HydratedStorage` must be initialized in `main()` **before** `runApp()`, using `getApplicationDocumentsDirectory()` from `path_provider`, e.g.:

```dart
WidgetsFlutterBinding.ensureInitialized();
HydratedBloc.storage = await HydratedStorage.build(
  storageDirectory: HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
);
```

## 3. Git workflow — mandatory, follow exactly

- `development` already exists locally, branched from `master`. Work from `development`, never from `master`.
- **The agent must never merge anything into `master`, under any circumstance, for any reason, even if asked mid-task.** `master` is off-limits for the whole session.
- For every screen/feature:
  1. `git checkout development`
  2. `git checkout -b feature/<name>`
  3. Implement and test that one feature only, on that branch.
  4. Commit in small, logical, well-described commits (e.g. `feat: add DailyLog model and LogsCubit`, not one giant commit).
  5. When the feature works: `git checkout development`, `git merge --no-ff feature/<name>`, **keep the feature branch** (do not delete).
  6. Branch again from the now-updated `development` for the next feature.
- Suggested branch order:
  1. `feature/project-setup` — Flutter project scaffold, dependencies, folder structure, theme, app icon.
  2. `feature/data-layer` — models + hydrated cubits (`LogsCubit`, `SettingsCubit`), no UI yet.
  3. `feature/onboarding-screen`
  4. `feature/counter-screen`
  5. `feature/statistics-screen`
  6. `feature/settings-screen`
  7. `feature/polish` — navigation wiring between all screens, empty states, final theming pass (optional, only if something was left rough).
- After each merge to `development`, give a short summary of what was implemented before starting the next branch.

## 4. Data model

- `DailyLog`: date key (`yyyy-MM-dd` string) → cigarette count (`int`). Store as `Map<String, int>` inside a `HydratedCubit<Map<String, int>>` (`LogsCubit`), or as a `List<DailyLog>` if that reads cleaner — agent's call, keep it simple.
- `AppSettings`: `packPrice` (`double`), `cigarettesPerPack` (`int`, default `20`, not user-facing yet but keep it as a field for future settings). Store in `HydratedCubit<AppSettings>` (`SettingsCubit`).
- Cost per cigarette = `packPrice / cigarettesPerPack`.

## 5. App flow

- On launch, check `SettingsCubit.state.packPrice`. If it's null/unset → show Onboarding. Otherwise → go straight to the main app (Counter screen).
- After onboarding is completed once, it must never show again (this falls out naturally from checking `packPrice`, since it's persisted by hydrated_bloc).
- Main app: Counter and Statistics are the two primary screens (bottom navigation bar with 2 tabs is fine). Settings is reached via an icon button in the app bar, not a third tab — keep it minimal per the spec.

## 6. Screens

### Onboarding
- Centered layout: app logo, a short headline asking how much a pack costs, a numeric text field (currency), a continue button.
- On submit: save `packPrice` via `SettingsCubit`, then navigate to the Counter screen, replacing the route so onboarding isn't reachable via back button.

### Counter screen
- Today's date at the top.
- Large, prominent count of cigarettes logged today.
- Large primary button to log one cigarette (increments today's count in `LogsCubit`).
- A smaller undo control (e.g. long-press, or a small "−1" button) to correct accidental taps — don't make decrementing as easy/prominent as incrementing.
- Today's spend so far (`todayCount × costPerCigarette`), shown below the counter.

### Statistics screen
- Summary row at the top with three stat cards:
  - **Cig/day** — average cigarettes per day across all logged days.
  - **Cig/month** — total cigarettes logged in the current calendar month.
  - **Spent until now** — total cigarettes ever logged × current cost per cigarette.
  
  (These definitions are a reasonable default — flag it to the user if they'd rather define "cig/month" as a 30-day average instead of current-month total; either is a small change.)
- Below the summary: a scrollable list, most recent day first, one tile per day showing the date (formatted, e.g. "Mon, Aug 4") and that day's cigarette count.
- Empty state (no logs yet) instead of a blank list.

### Settings screen
- One field: pack price, editable, saved immediately to `SettingsCubit` on change/submit.
- Keep the layout roomy enough that more settings can be added later without a redesign.

## 7. Theme — use these exact colors

Material 3 `ColorScheme`, built from:

| Role | Color | Hex |
|---|---|---|
| Primary (ember) | burnt orange | `#E8623D` |
| Secondary / dark surface (charcoal) | near-black grey | `#33363A` |
| Background (light mode) | warm off-white | `#F7F3EE` |
| Muted / secondary text (smoke grey) | mid grey | `#9B9D9F` |
| Positive accent (sage) — e.g. under-budget, good trend | muted green | `#6B9080` |
| Alert accent — e.g. over a self-set limit | muted red | `#C1483B` |

Dark mode: background `#1C1E20`, surface `#26292C`, primary text `#F0EDE8`, keep ember `#E8623D` as the primary accent in both modes.

Use ember only for the primary action (the "log a cigarette" button, key CTAs) — don't tint the whole UI orange. Sage/alert are for statistics coloring (e.g. a day tile could lean sage or alert depending on whether it's below/above the user's daily average), used sparingly.

## 8. Suggested folder structure

```
lib/
  core/
    theme/            # ColorScheme, ThemeData
    constants.dart
  data/
    models/           # DailyLog, AppSettings
    cubits/           # LogsCubit, SettingsCubit (hydrated_bloc)
  features/
    onboarding/
    counter/
    statistics/
    settings/
  main.dart
```

## 9. Definition of done, per branch

- `project-setup`: app builds and runs on at least one platform, theme applied, no screens wired yet beyond a placeholder.
- `data-layer`: cubits compile, persist correctly across a hot restart (verify by logging a value, restarting, confirming it's still there), covered by at least a couple of basic unit tests if time allows.
- `onboarding-screen`: entering a price and continuing persists it and never shows onboarding again on relaunch.
- `counter-screen`: tapping logs a cigarette for today, count and spend update live, undo works.
- `statistics-screen`: summary numbers and tiles reflect real logged data, empty state works with no data.
- `settings-screen`: editing pack price updates future cost calculations app-wide.

## 10. Final note to the agent

Work branch by branch, in the order above, following the git workflow in section 3 exactly — especially the rule that `master` is never touched. If any requirement above is ambiguous once you're implementing it, make the simplest reasonable choice, note the assumption in the merge summary, and keep moving.
