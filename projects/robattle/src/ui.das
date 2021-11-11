module ui private

require daslib/media
require math

require background
require scene
require input
require selected_unit
require order
require menu
require actions

def draw_boxes(row: Row)
    for i in range(length(row.units))
        let pos = [[Position pos=i, level=row.level]]
        let box = pos |> get_unit_box()

        var color = make_color(0.5, 0.5, 0.5, 0.1) // empty
        if row.units[i].team == Team left
            color = make_color(0.2, 0.2, 1.0, 0.2)
        elif row.units[i].team == Team right
            color = make_color(1.0, 0.2, 0.2, 0.2)

        if is_unit_selected() && pos |> can_selected_unit_move()
            color = make_color(0.9, 0.9, 0.9, 0.5)
            if is_mouse_in_box(box)
                color = color & 0xffffffu | 0xff000000u

        if is_unit_selected() && pos |> can_selected_unit_attack()
            color = color & 0xffffffu | 0x88000000u
            if is_mouse_in_box(box)
                color = color & 0xffffffu | 0xff000000u

        if is_mouse_in_box(box)
            if pos |> is_unit_selectable()
                color = color & 0xffffffu | 0x88000000u

        if pos |> is_unit_selected()
            color = color & 0xffffffu | 0xff000000u

        box |> draw_box(5.0, color)
        if !is_empty(pos)
            text_out(box.x + 7.0, box.y + 7.0, "{row.units[i].hp}", color & 0xffffffu | 0x88000000u)

def public draw_bg_ui()
    set_font_size(20)
    draw_boxes(scene.levels[Level ground])
    draw_boxes(scene.levels[Level sky])

    set_font_size(60)
    if get_winner() == Team left
        text_out(530.0, 40.0, "BLUE WIN!", make_color(0.2, 0.2, 1.0, 1.0))
    if get_winner() == Team right
        text_out(530.0, 40.0, "RED WIN!", make_color(1.0, 0.2, 0.2, 1.0))

def public draw_fg_ui()
    pass

// Handle input

var lb_handled = false

def handle_row(row: Row)
    if get_mouse_button_down(MB_LEFT)
        for i in range(length(row.units))
            let pos = [[Position pos=i, level=row.level]]
            let box = pos |> get_unit_box()

            if is_mouse_in_box(box) && pos |> is_unit_selectable()
                if !pos |> is_unit_selected()
                    pos |> select_unit()
                else
                    reset_select()

                lb_handled = true

    if get_mouse_button_down(MB_RIGHT)
        for i in range(length(row.units))
            let pos = [[Position pos=i, level=row.level]]
            let box = pos |> get_unit_box()

            if is_mouse_in_box(box) && pos |> can_selected_unit_move()
                let dt = pos |> move_selected_unit()
                finish_order(dt)

            if is_mouse_in_box(box) && pos |> can_selected_unit_attack()
                let dt = pos |> selected_unit_attack()
                finish_order(dt)

def public act()
    menu::act()

    if !is_active()
        return

    if get_mouse_button_down(MB_LEFT)
        lb_handled = false

    handle_row(scene.levels[Level ground])
    handle_row(scene.levels[Level sky])

    if get_mouse_button_down(MB_LEFT)
        if !lb_handled
            reset_select()
