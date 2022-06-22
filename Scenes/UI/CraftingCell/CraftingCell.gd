extends TextureButton

signal cell_pressed(cell, requested_materials)

var task_item : Item
var requested_materials := []
var amount              := 1


func init(ui, item_id, data):

	connect("cell_pressed", ui, "_on_Crafting_cell_pressed")
	
	amount    = data["amount"]
	task_item = Item.new(item_id)
	
	$Item.texture = task_item.item_model.TEXTURE
	
	for i in data["materials"].keys():
		
		var item             = Item.new(i)
		var requested_amount = data["materials"][i]
		
		var packed_data = [item, requested_amount]
		
		requested_materials.append(packed_data)
	

func craft():
	var can_craft := true
	var inv = get_node("/root/World/UI/Inventory")
	
	for i in requested_materials:
		var _material = i[0]
		var _amount   = i[1]
		
		if not inv.has_item(_material, _amount):
			can_craft = false
			break

	if not can_craft:
		return
		
	for i in requested_materials:
		var _material = i[0]
		var _amount   = i[1]
		
		inv.remove_item(_material, _amount)

	inv.AddItem(task_item, amount)
	
	print("Crafted succesfully!")


func _on_CraftingCell_pressed():
	emit_signal("cell_pressed", self, task_item.item_model.TEXTURE, requested_materials)
