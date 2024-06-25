package invaders

import "core:fmt"
//import "core:os"
import "core:time"
import rl "vendor:raylib"

Attack :: struct {
	using e: Entity,
	dt:      time.Duration,
}

Entity :: struct {
	pos:   [4]f32,
	color: rl.Color,
	alive: bool,
}

Player :: struct {
	using e: Entity,
	attack:  [dynamic]Attack,
}

draw_position :: proc(pos: [4]f32, color: rl.Color) {
	rl.DrawRectangle(cast(i32)pos[0], cast(i32)pos[1], cast(i32)pos[2], cast(i32)pos[3], color)
}

draw_player :: proc(p: Player) {
	draw_position(p.pos, p.color)
}

is_key_down_or_held :: proc(key: rl.KeyboardKey) -> bool {
	if (rl.IsKeyPressed(key) || rl.IsKeyPressedRepeat(key)) {
		return true
	}
	return false
}

handle_player :: proc(p: ^Player) {
	p := p
	INC_AMOUNT :: 25
	if (is_key_down_or_held(.A)) {
		if (p.pos[0] > 0) {
			p.pos[0] -= INC_AMOUNT
		}
	} else if is_key_down_or_held(.D) {
		if (p.pos[0] < cast(f32)rl.GetScreenWidth() - p.pos[3]) {
			p.pos[0] += INC_AMOUNT
		}
	} else if rl.IsKeyPressed(.SPACE) {
		append(
			&p.attack,
			Attack{pos = {p.pos[0], p.pos[1], p.pos[2], p.pos[3]}, color = rl.BLUE, alive = true},
		)
	}
}

render_attacks :: proc(attacks: [dynamic]Attack, dt: time.Duration) {
	attacks := attacks
	for &attack, _ in attacks {
		if (time.duration_seconds(attack.dt) > time.duration_seconds(dt)) {
			attack.pos[1] += 1
		}
		fmt.println(attack.pos[1])
		draw_position(attack.pos, attack.color)
		/*
		if (attack.pos[0] == 0) {
			ordered_remove(&attacks, i)
		}
    */
	}
}

main :: proc() {
	rl.SetTraceLogLevel(.NONE)
	rl.InitWindow(1000, 800, "Invaders")
	p: Player = {
		pos   = {cast(f32)rl.GetScreenWidth() / 2, cast(f32)rl.GetScreenHeight() - 25, 25, 25},
		color = rl.GREEN,
	}
	dt := time.now()
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		handle_player(&p)
		draw_player(p)
		if len(p.attack) > 0 {
			render_attacks(p.attack)
		}
		rl.EndDrawing()
	}
}
