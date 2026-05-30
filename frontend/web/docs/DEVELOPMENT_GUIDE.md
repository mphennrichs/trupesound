# Development Guide: UI & Architecture Patterns

This document outlines the patterns and structures used in the TrupeSound (Cuesmith) frontend to ensure consistency across pages and widgets.

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

## 7. Project Configuration
- **Analysis:** Follow the rules in `analysis_options.yaml` (currently extending `flutter_lints`).
- **Platform Support:** 
  - **Windows:** Configured for C++17 with Unicode support.
  - **Linux:** Configured for GTK3 using C++14.
```

### Summary of Findings & Suggestions

1.  **State Management:** Based on `soundscape_play_page.dart`, you are using `StatelessWidget`. As the application grows (e.g., the Cuesmith editor from the mockup), you will likely need a state management solution like `Provider`, `Riverpod`, or `Bloc`.
2.  **Theme Consistency:** You've done a great job centralizing the theme in `AppThemes`. Ensure that any "Glass" effects seen in the HTML mockups (the `glass-panel` class) are added to `AppThemes` as a reusable `BoxDecoration` or a custom `GlassCard` widget.
3.  **Naming Convention:** You are using a clear naming convention: `<feature>_<subfeature>_page.dart`. Stick to this to keep the `lib/pages` directory organized.

<!--
[PROMPT_SUGGESTION]Create a reusable GlassCard widget in Flutter that matches the glass-panel style in the HTML mockup.[/PROMPT_SUGGESTION]
[PROMPT_SUGGESTION]Update the DEVELOPMENT_GUIDE.md to include a section on how to handle responsive layouts for desktop and web.[/PROMPT_SUGGESTION]
->