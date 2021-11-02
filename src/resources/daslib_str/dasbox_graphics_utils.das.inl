//
// AUTO-GENERATED FILE - DO NOT EDIT!!
//

"require graphics\n"
"require dasbox\n"
"require math\n"
"require strings\n"
"\n"
"def create_image(width, height: int; pixels: string; palette: table<int; uint>&)"
": Image\n"
"    var p <- [{for c in pixels; palette?[c] ?? 0u}]\n"
"    return <- create_image(width, height, p)\n"
"\n"
"def make_color(brightness: float): uint\n"
"    let ib = uint(saturate(brightness) * 255.0 + 0.5)\n"
"    return 0xFF000000 | ib | (ib << 8u) | (ib << 16u)\n"
"\n"
"def make_color(brightness, alpha: float): uint\n"
"    let ib = uint(saturate(brightness) * 255.0 + 0.5)\n"
"    let ia = uint(saturate(alpha) * 255.0 + 0.5)\n"
"    return ib | (ib << 8u) | (ib << 16u) | (ia << 24u)\n"
"\n"
"def make_color(r, g, b: float): uint\n"
"    let ir = uint(saturate(r) * 255.0 + 0.5)\n"
"    let ig = uint(saturate(g) * 255.0 + 0.5)\n"
"    let ib = uint(saturate(b) * 255.0 + 0.5)\n"
"    return 0xFF000000 | ib | (ig << 8u) | (ir << 16u)\n"
"\n"
"def make_color(r, g, b, a: float): uint\n"
"    let ir = uint(saturate(r) * 255.0 + 0.5)\n"
"    let ig = uint(saturate(g) * 255.0 + 0.5)\n"
"    let ib = uint(saturate(b) * 255.0 + 0.5)\n"
"    let ia = uint(saturate(a) * 255.0 + 0.5)\n"
"    return ib | (ig << 8u) | (ir << 16u) | (ia << 24u)\n"
"\n"
"def make_color(c: float3): uint\n"
"    let sc = saturate(c)\n"
"    let ir = uint(sc.x * 255.0 + 0.5)\n"
"    let ig = uint(sc.y * 255.0 + 0.5)\n"
"    let ib = uint(sc.z * 255.0 + 0.5)\n"
"    return 0xFF000000 | ib | (ig << 8u) | (ir << 16u)\n"
"\n"
"def make_color(c: float4): uint\n"
"    let sc = saturate(c)\n"
"    let ir = uint(sc.x * 255.0 + 0.5)\n"
"    let ig = uint(sc.y * 255.0 + 0.5)\n"
"    let ib = uint(sc.z * 255.0 + 0.5)\n"
"    let ia = uint(sc.w * 255.0 + 0.5)\n"
"    return ib | (ig << 8u) | (ir << 16u) | (ia << 24u)\n"
"\n"
"def make_color32(r, g, b: int): uint\n"
"    return 0xFF000000 | uint(b) | (uint(g) << 8u) | (uint(r) << 16u)\n"
"\n"
"def make_color32(r, g, b, a: int): uint\n"
"    return uint(b) | (uint(g) << 8u) | (uint(r) << 16u) | (uint(a) << 24u)\n"
"\n"
"def make_color32(r, g, b: uint): uint\n"
"    return 0xFF000000 | b | (g << 8u) | (r << 16u)\n"
"\n"
"def make_color32(r, g, b, a: uint): uint\n"
"    return b | (g << 8u) | (r << 16u) | (a << 24u)\n"
"\n"
"def premultiply_color(c1: uint): uint\n"
"    let a = (c1 >> 24u) & 0xFF\n"
"    let r = (c1 & 0xFF) * a / 255u\n"
"    let g = ((c1 >> 8u) & 0xFF) * a / 255u\n"
"    let b = ((c1 >> 16u) & 0xFF) * a / 255u\n"
"    return b | (g << 8u) | (r << 16u) | (a << 24u)\n"
"\n"
"def desaturate_color(c1: uint): uint\n"
"    let a = (c1 >> 24u) & 0xFF\n"
"    let r = c1 & 0xFF\n"
"    let g = (c1 >> 8u) & 0xFF\n"
"    let b = (c1 >> 16u) & 0xFF\n"
"    let v = (r + g * 2u + b + 2u) >> 2u\n"
"    return v | (v << 8u) | (v << 16u) | (a << 24u)\n"
"\n"
"def multiply_colors(c1, c2: uint): uint\n"
"    let b1 = c1 & 0xFF\n"
"    let g1 = (c1 >> 8u) & 0xFF\n"
"    let r1 = (c1 >> 16u) & 0xFF\n"
"    let a1 = (c1 >> 24u) & 0xFF\n"
"    let b2 = c2 & 0xFF\n"
"    let g2 = (c2 >> 8u) & 0xFF\n"
"    let r2 = (c2 >> 16u) & 0xFF\n"
"    let a2 = (c2 >> 24u) & 0xFF\n"
"    let r = r1 * r2 / 255u\n"
"    let g = g1 * g2 / 255u\n"
"    let b = b1 * b2 / 255u\n"
"    let a = a1 * a2 / 255u\n"
"    return b | (g << 8u) | (r << 16u) | (a << 24u)\n"
"\n"
"def add_colors(c1, c2: uint): uint\n"
"    let b1 = c1 & 0xFF\n"
"    let g1 = (c1 >> 8u) & 0xFF\n"
"    let r1 = (c1 >> 16u) & 0xFF\n"
"    let a1 = (c1 >> 24u) & 0xFF\n"
"    let b2 = c2 & 0xFF\n"
"    let g2 = (c2 >> 8u) & 0xFF\n"
"    let r2 = (c2 >> 16u) & 0xFF\n"
"    let a2 = (c2 >> 24u) & 0xFF\n"
"    let r = min(r1 + r2, 255u)\n"
"    let g = min(g1 + g2, 255u)\n"
"    let b = min(b1 + b2, 255u)\n"
"    let a = min(a1 + a2, 255u)\n"
"    return b | (g << 8u) | (r << 16u) | (a << 24u)\n"
"\n"
"\n"
"////////////////////////////////////////////////////////////////////////////////"
"/////////////\n"
"\n"
"var private images: array<Image> <- [{ Image[] create_image(1, 1, [{ uint[] 0xFF"
"FFFFFF }]) }]\n"
"var private deleted_images: array<int>\n"
"\n"
"\n"
"struct ImageHandle\n"
"    index: int\n"
"    width: int\n"
"    height: int\n"
"\n"
"\n"
"def private setup_image(index: int; smooth: bool = false; use_mips: bool = false"
"): ImageHandle\n"
"    if smooth\n"
"        images[index] |> set_image_smooth(true)\n"
"    if use_mips\n"
"        images[index] |> set_image_use_mipmap()\n"
"    var h: ImageHandle\n"
"    h.index = index\n"
"    h.width = images[index].width\n"
"    h.height = images[index].height\n"
"    return h\n"
"\n"
"def private allocate_image(): int\n"
"    if empty(deleted_images)\n"
"        var img: Image\n"
"        images |> emplace(img)\n"
"        return length(images) - 1\n"
"    let res = deleted_images |> back()\n"
"    deleted_images |> pop()\n"
"    return res\n"
"\n"
"def delete_managed_image(image_handle: ImageHandle)\n"
"    if (image_handle.index > 0 && images[image_handle.index].valid)\n"
"        deleted_images |> push(image_handle.index)\n"
"        delete images[image_handle.index]\n"
"\n"
"def clone_managed_image(image_handle: ImageHandle): ImageHandle\n"
"    var i = allocate_image()\n"
"    images[i] := images[image_handle.index]\n"
"    return setup_image(i)\n"
"\n"
"def create_managed_image(file_name: string; smooth: bool = false; use_mips: bool"
" = false): ImageHandle\n"
"    var i = allocate_image()\n"
"    images[i] <- create_image(file_name)\n"
"    return setup_image(i, smooth, use_mips)\n"
"\n"
"def create_managed_image(width, height: int; smooth: bool = false; use_mips: boo"
"l = false): ImageHandle\n"
"    var i = allocate_image()\n"
"    images[i] <- create_image(width, height)\n"
"    return setup_image(i, smooth, use_mips)\n"
"\n"
"def create_managed_image(width, height: int; pixels: array<uint> &; smooth: bool"
" = false; use_mips: bool = false): ImageHandle\n"
"    var i = allocate_image()\n"
"    images[i] <- create_image(width, height, pixels)\n"
"    return setup_image(i, smooth, use_mips)\n"
"\n"
"def create_managed_image(width, height: int; pixels: string; palette): ImageHand"
"le\n"
"    var i = allocate_image()\n"
"    images[i] <- create_image(width, height, pixels, palette)\n"
"    return setup_image(i, smooth, use_mips)\n"
"\n"
"def draw_image_transformed(image_handle: ImageHandle; x, y, texture_rect, color,"
" size, angle, relative_pivot_x, relative_pivot_y)\n"
"    images[image_handle.index] |> draw_image_transformed(x, y, texture_rect, col"
"or, size, angle, relative_pivot_x, relative_pivot_y)\n"
"\n"
"def draw_image_transformed(image_handle: ImageHandle; x, y, texture_rect, color,"
" size, angle)\n"
"    images[image_handle.index] |> draw_image_transformed(x, y, texture_rect, col"
"or, size, angle)\n"
"\n"
"def draw_image(image_handle: ImageHandle; x, y)\n"
"    images[image_handle.index] |> draw_image(x, y)\n"
"\n"
"def draw_image(image_handle: ImageHandle; x, y, color)\n"
"    images[image_handle.index] |> draw_image(x, y, color)\n"
"\n"
"def draw_image(image_handle: ImageHandle; x, y, color, size)\n"
"    images[image_handle.index] |> draw_image(x, y, color, size)\n"
"\n"
"def draw_image_region(image_handle: ImageHandle; x, y, texture_rect)\n"
"    images[image_handle.index] |> draw_image_region(x, y, texture_rect)\n"
"\n"
"def draw_image_region(image_handle: ImageHandle; x, y, texture_rect, color)\n"
"    images[image_handle.index] |> draw_image_region(x, y, texture_rect, color)\n"
"\n"
"def draw_image_region(image_handle: ImageHandle; x, y, texture_rect, color, size"
")\n"
"    images[image_handle.index] |> draw_image_region(x, y, texture_rect, color, s"
"ize)\n"
"\n"
"def draw_quad(image_handle: ImageHandle; p0, p1, p2, p3)\n"
"    images[image_handle.index] |> draw_quad(p0, p1, p2, p3)\n"
"\n"
"def draw_quad(image_handle: ImageHandle; p0, p1, p2, p3, color)\n"
"    images[image_handle.index] |> draw_quad(p0, p1, p2, p3, color)\n"
"\n"
"def draw_triangle_strip(image_handle: ImageHandle; coords, texture_coords)\n"
"    images[image_handle.index] |> draw_triangle_strip(coords, texture_coords)\n"
"\n"
"def draw_triangle_strip(image_handle: ImageHandle; coords, texture_coords, color"
"s)\n"
"    images[image_handle.index] |> draw_triangle_strip(coords, texture_coords, co"
"lors)\n"
"\n"
"def set_pixel(image_handle: ImageHandle; x, y, color)\n"
"    images[image_handle.index] |> set_pixel(x, y, color)\n"
"\n"
"def get_pixel(image_handle: ImageHandle; x, y): uint\n"
"    return images[image_handle.index] |> get_pixel(x, y)\n"
"\n"
"def set_image_data(image_handle: ImageHandle; data)\n"
"    images[image_handle.index] |> set_image_data(data)\n"
"\n"
"def get_image_data(image_handle: ImageHandle; data)\n"
"    images[image_handle.index] |> get_image_data(data)\n"
"\n"
"def premultiply_alpha(image_handle: ImageHandle)\n"
"    images[image_handle.index] |> premultiply_alpha()\n"
"\n"
"def make_image_color_transparent(image_handle: ImageHandle; color)\n"
"    images[image_handle.index] |> make_image_color_transparent(color)\n"
"\n"
"def set_image_smooth(image_handle: ImageHandle; is_smooth)\n"
"    images[image_handle.index] |> set_image_smooth(is_smooth)\n"
"\n"
"def set_image_clamp(image_handle: ImageHandle; is_clamp)\n"
"    images[image_handle.index] |> set_image_clamp(is_clamp)\n"
"\n"
"def set_image_use_mipmap(image_handle: ImageHandle)\n"
"    images[image_handle.index] |> set_image_use_mipmap()\n"
"\n"
"def flip_image_x(image_handle: ImageHandle)\n"
"    images[image_handle.index] |> flip_image_x()\n"
"\n"
"def flip_image_y(image_handle: ImageHandle)\n"
"    images[image_handle.index] |> flip_image_y()\n"
"\n"
