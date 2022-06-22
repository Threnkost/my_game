extends Spatial


export (Resource) var valid_block_data = valid_block_data as BlockModel


func set_block_model(_new_data:BlockModel) -> void:
	
	valid_block_data = _new_data
	
	if _new_data != null and _new_data is BlockModel:
		
		$Model.mesh = valid_block_data.mesh


func _on_VisibilityNotifier_screen_entered():
	visible = true


func _on_VisibilityNotifier_screen_exited():
	visible = false
