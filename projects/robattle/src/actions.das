module actions private

require math

require scene
require animations
require delay

def public is_empty(pos: Position&)
    return scene.levels[pos.level].units[pos.pos].team == Team empty

def can_unit_touch(unit, pos: Position)
    if unit.level == pos.level && abs(pos.pos - unit.pos) <= 2
        return true

    if pos.pos == unit.pos
        return true

    return false

def public can_unit_move(unit, pos: Position)
    if !is_empty(pos)
        return false

    return can_unit_touch(unit, pos)

def public can_unit_attack(unit, pos: Position)
    if is_empty(pos)
        return false

    if scene.levels[pos.level].units[pos.pos].team == scene.levels[unit.level].units[unit.pos].team
        return false

    return can_unit_touch(unit, pos)

def public move_unit(from, to: Position): float
    verify(can_unit_move(from, to))
    let dt = 0.7
    animations::move_unit(from, to, dt)
    delay(dt) <| @()
        swap(scene.levels[from.level].units[from.pos], scene.levels[to.level].units[to.pos])
    return dt

def public attack(unit, to: Position): float
    verify(can_unit_attack(unit, to))
    let dt = 0.4
    animations::attack(unit, to, dt)
    delay(dt) <| @()
        let c : Unit = scene.levels[to.level].units[to.pos]
        if c.hp == 1
            scene.levels[to.level].units[to.pos] = Unit()
        else
            // FIXME: set hp with .hp -= 1
            scene.levels[to.level].units[to.pos] = [[Unit
                t=c.t, direction=c.direction, dt=c.dt, team=c.team,
                animation=c.animation,
                hp=c.hp - 1]]

    return dt

def public get_winner()
    var have_unit <- {{Team left => false; Team right => false}}

    for level in [[Level Level ground; Level sky]]
        for pos in range(length(scene.levels[level].units))
            let u : Unit& = scene.levels[level].units[pos]
            if u.team != Team empty
                have_unit[u.team] = true

    if !have_unit[Team left]
        return Team right
    if !have_unit[Team right]
        return Team left

    return Team empty
