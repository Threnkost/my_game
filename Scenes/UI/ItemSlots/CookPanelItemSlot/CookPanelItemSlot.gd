extends TextureButton

const SHADER = preload("res://Shaders/WhiteBlackFX.shader")

var item_box := ItemBox.new()
var is_disabled := false setget set_slot_disabled
var slot_id


func _ready():
	item_box.connect("item_changed", self, "_on_ItemBox_item_changed")
	item_box.connect("cleaned", self, "_on_ItemBox_cleaned")
	
	$Food.texture = null
	
	
func _on_ItemBox_item_changed(new_i, new_a):
	$Food.texture = new_i.item_model.TEXTURE
	
	
func _on_ItemBox_cleaned():
	$Food.texture = null


func _on_CookPanelItemSlot_pressed():
	if not is_disabled:
		if owner.add_food(item_box.item, item_box.amount):
			item_box.ClearBox()
			
			instance_from_id(slot_id).item_box.ClearBox()


func set_slot_disabled(a):
	is_disabled = a
	
	$SlotDisabled.visible = is_disabled
