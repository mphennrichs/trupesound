# Version history for Play/Act with full-snapshot revert

Editing a Play or Act today is destructive with no undo: `updatePlay` overwrites the row on every save, and a mistaken edit during rehearsal (deleting a cue, mangling script text) has no recovery path short of restoring the entire database from a backup. This adds an in-app, per-entity version history for `Play` and `Act` — the two entities that carry the script and soundscape configuration — with the ability to revert to any prior version.

## Decisions

- **Scope**: `Play` and `Act` only. `Sound` is excluded — it's rarely edited in place (replaced/archived instead), so versioning its metadata adds little value.
- **Storage shape**: full-entity snapshots (`before`/`after` as complete JSON), not field-level diffs. Simpler to write, and trivial to revert — restore the `before` snapshot directly — at the cost of the UI computing a visual diff on demand instead of storing one pre-computed. Field-level diffing of nested JSON (`script`, `cues`) would add real complexity for no corresponding benefit here.
- **What triggers a new version**: title/author changes on `Play`; Act create/remove; script text changes; SoundCue add/remove on an `Act`. **Explicitly excluded**: `SoundCue.startMs`/`endMs` (trim) and `SoundCue.hotkey` on existing cues. These are fine-grained, high-frequency adjustments (dragging a trim slider fires a `PATCH` per movement) that would flood the history with noise for a case that rarely needs "undo." The backend compares old vs. new state on each update and only records a version when a tracked field actually changed.
- **Revert restores the full snapshot**, including trim/hotkey values as they were at that point — even though those fields don't trigger new versions on their own, they're still captured inside every snapshot that *is* recorded. Reverting is "go back in time" in full; it can incidentally undo a fine-tuned trim adjustment made since. No selective field-merge on revert — keeps the operation predictable.
- **Revert is itself versioned**: performing a revert creates a new history entry (`action: "revert"`, referencing which version was restored), rather than mutating history or being a one-way trapdoor. This means a revert can always be undone by reverting again to the version that existed right before it.
- **No retention limit** for MVP — history grows unbounded. Given the expected volume (small troupes, few Plays, and trim/hotkey noise already filtered out), this isn't expected to be a problem in practice; revisit if it becomes one.
- **UI placement**: a "History" panel/tab inside the existing Play edit screen, scoped to that Play (including its Acts' changes) — not a separate global audit page. Keeps history contextual to where editing happens.

## Consequences

- New `VersionHistory` table: `entityType` (`"Play" | "Act"`), `entityId`, `action` (`"create" | "update" | "delete" | "revert"`), `before` (Json, nullable), `after` (Json, nullable), `userId`, `createdAt`.
- Every tracked update on `Play`/`Act` now does a before/after comparison against the tracked-field set before deciding whether to write a history row — update use-cases are no longer a simple write-through.
- Depends on [ADR-0001](./0001-self-hosted-jwt-auth.md)'s `User` model for attribution (`userId`); until auth ships, `userId` is `null` on recorded versions, same as the existing `createdBy`/`lastUpdatedBy` fields.
