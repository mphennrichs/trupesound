# Development Guide: UI & Architecture Patterns

This document outlines the patterns and structures used in the TrupeSound frontend to ensure consistency across pages and widgets.

For domain terminology (Play, Act, SoundCue, etc.) refer to [`CONTEXT.md`](../../CONTEXT.md) at the project root.

## 1. Architectural Principles
- **Navigation:** Use `go_router`. Always reference routes via the `NavigationPage` enum found in `lib/common/navigation_pages_enum.dart` using `context.goNamed(...)`.
- **Internationalization:** Never hardcode strings. Use `AppLocalizations.of(context)!.key` from `lib/l10n/app_localizations.dart`.
- **Theming:** All styling must come from `AppThemes` in `lib/common/app_themes.dart`. Avoid hardcoded colors, spacings, or text styles.

## 2. Page Structure Pattern
Standard pages should follow this hierarchical structure to ensure correct background rendering and scroll behavior:

```dart
class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppThemes.colors.backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: AppThemes.spacings.doubleValue,
          horizontal: AppThemes.spacings.doubleValue,
        ),
        child: const Center(
          child: Column(
            children: [
              // Page Content
            ],
          ),
        ),
      ),
    );
  }
}
```

## 3. Styling Guidelines
- **Colors:** Use `AppThemes.colors`. The primary brand color is a deep purple (`#5417cf`).
- **Spacing:** Use `AppThemes.spacings`. Common values include `doubleValue` for standard page margins.
- **Buttons:** Use `AppThemes.buttons.primaryButtonStyle` for main actions.
- **Typography:** Use `AppThemes.colors.textColor` for standard labels. Headers typically use a font size of `24`.

## 4. Widget Best Practices
- **Helper Methods:** For complex UI components within a page (like a specific button or a header), extract them into private helper methods (e.g., `Widget _buildHeader()`) to keep the `build` method clean.
- **Immutability:** Use `const` constructors whenever possible to optimize Flutter's rebuild performance.
- **Desktop/Web Layout:** Note that the mockups suggest a "Glassmorphism" aesthetic for overlays (blur and semi-transparent borders). Use `BackdropFilter` and `BoxDecoration` with `RGBA` colors to match the web mockups.

## 5. Mockup Synchronization (Cuesmith)
When implementing the "Cuesmith" editor features:
- **Guide Lines:** Active insertion points should use the primary purple color with a subtle outer glow (shadow).
- **Icons:** Use `Material Symbols Outlined` with specific variations:
  - `waves` for branding.
  - `queue_music`, `tune`, `history` for sidebar navigation.
  - `add` for cue insertion.

## 6. Data Handling (Riverpod)
When fetching data from providers, follow the `AsyncValue` pattern to handle states consistently:
- **Loading:** Use a `CircularProgressIndicator` or `Shimmer` effect.
- **Error:** Display a user-friendly message using the localized strings.
- **Data:** Map the list to the corresponding grid/list widgets.
- **Empty Check:** Always check `isLoading` **before** checking if the data list is empty to prevent visual flickers of "No Data" UI during initial loads.
 - **Form Navigation:** After successful submission, differentiate navigation: "Edit" usually returns to the list view (`NavigationPage.plays`), while "Create" usually proceeds to the editor/playback view (`NavigationPage.playSoundscape`).

Example:
```dart
final dataAsync = ref.watch(yourProvider);
return dataAsync.when(
  data: (items) => YourGrid(items),
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (err, stack) => Center(child: Text('Error: $err')),
);
```

## 7. Layer Architecture

Every feature follows a strict 3-layer pattern. Widgets never call services directly.

```
Widget
  └── watches/calls → Provider  (lib/pages/<feature>/provider/)
        └── calls → Service     (lib/pages/<feature>/service/)
              └── calls → REST API (or in-memory stub during development)
```

**Providers** own all state and business logic. Use `@riverpod` annotation with code generation. All provider files must have a corresponding `.g.dart` part file — run `flutter pub run build_runner build` after changes.

**Services** handle API communication only. No state. No UI logic.

**Current backend status:** the backend is not ready. All services use in-memory maps to simulate API calls — this is intentional and must be kept until the backend is available. Do not add Dio, `fromJson`/`toJson`, or any HTTP calls. New features should follow the same in-memory pattern as `PlayRepository`.

## 8. Internationalization (i18n)

**Every user-facing string must be defined in the ARB files.** Never hardcode strings directly in widget code.

### Adding a new string

1. Add the key to `lib/l10n/app_en.arb`:
```json
"myNewKey": "My English text",
"@myNewKey": {}
```

2. Add the Portuguese translation to `lib/l10n/app_pt.arb`:
```json
"myNewKey": "Meu texto em português",
"@myNewKey": {}
```

3. Regenerate the localization class:
```sh
flutter gen-l10n
```

4. Use it in widgets via `AppLocalizations.of(context)!.myNewKey`.

### Rules
- This applies to **all** user-visible text: labels, hints, placeholders, button text, error messages, tooltips, and dialog content.
- Exception: strings that never reach the user (developer logs, exception messages thrown inside services) do not need ARB entries.
- After adding keys, always run `flutter gen-l10n` before referencing the new key in code — the generated class won't have the getter until then.
- Both ARB files must be updated together. A key present in `app_en.arb` but missing from `app_pt.arb` will generate a build warning.

## 10. Naming Conventions

| Artifact | Convention | Example |
|---|---|---|
| Page widget | `<Feature>Page` | `PlaysPage`, `SoundLibraryPage` |
| Page file | `<feature>_page.dart` | `plays_page.dart` |
| Provider class | `<Feature>` (Riverpod generates `<feature>Provider`) | `class Plays` → `playsProvider` |
| Service class | `<Feature>Service` | `PlayService` |
| Model class | `<Entity>Model` or plain `<Entity>` | `ActModel`, `Play`, `SoundModel` |
| Custom shared widgets | `custom_<name>.dart` in `lib/pages/custom/` | `custom_app_bar.dart` |
| Page-specific widgets | `lib/pages/<feature>/widgets/<name>.dart` | `cue_play_card.dart` |

## 11. Project Configuration
- **Analysis:** Follow the rules in `analysis_options.yaml` (currently extending `flutter_lints`).
- **Code generation:** Run `flutter pub run build_runner build --delete-conflicting-outputs` after adding or modifying any `@riverpod` provider.
- **Platform target:** Web (primary). Windows and Linux are configured but not the active target.