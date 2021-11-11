module draw_scene private

require daslib/media
require math
require functional

require scene
require input
require animchar
require ui
require background
require animations
require menu

var musicLoop <- create_managed_sound("assets/ambient.mp3")
var handle: PlayingSoundHandle

def draw_row(row: Row)
    for i in range(length(row.units))
        let pos = [[Position pos=i, level=row.level]]
        var box = pos |> get_unit_box()
        box.xy += pos |> get_animation_shift()
        row.units[i] |> draw_animchar(box, get_animation_direction(pos))

def draw_units()
    draw_row(scene.levels[Level ground])
    draw_row(scene.levels[Level sky])

def public init_draw_scene()
    width = float(get_screen_width())
    height = float(get_screen_height())
    bg_size = 10.0 * float2(far_clouds.img.width, far_clouds.img.height)
    handle = musicLoop |> play_sound_loop(1.0, 1.0)

def public draw_scene()
    enable_alpha_blend()
    draw_bg()
    draw_bg_ui()
    draw_units()
    draw_fg()
    draw_fg_ui()
    draw_menu()
