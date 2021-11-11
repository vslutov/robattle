module frametime private

require daslib/media

var current_frametime = 0.0

def public act()
    current_frametime = get_time_after_start()

def public frametime()
    return current_frametime
