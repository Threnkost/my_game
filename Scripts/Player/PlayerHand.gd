extends Sprite


var equipped_tool : Item = null


func equip(new_tool):
	equipped_tool = new_tool
	var instance = load(equipped_tool.item_model.SID["equipment_scene"]).instance()
	add_child(instance)
	
	

func unequip():
	if not equipped_tool:
		return
		
	get_child(0).queue_free()
	equipped_tool = null

