extends Control


func _ready():
	pass
	
	
func init(cells : Dictionary):
	
	var index = 0
	for i in cells.keys():
		var seed_in_cell = cells[i]["seed"]
		
		$Background/Cells.get_child(index).texture_normal = seed_in_cell.item_model.TEXTURE
		$Background/Cells.get_child(index).get_node("TextureProgress").max_value = seed_in_cell.item_model.SID["growth_time"]
		
		
		index += 1


func _on_FarmStand_tick(cell_id, time_left):
	$Background/Cells.get_child(cell_id).get_node("TextureProgress").value = time_left


func _on_FarmStand_grown(cell_id):
	$Background/Cells.get_child(cell_id).texture_normal = null
