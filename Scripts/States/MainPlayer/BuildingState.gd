extends State

signal building_done()


var block = 31#preload("res://Resources/Items/CraftingTable.tres")
var target_build


func _ready():
	pass


func init(args := {}):
	target_build = block.data["TargetBuild"].instance()
	
	get_node("/root/World/YSort").call_deferred("add_child", target_build)

	
func repeat():
	get_parent().get_node("MovementState").repeat()
	
	var mouse_pos = get_node("/root/World").get_global_mouse_position()

	target_build.global_position.x = floor((mouse_pos.x) / 16) * 16 + 5
	target_build.global_position.y = floor((mouse_pos.y) / 16) * 16 + 5

	
	if Input.is_action_just_pressed("right_click") && target_build.IsBuildable():
	
		target_build.Build(target_build.global_position, get_node("/root/World"))
	
	
		emit_signal("building_done")
	
	
func end():
	if target_build:
		target_build.queue_free()
