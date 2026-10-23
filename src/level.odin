package main

import rl "vendor:raylib"


add_entity :: proc(g: ^Game, e: Entity) -> int {
    append(&g.entities, e) //add the entity to the end of the array
    return len(g.entities) - 1
}

//converts empty entity into a rectangle 
entity_rect :: proc(e: Entity) -> rl.Rectangle {
    return {e.pos.x, e.pos.y, e.size.x, e.size.y}
}

load_level_1 :: proc(g: ^Game) {
    //empty the entities array and reset game state
    clear(&g.entities)
    g.noise_level = 0
    g.level = 1

    //builds cat entity and saves its index for later use
    g.cat_index = add_entity(g, {kind = .Cat, pos = {100, 600}, size = {48, 48}, active = true})

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



