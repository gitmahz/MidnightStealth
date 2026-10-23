package main

import rl "vendor:raylib"


// Rendering (Draws to Screen)
render_playing :: proc(g: ^Game) {
    for e in g.entities {
        if !e.active do continue

        //picks a color based on the entity kind, and draws a rectangle for the entity
        color: rl.Color
        //#partial allows skipping 
        #partial switch e.kind {
        case .Cat:         color = rl.ORANGE
        case .Human:       color = rl.PINK
        case .Dog:         color = rl.MAROON
        case .Wall:        color = rl.DARKGRAY
        case .Floor_Zone:  color = rl.BROWN
        case .Door:        color = rl.BEIGE
        case .Hiding_Spot: color = rl.DARKBLUE
        case .Treat:       color = rl.GOLD
        //default red color for any other entity kind, which shouldn't happen
        case:              color = rl.RED
        }


        //draws the cat texture if the entity is a cat and the cat texture has been loaded
        if e.kind == .Cat && g.assets.cat.id != 0 {
            tex := g.assets.cat
            src := rl.Rectangle{0, 0, f32(CAT_FRAME_W), f32(CAT_FRAME_H)}
            if e.facing_left do src.width = -src.width
            rl.DrawTexturePro(tex, src, entity_rect(e), {0, 0}, 0, rl.WHITE)
            continue
        }

        rl.DrawRectangleV(e.pos, e.size, color)

    }

    //finds the highest awareness value among all humans and dogs, and draws a red bar to represent it
    worst: f32 = 0
    for e in g.entities {
        if e.active && (e.kind == .Human || e.kind == .Dog) do worst = max(worst, e.awareness)
    }
    rl.DrawRectangle(20, 60, 200, 16, rl.DARKGRAY)
    rl.DrawRectangle(20, 60, i32(200 * worst / g.tuning.awareness_max), 16, rl.RED)
    rl.DrawText("Awareness", 20, 80, 16, rl.WHITE)
    //draws "HIDDEN" text on the screen if the cat is currently hidden
    if g.entities[g.cat_index].hidden do rl.DrawText("HIDDEN", 20, 100, 20, rl.SKYBLUE)

    // HUD (not entities)
    rl.DrawText(rl.TextFormat("Noise: %.0f", g.noise_level), 20, 30, 20, rl.WHITE)
}

render :: proc(g: ^Game) {
    rl.BeginDrawing()
    defer rl.EndDrawing()
    rl.ClearBackground(rl.BLACK)

    switch g.state {
    case .Title:
        rl.DrawText("MIDNIGHT STEALTH", 420, 300, 40, rl.WHITE)
        rl.DrawText("Press ENTER to start", 480, 360, 20, rl.GRAY)
    case .Playing:
        render_playing(g)
    case .Paused:
        render_playing(g)
        rl.DrawText("PAUSED", 560, 340, 40, rl.WHITE)
    case .Win:
        rl.DrawText("You got the treats!", 440, 340, 40, rl.GREEN)
    case .Lose:
        rl.DrawText("The household woke up...", 400, 340, 40, rl.RED)
    }
}