package main

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(800, 450, "MidnightStealth")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        rl.ClearBackground(rl.RAYWHITE)
        rl.DrawText("MidnightStealth", 300, 200, 30, rl.BLACK)

        rl.EndDrawing()
    }
}