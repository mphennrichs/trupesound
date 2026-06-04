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
