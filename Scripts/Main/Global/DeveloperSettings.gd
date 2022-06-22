extends Node


var block_editor_block_id := "test_block.tres"
var is_dev_menu_open := false


func _ready():
	pass


func get_block_editor_default_block() -> String:

	if block_editor_block_id:
		return block_editor_block_id
		
	return "test_block.tres"
