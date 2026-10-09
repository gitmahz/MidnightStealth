package main

import rl "vendor:raylib"


SCREEN_W :: 1280
SCREEN_H :: 720

//won't be used for now, but could be used for sprite animation
CAT_FRAME_W :: 32
CAT_FRAME_H :: 32
CAT_FRAME_COUNT :: 7

// Constants 
HEARING_RANGE_PER_NOISE :: 10.0 
AWARENESS_GAIN          :: 40.0
AWARENESS_DECAY         :: 10.0
AWARENESS_MAX           :: 100.0

// ---------- Data ----------

Assets :: struct {
    cat: rl.Texture2D,
}

//List of all the different kinds of entities in the game
Entity_Kind :: enum {
    None, //zero value, not used
    Cat,
    Human,
    Dog,
    Wall,
    Floor_Zone,
    Door,
    Hiding_Spot,
    Treat,
    Objective_Item,
    Noisy_Object,
}

//More enums for different properties of entities and game state
Surface        :: enum { Carpet, Wood, Noisy_Floorboard }
Move_Mode      :: enum { Sneak, Walk, Sprint }
Human_Behavior :: enum { Sleeping, Investigating, Alert }
Game_State     :: enum { Title, Playing, Paused, Win, Lose }

//The main entity struct, which contains all the properties of an entity
Entity :: struct {
    kind:   Entity_Kind,
    pos:    rl.Vector2,
    size:   rl.Vector2,
    active: bool,   
    solid:  bool,   // blocks the cat
    facing_left: bool,

    // Characters
    awareness: f32,            // 0-100
    behavior:  Human_Behavior, // humans
    mode:      Move_Mode,      // cat
    hidden:    bool,           // cat

    // Environment
    surface: Surface, // Floor
    noise:   f32,     
    creaky:  bool,    // Door
}

// The main game struct, which contains the game state and all entities the game needs 
Game :: struct {
    state:       Game_State,
    entities:    [dynamic]Entity,
    cat_index:   int,
    noise_level: f32,
    level:       int,
    assets:      Assets,
}

load_assets :: proc() -> Assets {
    a: Assets
    a.cat = rl.LoadTexture("../assets/AllCatsDemo/AllCatsDemo/Classical/IdleCat.png")
    rl.SetTextureFilter(a.cat, .POINT)  //stops blurring when scaling up
    return a
}

//free texture memory when the game ends
unload_assets :: proc(a: Assets) {
    rl.UnloadTexture(a.cat)
}

// Helpers 

add_entity :: proc(g: ^Game, e: Entity) -> int {
    append(&g.entities, e) //add the entity to the end of the array
    return len(g.entities) - 1
}

//converts empty entity into a rectangle 
entity_rect :: proc(e: Entity) -> rl.Rectangle {
    return {e.pos.x, e.pos.y, e.size.x, e.size.y}
}

//returns the center of an entity, used for calculating distance between entities
entity_center :: proc(e: Entity) -> rl.Vector2 {
    return e.pos + e.size * 0.5
}

//using Move_Mode enum to determine how fast the cat moves in different modes
speed_for :: proc(mode: Move_Mode) -> f32 {
    switch mode {
    case .Sneak:  return 80
    case .Walk:   return 160
    case .Sprint: return 260
    }
    return 0
}

//using Move_Mode enum to determine how much noise the cat makes in different modes
noise_for :: proc(mode: Move_Mode) -> f32 {
    switch mode {
    case .Sneak:  return 5
    case .Walk:   return 20
    case .Sprint: return 50
    }
    return 0
}

// Levels 

