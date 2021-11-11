module selected_unit private

require math

require scene
require actions
require order

var selected_unit = Position()

def public is_unit_selectable(pos: Position)
    if !is_active()
        return false

    return scene.levels[pos.level].units[pos.pos].team == active_player

def public select_unit(pos: Position)
    verify(pos |> is_unit_selectable())
    selected_unit = pos

def public is_unit_selected()
    return selected_unit.pos != -1

def public can_selected_unit_move(pos: Position)
    if !is_active()
        return false

    return selected_unit |> can_unit_move(pos)

def public is_unit_selected(pos: Position)
    return pos.level == selected_unit.level && pos.pos == selected_unit.pos

def public reset_select()
    selected_unit = Position()

def public move_selected_unit(pos: Position): float
    let dt = selected_unit |> move_unit(pos)
    reset_select()
    return dt

def public can_selected_unit_attack(pos: Position): bool
    if !is_active()
        return false

    return selected_unit |> can_unit_attack(pos)

def public selected_unit_attack(pos: Position): float
    let dt = selected_unit |> attack(pos)
    reset_select()
    return dt
