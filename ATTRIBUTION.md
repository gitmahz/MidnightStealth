# Attribution

## Libraries and tools

- **Odin** (compiler and language), https://odin-lang.org
- **Raylib**, used for graphics, input, and audio, via Odin's `vendor:raylib` bindings. Licence: zlib/libpng.
- **VS Code** and **Git/GitHub** for development.

## Assets

| Asset | Used for | Source | Licence |
|---|---|---|---|
| AllCatsDemo, `Classical/IdleCat.png` | Player cat sprite | https://toffeecraft.itch.io/cat-pixel-mega-pack| For commercial or personal use |

All other visuals (walls, floor zones, humans, dog, doors, hiding spots, treat) are placeholder rectangles drawn in code by me. No sound assets are used yet.

## AI Assistance

- **ChatGPT**: used for game design discussion, and to generate the default starting code for `main.odin`.
- **Claude (Anthropic)**: used for:
  - Structuring the entity collection (`Entity` struct, `add_entity`, level loading)
  - The game state machine and the update/render split
  - Loading and drawing the cat sprite (`load_assets`, `DrawTexturePro`)
  - The noise and awareness system (hearing range, awareness gain/decay, hiding)
- **Written by me**: the GDD (`docs/gdd.md`), the game concept, the level layout, and tuning values.