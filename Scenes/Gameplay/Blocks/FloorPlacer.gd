extends BlockPlacer


var valid_wall_ids := {
	"basic_floor":0,
	"parquet":1
}


func _ready():
	type = FLOOR


func execute(_block_id):
	is_active = true
	visible   = true
	
	block_id = 1#_block_id
	
	
func stop():
	is_active = false
	visible   = false


func can_place():
	return .can_place()


func _physics_process(delta):
	update_position(Vector2(8, 8))
	
	if can_place():
		modulate = AVAILABLE_BLOCK_MODULATE
		
	else:
		modulate = UNAVAILABLE_BLOCK_MODULATE
	
	if Input.is_action_just_pressed("left_click"):
		place()


func place():
	if not can_place():
		return
	get_node("/root/World/YSort/Floor").set_cellv(map_position, block_id)
