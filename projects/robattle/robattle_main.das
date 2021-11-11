require daslib/media
options debugger
require daslib/debug

require src/draw_scene
require src/ui
require src/background
require src/order
require src/delay
require src/frametime


// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("robattle")
    set_resolution(1280, 720)
    init_draw_scene()
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()

    frametime::act()
    delay::act()
    background::act()
    ui::act()
    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    draw_scene()
    return
