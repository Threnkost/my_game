extends Area2D


export (Color) var unavailable
export (PackedScene) var build

var is_colliding = false


func _on_CraftingTableTemplate_body_entered(body):
	is_colliding = true
	modulate = unavailable


func _on_CraftingTableTemplate_body_exited(body):
	is_colliding = false
	modulate = Color(1, 1, 1, 1)


func IsBuildable():
	return !is_colliding


func Build(target_pos, world):
	if IsBuildable():
		var instance = build.instance()
	
		world.get_node("YSort").add_child(instance)
		instance.global_position = target_pos
		
		queue_free()
