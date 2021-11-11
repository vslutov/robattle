module background private

require daslib/media
require math

require scene
require frametime

enum BgType
    far_clouds
    above_clouds
    bg
    fg

struct public BgLayer
    t: BgType
    img: Image
    parallax_mult: float2
    parallax_add: float2

def get_bg(t: BgType; fname: string; parallax_mult = float2(1, 1); parallax_add = float2(0, 0)): BgLayer
    var img <- create_image(fname)
    img |> set_image_smooth(false)
    return <- [[BgLayer t=t, img<-img, parallax_mult=parallax_mult, parallax_add=parallax_add]]

// 137 x 89
let public far_clouds <- get_bg(BgType far_clouds, "assets/bg/far_clouds.png", float2(-0.4, 0.8), float2(0.0, -0.5))
let public above_clouds <- get_bg(BgType above_clouds, "assets/bg/above_clouds.png", float2(-0.8, 0.8), float2(0.0, -0.5))
let public bg <- get_bg(BgType bg, "assets/bg/bg.png", float2(0.2), float2(0.0, -0.8))
let public fg <- get_bg(BgType fg, "assets/bg/fg.png", float2(0.5), float2(-0.5, 0.5))


var public width = 1280.0
var public height = 720.0
var public bg_size = 10.0 * float2(above_clouds.img.width, above_clouds.img.height)

let public TILE_SIZE = 80.0

var public start_time_duration = float2(-1.0, 5.0)

def start_shift(layer: BgLayer)
    let DURATION = 5.0

    if (layer.t != BgType bg && layer.t != BgType fg)
        return float2(0.0, 0.0)

    if start_time_duration.x < 0.0
        return float2(0.0, height)

    if start_time_duration.x + DURATION < frametime()
        return float2(0.0, 0.0)

    let duration = layer.t == BgType bg ? start_time_duration.y : start_time_duration.y * 0.2
    let hide = layer.t == BgType bg ? height : height * 0.2

    return float2(0.0, 1.0 - saturate((frametime() - start_time_duration.x) / duration)) * hide

def public get_paralax_shift(layer: BgLayer)
    var lu_corner = (float2(width, height) - bg_size) * 0.5
    let mouse_pos = get_mouse_position() / float2(width, height)
    var parallax_effect = mouse_pos * 2.0 - float2(1.0)
    parallax_effect = parallax_effect * layer.parallax_mult + layer.parallax_add
    parallax_effect = clamp(parallax_effect, float2(-1.0), float2(1.0))
    return lu_corner * parallax_effect + layer |> start_shift()

def draw_bg_layer(layer: BgLayer; shift = float2(0.0, 0.0))
    var lu_corner = (float2(width, height) - bg_size) * 0.5
    let parallax_shift = get_paralax_shift(layer)
    lu_corner += shift + parallax_shift
    layer.img |> draw_image(lu_corner.x, lu_corner.y, make_color(1.0), bg_size)

def frac(val: float)
    return val - floor(val)

def draw_clouds(clouds : BgLayer; time_mult : float)
    let clouds_shift = frac(frametime() * time_mult) * bg_size.x
    clouds |> draw_bg_layer(float2(clouds_shift, 0.0))
    clouds |> draw_bg_layer(float2(clouds_shift - bg_size.x, 0.0))

def public draw_bg()
    far_clouds |> draw_clouds(0.005)

    bg |> draw_bg_layer()
    above_clouds |> draw_clouds(0.02)

def public draw_fg()
    fg |> draw_bg_layer()

def get_lu_corner(row: Row)
    let center = float2(width * 0.5, row.level == Level ground ? 460.0 : 230.0)

    return center + get_paralax_shift(bg) - float2(0.25 * TILE_SIZE * float(length(row.units) * 3 - 1), 0.5 * TILE_SIZE)

def public get_unit_box(pos: Position)
    let lu_corner = scene.levels[pos.level].lu_corner
    return float4(lu_corner.x + float(pos.pos) * 1.5 * TILE_SIZE, lu_corner.y, TILE_SIZE, TILE_SIZE)

def public act()
    scene.levels[Level ground].lu_corner = get_lu_corner(scene.levels[Level ground])
    scene.levels[Level sky].lu_corner = get_lu_corner(scene.levels[Level sky])
