extends Control

#BUNU DAHA SONRA WORLD'DE BULUNAN UI NODE'SİNE EKLE!
#ÇÜNKÜ HER BİR CAMPFIRE İÇİN BU CLASS TUTULMAMALI.


func _ready():
	pass
	
	
func open():
	visible = true
	
	var inv = get_node("/root/World/UI/Inventory")
	var inv_items = inv.scan_inventory()
	
	for slot in $Inventory/Slots.get_children():
		slot.is_disabled = true
	
	var i = 0	
	for data in inv_items:
		var item    = data[0]
		var amount  = data[1]
		var slot_id = data[2]
		
		if item == null or amount <= 0:
			i += 1
			continue
	
		var is_disabled = not item.item_model.SID.has("cooked_version")
			
	
		$Inventory/Slots.get_child(i).item_box.PutItem(item, amount)
		$Inventory/Slots.get_child(i).is_disabled = is_disabled
		$Inventory/Slots.get_child(i).slot_id     = slot_id
	
		if item.item_model.TYPE == "FOOD" and not is_disabled:
			$Inventory/Slots.get_child(i).is_disabled = false
	
		i += 1
	
	
func close():
	visible = false

	for slot in $Inventory/Slots.get_children():
		slot.item_box.ClearBox()


func add_food(food, amount):
	for cook_cell in $Background/Slots.get_children():
		if cook_cell.item_box.IsEmpty():
			cook_cell.item_box.PutItem(food, amount)
			cook_cell.start_cooking()
			return true
			
	return false
