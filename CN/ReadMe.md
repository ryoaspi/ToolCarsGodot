# Carlier Nicolas

This package contains 2 tools:

---

# Draw With RayCast

This tool draws on a texture and applies it to an override material.

> **Requirements**
>
> * Must be used on a quad mesh on **Layer 2** for proper behavior.
> * The mesh must use a standard material with an **uncompressed albedo texture**.
> * You can use `MAT_ground` from the demo package.

## Pencil Type

Choose between:

* `Diamond`
* `Cross`

## Signals

### `signal on_draw_called(image: Image)`

Sends a signal with the image every time the texture changes.

Supply this image to `RGBFromRaycast` to maintain proper behavior between tools.

## Functions

Connect your input signal on press and release.


### `axbutton_press_to_raycast_and_draw(name: String)`
#### On Press

* If supplied with `ax_button`, painting to **Black** starts.
* If supplied with `by_button`, painting to **White** starts.

### `send_raycast_to_get_pixel_and_draw(color: Color)`
#### On Release

* If supplied with `ax_button`, painting to **Black** stops.
* If supplied with `by_button`, painting to **White** stops.


Draws the specified color at the raycast collision position on the texture.

---

# RGB From RayCast

This tool reads a texture where the raycast collides and returns the RGBA value (`0-255`) of the pixel.

> **Requirements**
>
> * Must be used on a quad mesh on **Layer 2** for proper behavior.
> * The mesh must use a standard material with an **uncompressed albedo texture**.
> * You can use `MAT_ground` from the demo package.

## Signals

### `signal on_rgba_from_raycast(rgba: Vector4i)`

Sends the RGBA value as a `Vector4i` every `_physics_process` while colliding with a readable surface.

### `signal on_rgba_from_raycast_string(string_rgba: String)`

Sends the RGBA value as a `String` every `_physics_process` while colliding with a readable surface.

## Functions

### `get_RGBA_from_raycast() -> Vector4i`

Returns the pixel value under the raycast.

Returns:

```gdscript
Vector4i(0, 0, 0, 0)
```

if there is no collision or if the surface cannot be read.

### `set_image(image: Image) -> void`

Connect the signal from `DrawWithRaycast` to maintain proper behavior between both tools.
