module input private

require daslib/media

def public is_mouse_in_box(box: float4)
    let coords = get_mouse_position() - box.xy
    return coords.x >= 0.0 && coords.x <= box.z && coords.y >= 0.0 && coords.y <= box.w