load_level_1 :: proc(g: ^Game) {
    //empty the entities array and reset game state
    clear(&g.entities)
    g.noise_level = 0
    g.level = 1

    //builds cat entity and saves its index for later use
    g.cat_index = add_entity(g, {kind = .Cat, pos = {100, 600}, size = {24, 24}, active = true})

    //adding other entities to the game world
    add_entity(g, {kind = .Human, pos = {600, 200}, size = {40, 40}, active = true,
                   behavior = .Sleeping})
    add_entity(g, {kind = .Dog, pos = {900, 400}, size = {32, 32}, active = true})

    add_entity(g, {kind = .Wall, pos = {0, 0}, size = {SCREEN_W, 20}, active = true, solid = true})
    add_entity(g, {kind = .Floor_Zone, pos = {300, 300}, size = {200, 100}, active = true,
               surface = .Noisy_Floorboard, noise = 30})
    add_entity(g, {kind = .Door, pos = {500, 500}, size = {20, 80}, active = true,
                   creaky = true, noise = 30})
    add_entity(g, {kind = .Hiding_Spot, pos = {200, 200}, size = {50, 50}, active = true})
    add_entity(g, {kind = .Treat, pos = {1100, 100}, size = {16, 16}, active = true})
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
    cat.pos += dir * speed_for(cat.mode) * dt

    cat.hidden = false
    for e in g.entities {
        if e.active && e.kind == .Hiding_Spot &&
        rl.CheckCollisionRecs(entity_rect(cat^), entity_rect(e)) {
            cat.hidden = true
            
        }
    }

    noise: f32 = 0
    if moving {
        noise = noise_for(cat.mode)
        for e in g.entities {
            if e.active && e.kind == .Floor_Zone && e.surface == .Noisy_Floorboard &&
            rl.CheckCollisionRecs(entity_rect(cat^), entity_rect(e)) {
                noise += e.noise
            }
        }
    }

    if cat.hidden do noise = 0
    g.noise_level = noise

    //Awareness 
    //converts the noise level into a hearing radius for humans and dogs, and updates their awareness based on the cat's noise level and distance from them
    hear_radius := noise * HEARING_RANGE_PER_NOISE
    for &e in g.entities {
        //skips over anything thay shouldn't react 
        if !e.active || (e.kind != .Human && e.kind != .Dog) do continue

        //the straight line distance between the cat and the entity, used to determine how much awareness to add
        dist := rl.Vector2Distance(entity_center(cat^), entity_center(e))
        if noise > 0 && dist < hear_radius {
            //the closer the cat is to the entity, the more awareness it gains, with a maximum of AWARENESS_GAIN per second at zero distance
            closeness := 1 - dist / hear_radius
            e.awareness += AWARENESS_GAIN * closeness * dt
        } else {
            //if the cat is not making noise or is too far away, the entity's awareness decays over time
            e.awareness -= AWARENESS_DECAY * dt
        }
        //forces the awareness value to stay within the range of 0 to AWARENESS_MAX (100)
        e.awareness = clamp(e.awareness, 0, AWARENESS_MAX)

        //if the entity's awareness reaches the maximum value, the player loses the game
        if e.awareness >= AWARENESS_MAX {
            g.state = .Lose
            return
        }
    }

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

        rl.DrawRectangleV(e.pos, e.size, color)

        //draws the cat texture if the entity is a cat and the cat texture has been loaded
        if e.kind == .Cat && g.assets.cat.id != 0 {
            tex := g.assets.cat
            src := rl.Rectangle{0, 0, f32(CAT_FRAME_W), f32(CAT_FRAME_H)}
            if e.facing_left do src.width = -src.width
            rl.DrawTexturePro(tex, src, entity_rect(e), {0, 0}, 0, rl.WHITE)
            continue
        }
    }

    //finds the highest awareness value among all humans and dogs, and draws a red bar to represent it
    worst: f32 = 0
    for e in g.entities {
        if e.active && (e.kind == .Human || e.kind == .Dog) do worst = max(worst, e.awareness)
    }
    rl.DrawRectangle(20, 60, 200, 16, rl.DARKGRAY)
    rl.DrawRectangle(20, 60, i32(200 * worst / AWARENESS_MAX), 16, rl.RED)
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

// ---------- Main ----------

main :: proc() {
    rl.InitWindow(SCREEN_W, SCREEN_H, "Midnight Stealth")
    defer rl.CloseWindow()
    rl.SetTargetFPS(60)

    game: Game
    game.state = .Title
    game.assets = load_assets()
    defer unload_assets(game.assets)
    defer delete(game.entities)

    for !rl.WindowShouldClose() {
        update(&game, rl.GetFrameTime())
        render(&game)
    }
}