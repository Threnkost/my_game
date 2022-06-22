extends Area2D
class_name BlockPlacer

const AVAILABLE_BLOCK_MODULATE = Color(1, 1, 1, 0.4)
const UNAVAILABLE_BLOCK_MODULATE = Color(1, 0, 0, 0.4)

enum {
	WALL,
	FLOOR
}


export var is_active    := false

var map_position : Vector2

var block_id := -1
var type


func update_position(offset):
	if not is_active:
		return
	
	global_position = get_global_mouse_position()
	
	map_position.x = floor(global_position.x / 16)
	map_position.y = floor((global_position.y) / 16)

	global_position.x = map_position.x * 16 + offset.x
	global_position.y = map_position.y * 16 + offset.y


func execute(block_id :int):
	pass
	

func stop():
	pass


func place():
	pass


func can_place():
	return is_active and block_id != -1
