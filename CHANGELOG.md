# Changelog

## 1.0.0 (2026-11-25)

Initial public release.

### Added

- Batch destroy: select an area with the deconstruction planner, everything inside is removed instantly and refunded to the player.
- Batch copy: copy the selected area (optionally including container contents).
- Batch move: remove the selected area and rebuild it elsewhere, keeping contents.
- Ghost preview: blue ghost outlines follow the player and show where the build will land.
- Smart anchor: the build is centered horizontally and placed 3 tiles above the player.
- Rotation: rotate the whole build (positions and directions) by 90 degrees clockwise.
- Undo: restore the last move to its original location.
- Planning zones: draw colored, labeled zones on the map and toggle their visibility.
- Setting: "Copy contents" (on by default).
