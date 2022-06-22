extends BlockPlacer

var is_colliding := false

var valid_wall_ids := {
	"basic_wall":0
}


func _ready():
	type = WALL


func execute(_block_id):
	is_active = true
	visible   = true
	
	block_id = _block_id
	
	
func stop():
	is_active = false
	visible   = false


func can_place():
	return .can_place() and not is_colliding


func _on_WallPlacer_body_entered(body):
	is_colliding = true


func _on_WallPlacer_body_exited(body):
	is_colliding = false


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
	get_node("/root/World/YSort/Walls").set_cellv(map_position, block_id)
