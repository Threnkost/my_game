extends Node


func _input(event):
	if event is InputEventMouseButton:
		GameEvents.emit_signal("left_clicked_on_game_screen", owner.get_global_mouse_position())
	
	if event is InputEventKey and not DeveloperSettings.is_dev_menu_open:
		
		if Input.is_action_just_pressed("open_inventory"):
			var inv_node = get_node("/root/World/UI/Inventory")
			inv_node.Open() if not inv_node.is_open else inv_node.Close()
		
		if Input.is_action_just_pressed("game_menu"):

			var node = get_node("/root/World/UI/ESCMenu")
			node.open() if not node.visible else node.close()
 
		if Input.is_action_just_pressed("crafting_menu"):
			
			var node = get_node("/root/World/UI/CraftingPanel")
			node.open() if not node.visible else node.close()
			

		if Input.is_action_just_pressed("skill_tree"):
			
			var node = get_node("/root/World/UI/SkillTree")
			node.open() if not node.visible else node.close()
#
#		if Input.is_action_just_pressed("change_block_placer_mode"):
#
#			var block_placer = Global.world.get_node("GameObjects/Map/BlockPlacer")
#
#			if block_placer.is_editing():
#				block_placer.stop_editing()
#
#			else:
#				block_placer.start_editing(Global.player.transform.origin)


		if Input.is_action_just_pressed("SKILL_ULTI_KEY"):
			owner.character_behavior.use_skill_ulti()
	
		if Input.is_action_just_pressed("SKILL_1_KEY"):
			owner.character_behavior.use_skill_1()
			
		if Input.is_action_just_pressed("SKILL_2_KEY"):
			owner.character_behavior.use_skill_2()
