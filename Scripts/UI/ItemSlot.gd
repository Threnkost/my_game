extends TextureButton


var item_box : ItemBox = ItemBox.new()


func _ready():
	item_box.connect("item_changed", self, "_on_ItemBox_item_changed")
	item_box.connect("cleaned", self, "_on_ItemBox_cleaned")

	$Amount.text = ""


func _on_ItemBox_item_changed(item, amount):
	$ItemIcon.texture = item.item_model.TEXTURE
	$Amount.text = str(amount)

	#WIP, OPTIMIZE IT LATER!
	GameConnection.SendPlayerInventoryData(owner.GetInventoryDataAsText())


func _on_ItemBox_cleaned():
	$ItemIcon.texture = null
	$Amount.text = ""

	#WIP, OPTIMIZE IT LATER!
	GameConnection.SendPlayerInventoryData(owner.GetInventoryDataAsText())


func _on_ItemButton_pressed():
	
	if not item_box.IsEmpty():
		var previous_item = item_box.item
		var previous_item_amount = item_box.amount
		
		if owner.IsDraggingItem():
			item_box.PutItem(owner.dragging_item["I"], owner.dragging_item["A"])
		else:
			item_box.ClearBox()
		owner.SetDraggingItem(previous_item, previous_item_amount, self)
		
	elif owner.IsDraggingItem():
		item_box.PutItem(owner.dragging_item["I"], owner.dragging_item["A"])
		owner.CleanDraggingItem()


func _on_ItemButton_mouse_entered():
	if item_box.item:
		owner.update_description(item_box.item.item_model.ID)


func _on_ItemButton_mouse_exited():
	owner.clear_description()
