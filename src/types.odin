
package main


import rl "vendor:raylib"


SCREEN_W :: 1280
SCREEN_H :: 720

CAT_FRAME_W :: 32
CAT_FRAME_H :: 32
CAT_FRAME_COUNT :: 7

// ---------- Data ----------

Assets :: struct {
    cat: rl.Texture2D,
}

Tuning :: struct {
    sneak_speed, walk_speed, sprint_speed: f32,
    sneak_noise, walk_noise, sprint_noise: f32,
    hearing_range_per_noise: f32,
    awareness_gain, awareness_decay, awareness_max: f32,
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
    tuning:      Tuning,
}
