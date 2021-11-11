module move_animations private

require daslib/media
require math

require scene
require background

def public moved_from(pos, from: Position; duration: float; t = MoveAnimationType linear)
    var direction = NESW south
    if pos.pos > from.pos
        direction = NESW east
    elif pos.pos < from.pos
        direction = NESW west

    scene.levels[int(pos.level)].units[pos.pos].move_animation <- [[MoveAnimation
        t=t,
        from=get_unit_box(from).xy,
        to=get_unit_box(pos).xy,
        start=get_time_after_start(),
        duration=duration,
        direction=direction
    ]]

def public get_animation_shift(pos: Position)
    let anim = scene.levels[int(pos.level)].units[pos.pos].move_animation
    if anim.t == MoveAnimationType disabled
        return float2(0.0)

    let dt = (get_time_after_start() - anim.start) / anim.duration

    assert(anim.t == MoveAnimationType linear)

    return (anim.from - anim.to) * saturate(1.0 - dt)

def public get_animation_direction(pos: Position)
    let anim = scene.levels[int(pos.level)].units[pos.pos].move_animation
    if anim.t == MoveAnimationType disabled || get_time_after_start() > anim.start + anim.duration
        return scene.levels[int(pos.level)].units[pos.pos].direction

    return anim.direction
