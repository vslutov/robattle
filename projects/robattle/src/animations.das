module animations private

require daslib/media
require math

require scene
require background
require frametime

def public move_unit(from, to: Position; duration: float; t = MoveAnimationType linear)
    var direction = NESW south
    if to.pos > from.pos
        direction = NESW east
    elif to.pos < from.pos
        direction = NESW west

    scene.levels[from.level].units[from.pos].animation <- [[MoveAnimation
        t=t,
        from=get_unit_box(from).xy,
        to=get_unit_box(to).xy,
        start=frametime(),
        duration=duration,
        direction=direction
    ]]

def public attack(unit, to: Position; duration: float; t = MoveAnimationType linear_attack)
    var direction = NESW south
    if to.pos > unit.pos
        direction = NESW east
    elif to.pos < unit.pos
        direction = NESW west

    scene.levels[unit.level].units[unit.pos].animation <- [[MoveAnimation
        t=t,
        from=get_unit_box(unit).xy,
        to=get_unit_box(to).xy,
        start=frametime(),
        duration=duration,
        direction=direction
    ]]

def public get_animation_shift(pos: Position)
    let anim = scene.levels[pos.level].units[pos.pos].animation
    if anim.t == MoveAnimationType disabled
        return float2(0.0)

    if anim.start + anim.duration < frametime()
        return float2(0.0)

    let dt = (frametime() - anim.start) / anim.duration

    if anim.t == MoveAnimationType linear
        return (anim.to - anim.from) * saturate(dt)

    if anim.t == MoveAnimationType linear_attack
        return (anim.to - anim.from) * saturate(1.0 - 2.0 * abs(0.5 - dt))

    return float2(0.0)

def public get_animation_direction(pos: Position)
    let anim = scene.levels[pos.level].units[pos.pos].animation
    if anim.t == MoveAnimationType disabled || frametime() > anim.start + anim.duration
        return scene.levels[pos.level].units[pos.pos].direction

    return anim.direction
