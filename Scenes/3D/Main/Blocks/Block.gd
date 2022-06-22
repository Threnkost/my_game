extends Spatial


const OFFSET = .16

enum {
	IDLE,
	EDIT
}


var current_state = EDIT


func _physics_process(delta):
	if current_state != EDIT:
		return
	
	if Input.is_action_just_pressed("ui_right"):
		translation.x += OFFSET
		
	if Input.is_action_just_pressed("ui_left"):
		translation.x -= OFFSET
	
	if Input.is_action_just_pressed("ui_up"):
		translation.z -= OFFSET
		
	if Input.is_action_just_pressed("ui_down"):
		translation.z += OFFSET
	

	if Input.is_action_just_pressed("ui_accept"):
		
		var duplicated_block = load()
		duplicated_block.get_node("CollisionDetector").queue_free()
		duplicated_block.get_node("Mesh/StaticBody/CollisionShape").disabled = false
		duplicated_block.current_state = IDLE
		duplicated_block.get_node("Mesh").get_surface_material(0).albedo_color = Color(1, 1, 1, 1)
		
		get_node("/root/World/GameObjects/Map/Builds").add_child(duplicated_block)


func _on_CollisionDetector_body_entered(body):
	$Mesh.get_surface_material(0).albedo_color = Color("9bff0000")


func _on_CollisionDetector_body_exited(body):
	$Mesh.get_surface_material(0).albedo_color = Color(1, 1, 1, 1)
