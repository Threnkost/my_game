extends Node


func load_game_data():
	pass


func load_world_data():
	pass


func load_inventory():
	pass



func load_item_data(item_id:String, data:={}):
	print("[GAME LOADER] Loading item: ", item_id)
	
	var item_res = load("res://Resources/Items/" + item_id + ".tres")
	
	if item_res:
		for key in data.keys():
			item_res.SID[key] = data[key]
		print("[GAME LOADER] Data loaded '%s' : %s" % [item_id, data])
	else:
		print("[ERROR] Couldn't load : ", item_id, " Client does not have that item resource.")
