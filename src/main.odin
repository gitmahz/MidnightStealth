package main

import rl "vendor:raylib"

// ---------- Main ----------

main :: proc() {
    rl.InitWindow(SCREEN_W, SCREEN_H, "Midnight Stealth")
    defer rl.CloseWindow()
    rl.SetTargetFPS(60)

    game: Game
    game.state = .Title
    t, ok := load_tuning("data/tuning.json")
    if !ok { return }
    game.tuning = t
    game.assets = load_assets()
    defer unload_assets(game.assets)
    defer delete(game.entities)

    for !rl.WindowShouldClose() {
        update(&game, rl.GetFrameTime())
        render(&game)
    }
}