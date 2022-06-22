extends TextureButton


signal driver_changed(new_driver)

var driver:Item


func _ready():
	$Icon.texture = null



func put(new_driver:Item):
	
	driver = new_driver
	
	$Icon.texture = driver.item_model.TEXTURE
	
	_add_modifiers(driver)
	
#	if driver.item_model.SID.has("modifiers"):
#		for i in driver.item_model.SID["modifiers"].keys():
#			var value = driver.item_model.SID["modifiers"][i]
#			var attribute = GameData.player.get_attribute(i)
#
#			attribute.add_modifier(value)
#


func clear():
	$Icon.texture = null
	_remove_modifiers(driver)
	driver = null


func _on_DriverCell_pressed():
	
	if owner.IsDraggingItem():
		
		if driver:
			var dragging_driver = owner.dragging_item["I"]
			var previous_driver = driver
			
			clear()
			
			put(dragging_driver)
			
			owner.SetDraggingItem(previous_driver, 1, self)
			
		else:
			var dragging_driver = owner.dragging_item["I"]
			
			put(dragging_driver)
			
			owner.CleanDraggingItem()
		
	elif driver:
		owner.SetDraggingItem(driver, 1, self)
		clear()


func _on_DriverCell_mouse_entered():
	if not driver:
		return
	owner.update_description(driver.item_model.ID)


func _on_DriverCell_mouse_exited():
	owner.clear_description()


func _add_modifiers(driver):
	if driver.item_model.SID.has("modifiers"):
		for i in driver.item_model.SID["modifiers"].keys():
			var value = driver.item_model.SID["modifiers"][i]
			var attribute = GameData.player.get_attribute(i)

			attribute.add_modifier(value)


func _remove_modifiers(driver):
	if driver.item_model.SID.has("modifiers"):
		for i in driver.item_model.SID["modifiers"].keys():
			var value = driver.item_model.SID["modifiers"][i]
			var attribute = GameData.player.get_attribute(i)

			attribute.remove_modifier(value)
