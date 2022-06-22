extends Control


export (PackedScene)  var crafting_cell_scene
export (String, FILE) var crafting_recipes_as_file


var crafting_recipes_data := {}
var selected_cell


class RequestedItemRect:
	extends TextureRect
	
	var label_amount = Label.new()
	
	func init(_texture, _amount, player_has, _craftability):
		
		label_amount.text = "(%s, %s)" % [player_has, _amount]
		label_amount.rect_scale = Vector2(0.4, 0.4)
		label_amount.rect_position = Vector2(0, 17)
		
		label_amount.modulate = Color(1, 1, 1, 1) if _craftability else Color(1, 0, 0, 1)
		
		texture = _texture
		
		add_child(label_amount)


func _ready():
	
	crafting_recipes_data = _read_crafting_recipes_json()
	
	for i in crafting_recipes_data.keys():
	
		var cell    = crafting_cell_scene.instance()
		cell.init(self, i, crafting_recipes_data[i])
		
		$Background/Scroll/ItemList.add_child(cell)


func open():
	visible = true
	_clear()
	
	

func close():
	visible = false
	_clear()

	
func _read_crafting_recipes_json():
	var file = File.new()
	file.open(crafting_recipes_as_file, File.READ)
	var data = file.get_as_text()
	data = parse_json(data)
	
	file.close()
	return data


func _clear():
	for child in $Background/RequstedMaterials.get_children():
		child.queue_free()


func _on_Crafting_cell_pressed(cell, texture, requested_materials):
	
	selected_cell = cell

	$Background/Item.texture = texture

	var inv = get_node("/root/World/UI/Inventory")
	
	_clear()

	for i in requested_materials:
		var item   = i[0]
		var amount = i[1]
		
		var item_count_player_has = inv.count_item(item)
		var rect = RequestedItemRect.new()
		rect.init(item.item_model.TEXTURE, amount, item_count_player_has, item_count_player_has >= amount)
		
		$Background/RequstedMaterials.add_child(rect)


func _on_CraftButton_pressed():
	if selected_cell:
		
		selected_cell.craft()
