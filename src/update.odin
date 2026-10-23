package main

import rl "vendor:raylib"

speed_for :: proc(t: Tuning, mode: Move_Mode) -> f32 {
    switch mode {
    case .Sneak:  return t.sneak_speed
    case .Walk:   return t.walk_speed
    case .Sprint: return t.sprint_speed
    }
    return 0
}

noise_for :: proc(t: Tuning, mode: Move_Mode) -> f32 {
    switch mode {
    case .Sneak:  return t.sneak_noise
    case .Walk:   return t.walk_noise
    case .Sprint: return t.sprint_noise
    }
    return 0
}

// Updates (Changes Data)

update_playing :: proc(g: ^Game, dt: f32) {
    //to pause game 
    if rl.IsKeyPressed(.P) {
        g.state = .Paused
        return
    }
    //to lose game (temporary, for testing)
    if rl.IsKeyPressed(.L) {
        g.state = .Lose
        return
    }

    //pointer to the cat entity, so we don't have to keep indexing into the array
    cat := &g.entities[g.cat_index]

    // Cat Movement
    cat.mode = .Walk
    if rl.IsKeyDown(.LEFT_CONTROL) do cat.mode = .Sneak
    if rl.IsKeyDown(.LEFT_SHIFT)   do cat.mode = .Sprint

    dir: rl.Vector2
    if rl.IsKeyDown(.W) || rl.IsKeyDown(.UP)    do dir.y -= 1
    if rl.IsKeyDown(.S) || rl.IsKeyDown(.DOWN)  do dir.y += 1
    if rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT)  do dir.x -= 1
    if rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT) do dir.x += 1

    //check if direction is non-zero, and normalize it to get a unit vector for movement
    moving := dir != {}
    if moving do dir = rl.Vector2Normalize(dir)

    //pixels per second, multiplied by delta time to get pixels per frame
    cat.pos += dir * speed_for(g.tuning, cat.mode) * dt


    cat.hidden = false
    for e in g.entities {
        if e.active && e.kind == .Hiding_Spot &&
        rl.CheckCollisionRecs(entity_rect(cat^), entity_rect(e)) {
            cat.hidden = true
            
        }
    }

    noise: f32 = 0
    if moving {
        noise = noise_for(g.tuning, cat.mode)
        for e in g.entities {
            if e.active && e.kind == .Floor_Zone && e.surface == .Noisy_Floorboard &&
            rl.CheckCollisionRecs(entity_rect(cat^), entity_rect(e)) {
                noise += e.noise
            }
        }
    }

    if cat.hidden do noise = 0
    g.noise_level = noise

    //Win 
    cat_rect := entity_rect(cat^)
    for &e in g.entities { //&e since it changes active state of the entity
        if !e.active || e.kind != .Treat do continue
        if rl.CheckCollisionRecs(cat_rect, entity_rect(e)) {
            e.active = false
            g.state = .Win
        }
    }
}

//to update the game state based on the current state (title, playing, paused, win, lose)
update :: proc(g: ^Game, dt: f32) {
    //loads the first level when the player presses enter on the title screen, and updates the game state based on the current state
    switch g.state {
    case .Title:
        if rl.IsKeyPressed(.ENTER) {
            load_level_1(g)
            g.state = .Playing
        }
    case .Playing:
        update_playing(g, dt)
    case .Paused:
        if rl.IsKeyPressed(.P) do g.state = .Playing
    case .Win, .Lose:
        if rl.IsKeyPressed(.ENTER) do g.state = .Title
    }
}
