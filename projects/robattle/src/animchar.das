module animchar private

require daslib/media

require scene
require frametime

struct public AnimcharNESW
    img: Image
    frameCount: int
    animDuration: float

def public create_nesw_animchar(fname: string; frameCount: int; animDuration: float) : AnimcharNESW
    var img <- create_image(fname)
    return <- [[AnimcharNESW img <- img, frameCount=frameCount, animDuration=animDuration]]

let animations: table<UnitType; AnimcharNESW> <- {{
    UnitType minimare => create_nesw_animchar("assets/chars/minimare-001.png", 3, 0.3);
    UnitType dark_minimare => create_nesw_animchar("assets/chars/dark_minimare-001.png", 3, 0.3);
    UnitType minimare_robot_01 => create_nesw_animchar("assets/chars/minimare_robot-001.png", 3, 0.3);
    UnitType minimare_robot_02 => create_nesw_animchar("assets/chars/minimare_robot-002.png", 3, 0.3)
}}

def public draw_animchar(animchar: Unit; box: float4; direction: NESW)
    let animation = animations |> find(animchar.t)
    if animation != null
        let frame = floori((frametime() / animation.animDuration + animchar.dt) * float(animation.frameCount)) % animation.frameCount
        let tile_size = float2(
            animation.img.width / animation.frameCount,
            animation.img.height / 4
        )

        let zoom = max(floor(min(box.z / tile_size.x, box.w / tile_size.y)), 1.0)
        let vizible_size = tile_size * zoom
        let shift = (box.zw - vizible_size) * 0.5

        animation.img |> draw_image_region(
            box.x + shift.x, box.y + shift.y,
            float4(
                float(frame) * tile_size.x, tile_size.y * float(int(direction)),
                tile_size.x, tile_size.y
            ),
            make_color(1.0),
            vizible_size
        )

