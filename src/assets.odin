package main

import rl "vendor:raylib"
import "core:encoding/json"
import "core:os"
import "core:fmt"

load_tuning :: proc(path: string) -> (t: Tuning, ok: bool) {
    data, read_err := os.read_entire_file_from_path(path, context.allocator)
    if read_err != nil {
        fmt.eprintln("could not read", path, ":", read_err)
        return {}, false
    }

    defer delete(data)

    if err := json.unmarshal(data, &t); err != nil {
        fmt.eprintln("tuning parse error:", err)
        return {}, false
    }
    
    return t, true
}

load_assets :: proc() -> Assets {
    a: Assets
    a.cat = rl.LoadTexture("assets/AllCatsDemo/AllCatsDemo/Classical/IdleCat.png")
    rl.SetTextureFilter(a.cat, .POINT)  //stops blurring when scaling up
    return a
}

//free texture memory when the game ends
unload_assets :: proc(a: Assets) {
    rl.UnloadTexture(a.cat)
}

