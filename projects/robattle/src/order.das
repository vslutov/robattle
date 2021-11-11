module order private

require daslib/media
require math

require scene
require bot
require frametime
require delay

var is_active_flag = false

def public is_active()
    return is_active_flag

def next_player()
    return another_team[active_player]

def public finish_order(var dt: float)
    is_active_flag = false
    if game_mode == GameMode pvp
        active_player = next_player()
        delay(dt) <| @()
            is_active_flag = true
    else
        verify(game_mode == GameMode pve)
        delay(dt) <| @()
            bot::make_move(next_player()) <| @()
                is_active_flag = true

def public set_order(dt: float; team: Team)
    is_active_flag = false
    active_player = team
    delay(dt) <| @()
        is_active_flag = true

