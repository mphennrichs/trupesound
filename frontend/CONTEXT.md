# TrupeSound — Domain Glossary

This file is the single source of truth for domain terminology. Implementation details do not belong here.

---

## Core Entities

**Play**
A theatrical production managed by the app. Has a title, author, and is composed of one or more Acts. A Play is the top-level unit of work.

**Act**
A named division of a Play (e.g., Act 1, Scene 2). Contains a Script and a list of Sound Cues. Acts are ordered by `number`.

**Script**
The ordered list of ScriptLines belonging to an Act. Represents the text of the theatrical script for that Act.

**ScriptLine**
A single line of dialogue or stage direction within a Script. Identified by `lineNumber` (1-based, sequential, no gaps). ScriptLines and SoundCues share the same line-number space within an Act.

**SoundCue**
A sound trigger anchored to a position (line number) in an Act's script. Carries a reference to a Sound, a Hotkey for manual triggering, and a PlayMode. Sound Cues are part of the Soundscape of a Play.

**Sound**
An audio file stored in the Sound Library. Has a name, Category, duration, and a URL pointing to the audio asset.

**Sound Library**
The collection of all Sounds available in the application. Sounds are global — not bound to any specific Play.

**Soundscape**
The full set of Sound Cues assigned to a Play across all its Acts. The Soundscape is the live-performance configuration of a Play.

**Hotkey**
A keyboard shortcut string assigned to a SoundCue, used to trigger playback during a live performance.

---

## Enumerations

**PlayMode** (`once` | `repeat`)
Controls how a SoundCue plays back. `once` plays the sound to completion. `repeat` loops it until explicitly stopped.

**SoundCategory** (`effect` | `ambient` | `song`)
Classifies a Sound by its nature. Used for filtering in the Sound Library. `all` is a UI-only filter value, not a valid category for a Sound.

---

## UI / Session Concepts

**Panic**
A global emergency action that stops all currently playing sounds immediately. Triggered via the Panic Button visible in the app bar during a Soundscape session.

**Playback State**
Transient, session-only state tracking which SoundCues are currently playing. Not persisted. Managed by `SoundPlaybackProvider`.

**Application ID**
A UUID generated once per app startup. Used to identify the running instance. Not persisted across sessions.

---

## Boundaries

- A SoundCue references a Sound by ID (`soundId`). The Sound itself lives in the Sound Library, not inside the Play.
- Editing Play metadata (title, author, script) must never destroy existing SoundCues — this is a hard invariant enforced in `PlaysProvider.updatePlay`.
- ScriptLines and SoundCues within an Act share a sequential, gap-free line-number space. Removing any item requires re-numbering the remaining items.

---

## Storage & Sound Library

**StorageMode** (`local` | `cloud` | `unknown`)
Derived at runtime from the AppConfig fetched from the backend. `local` = `localFolder` is set; `cloud` = `storageEndpoint` is set; `unknown` = neither. Exposed by `storageModeProvider`.

In `local` mode the Sound Library shows a **Sync** button (triggers `POST /v1/sounds/sync`). In `cloud` mode it shows an **Upload** button (presign → PUT flow). In `unknown` mode no action button is shown.

**SoundCue Trim**
`startMs` and `endMs` on `SoundCueModel` define the playback segment. Both are nullable integers. When null, the full sound plays. The cue duration displayed on the card is `(endMs ?? soundDurationMs) - (startMs ?? 0)`.

**Hotkey uniqueness**
Hotkeys are unique per Act. `HotkeyCaptureDialog` receives the set of already-used hotkeys and shows a warning if the selected key is taken.

---

## Playback Architecture

**`AudioPlayerNotifier`** (keepAlive singleton)
Owns the `audioplayers` `AudioPlayer` instance. Enforces `startMs`/`endMs` trim via `Future.delayed`. Loops via `onPlayerComplete` when `loop = true`. Exposes `AudioPlayerState { playingId, playerState, isLooping }`.

`isLooping` stays `true` during the stop→restart cycle of a repeat loop so listeners do not incorrectly interpret the transient `stopped` state as the sound ending.

**`SoundPlaybackProvider`** (per-session)
Tracks which cue IDs are currently playing (`playingIds: Set<int>`). Listens to `audioPlayerProvider` and clears `playingIds` only when `!next.isPlaying && !next.isLooping`. Both `CuePlayCard` and `ScriptCueItem` read from this provider, so their play/stop icons stay in sync regardless of which widget triggered playback.

**Panic**
ESC key on `BasePage` calls `panicActionProvider.execute()` → `SoundPlaybackProvider.stopAll()`. Stops all audio and clears playback state.

---

## Next Steps

- [ ] Audio file upload for web: `FilePicker` must use `withData: true`; bytes are uploaded via presigned PUT — no `dart:io` dependency
- [ ] Test SeaweedFS upload end-to-end on homelab (`s3.foguinhodogoias.com`)
- [ ] `CueTrimDialog`: consider displaying a real waveform instead of the custom paint trim bar (requires a waveform package or server-side peak data)
