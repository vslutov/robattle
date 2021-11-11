module menu private

require daslib/media
require math

require scene
require background
require input
require order
require frametime

var menu_enabled = true

enum ButtonTypes
    pvp
    pve

struct Button
    t = ButtonTypes pvp
    box : float4
    text : string

let buttons <- [[Button[2]
    box=float4(0.3, 0.2, 0.4, 0.2), text="PvP", t=ButtonTypes pvp;
    box=float4(0.3, 0.5, 0.4, 0.2), text="PvE", t=ButtonTypes pve
]]

def public draw_box(box: float4; border:float; color: uint)
    fill_rect(box.x, box.y, border, box.w, color)
    fill_rect(box.x + border, box.y, box.z - border, border, color)
    fill_rect(box.x + box.z - border, box.y + border, border, box.w - border, color)
    fill_rect(box.x + border, box.y + box.w - border, box.z - 2.0 * border, border, color)

def draw_button(b : Button)
    set_font_size(120)
    let box = b.box * float4(width, height, width, height)
    let color = box |> is_mouse_in_box() ? make_color(0.2, 0.2, 0.8) : make_color(0.4)
    box |> draw_box(5.0, color)
    text_out(box.x + 160.0, box.y, b.text, color)

def public draw_menu()
    if !menu_enabled
        return

    buttons[int(menu::ButtonTypes pvp)] |> draw_button()
    buttons[int(menu::ButtonTypes pve)] |> draw_button()

def handle_button(b : Button)
    if get_mouse_button_down(MB_LEFT)
        let box = b.box * float4(width, height, width, height)
        if box |> is_mouse_in_box()
            if b.t == ButtonTypes pvp
                game_mode = GameMode pvp
            else
                game_mode = GameMode pve

            start_time_duration = float2(frametime(), 5.0)
            menu_enabled = false
            set_order(5.0, Team left)

def public act()
    if !menu_enabled
        return

    if false // debug option
        game_mode = GameMode pve
        menu_enabled = false
        start_time_duration = float2(frametime(), 0.001)
        set_order(0.0, Team left)
        return

    buttons[int(menu::ButtonTypes pvp)] |> handle_button()
    buttons[int(menu::ButtonTypes pve)] |> handle_button()
