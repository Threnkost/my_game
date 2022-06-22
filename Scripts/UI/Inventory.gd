extends Control

const FADE_DURATION = 0.25


var dragging_item := {"I":null, "A":0, "F":null} #I: Item, A: Amount, F: From

var is_open = false


func _ready():
	visible = false

	Development() #Use this func if you try or add something.


func Development():
	var e1 = Item.new("driver1")
	var e2 = Item.new("driver2")
	
	AddItem(e1, 1)
	AddItem(e1, 1)
	AddItem(e2, 1)
	AddItem(e2, 1)
	#AddItem(e2, 1)


func Open():
	Input.set_custom_mouse_cursor(GameData.UI_MOUSE_CURSOR)
	
	modulate = Color(1, 1, 1, 0)
	visible = true
	$Tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 1), FADE_DURATION, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	is_open = true


func Close():
	Input.set_custom_mouse_cursor(GameData.GAMEPLAY_MOUSE_CURSOR)	
	
	is_open = false
	$Tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0), FADE_DURATION, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	visible = false


func AddItem(item:Item, amount :int = 1) -> bool:
	if not item:
		return false
	
	for slot in $Background/Slots.get_children():
		if item.IsSame(slot.item_box.item) and slot.item_box.amount < item.item_model.MAX_STACK:
			slot.item_box.IncreaseAmount(amount)
			return true
	
	var empty_slots = []
	for slot in $Background/Slots.get_children():
		if slot.item_box.IsEmpty():
			empty_slots.append(slot)
	
	if empty_slots.size() >= 1:
		empty_slots[0].item_box.PutItem(item, amount)
		empty_slots.remove(0)
		return true
	
	#WIP, OPTIMIZE IT LATER!
	GameConnection.SendPlayerInventoryData(GetInventoryDataAsText())
	
	return false


func update_description(item_id):
	$Description/Icon.texture = GameData.get_item_model(item_id).TEXTURE
	$Description/Name.text    = GameData.get_item_model(item_id).ID
	$Description/Text.text    = "Not descripted."
	
	
func clear_description():
	$Description/Icon.texture = null
	$Description/Name.text = ""
	$Description/Text.text = ""


func remove_item(item:Item, amount:int = 1) -> bool:
	
	for slot in $Background/Slots.get_children():
		
		if slot.item_box.CompareTo(item):
			slot.item_box.DecreaseAmount(amount)
			return true
	
	return false


func count_item(item:Item) -> int:
	var i = 0
	
	for slot in $Background/Slots.get_children():
		
		if slot.item_box.CompareTo(item):
			i += slot.item_box.amount
	
	return i


func has_item(item:Item, amount := 1) -> bool:
	
	for slot in $Background/Slots.get_children():
		
		if slot.item_box.CompareTo(item) and slot.item_box.amount >= amount:
			return true
	
	return false



func IsDraggingItem():
	return dragging_item["I"] and dragging_item["A"] > 0 and dragging_item["F"]


func SetDraggingItem(item:Item, amount:int, from):
	dragging_item = {"I":item, "A":amount, "F":from}
	$DraggingItem.texture = item.item_model.TEXTURE
	$DraggingItem/Amount.text = str(amount)


func CleanDraggingItem():
	dragging_item = {"I":null, "A":0, "F":null}
	$DraggingItem.texture = null
	$DraggingItem/Amount.text = ""


func LoadInventory(inv_data):
	for id in inv_data.keys():
		if id != "T":
			print(id)
			var item_id = inv_data[id]["I"] ; var item = Item.new(item_id)
			var amount = inv_data[id]["A"]
			
			$Background/Slots.get_child(int(id)).item_box.PutItem(item, amount)
	#GameConnection.SendPlayerInventoryData(GetInventoryDataAsText())


func GetInventoryDataAsText() -> Dictionary:
	var data    := {}
	data["T"] = OS.get_system_time_msecs()
	for slot in $Background/Slots.get_children():
		if slot.item_box.IsEmpty():
			continue
		data[str(slot.get_index())] = {}
		data[str(slot.get_index())]["I"] = slot.item_box.item.item_model.ID
		data[str(slot.get_index())]["A"] = slot.item_box.amount
		
	return data


func scan_inventory() -> Array:
	var arr := []
	
	#var i = 0
	for slot in $Background/Slots.get_children():
		if not slot.item_box.IsEmpty():
			arr.append([slot.item_box.item, slot.item_box.amount, slot.get_instance_id()])
		else:
			arr.append([null, 0, slot.get_instance_id()])
	
	return arr


func _process(delta):
	
	if IsDraggingItem():
		$DraggingItem.rect_global_position = get_global_mouse_position()


func _on_Timer_timeout():
	pass
	#var inv_data = GetInventoryDataAsText()
	#GameConnection.SendPlayerInventoryData(inv_data)
