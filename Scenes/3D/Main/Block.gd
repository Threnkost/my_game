extends Spatial

const BLOCK_MODEL = preload("res://Scenes/3D/Main/BlockModel/BlockBody.tscn")

const OFFSET = .16

enum modes {
	IDLE,
	EDITING,
	PLACING,
	ERASING
}

export (modes) var current_mode = modes.IDLE


var colliding_with := []
var block_res = load("res://Resources/3D/Blocks/test_block.tres") as BlockModel


func is_editing() -> bool:
	return current_mode == modes.EDITING
	

func start_editing(_initial_pos := Vector3.ZERO) -> void:
	global_transform.origin.x = _initial_pos.x
	global_transform.origin.z = _initial_pos.z
	
	$Mesh.mesh = block_res.mesh
	
#	var grid_map = Global.world.get_node("GameObjects/Map/Ground") as GridMap
#	var map_coord = grid_map.world_to_map(global_transform.origin)
#
#	global_transform.origin.x = map_coord.x * OFFSET
#	global_transform.origin.z = map_coord.z * OFFSET
	
	current_mode = modes.EDITING
	
	
func stop_editing() -> void:
	current_mode = modes.IDLE


func _physics_process(delta):
	
	if current_mode != modes.EDITING:
		visible = false
		$CollisionDetector/CollisionShape.disabled = true
		
		return
	
	$CollisionDetector/CollisionShape.disabled = false
	visible = true
	
	if Input.is_action_just_pressed("ui_right"):
		translation.x += OFFSET
		
	if Input.is_action_just_pressed("ui_left"):
		translation.x -= OFFSET
	
	if Input.is_action_just_pressed("ui_up"):
		translation.z -= OFFSET
		
	if Input.is_action_just_pressed("ui_down"):
		translation.z += OFFSET

	if Input.is_action_just_pressed("ui_accept") and colliding_with.size() == 0:
		
		place()
	
	
	if colliding_with.size() > 0:
		$Mesh.get_surface_material(0).albedo_color = Color("9bff0000")
	else:
		$Mesh.get_surface_material(0).albedo_color = Color(1, 1, 1, 0.4)


func erase() -> void:
	pass


func place() -> void:
	
	var block_model = BLOCK_MODEL.instance()
	block_model.transform.origin = transform.origin
	block_model.set_block_model(load("res://Resources/3D/Blocks/" + DeveloperSettings.get_block_editor_default_block()))
	Global.world.get_node("GameObjects/Map/Builds").add_child(block_model)


func _on_CollisionDetector_body_entered(body):
	colliding_with.append(body)


func _on_CollisionDetector_body_exited(body):
	colliding_with.erase(body)
