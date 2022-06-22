extends TextureButton


var item_box := ItemBox.new()


func _ready():
	$CookProgress.value = 0
	
	item_box.connect("item_changed", self, "_on_ItemBox_item_changed")
	item_box.connect("cleaned", self, "_on_ItemBox_cleaned")


func _on_ItemBox_item_changed(new_item, new_amount):
	$Food.texture = new_item.item_model.TEXTURE


func _on_ItemBox_cleaned():
	$Food.texture = null



func _on_CookTimer_timeout():
	$CookProgress.max_value = item_box.item.item_model.SID["cook_time"]
	$CookProgress.visible = true
	$CookProgress.value += 1
	
	if $CookProgress.value >= $CookProgress.max_value:
		$CookTimer.stop()
		$CookProgress.visible = false
		
		var cooked_food_res = load(item_box.item.item_model.SID["cooked_version"])
		var cooked_food_ins = Item.new(cooked_food_res.ID)
		
		item_box.item.queue_free()
		item_box.ClearBox()
		item_box.PutItem(cooked_food_ins, 1)


func _on_FoodSlot_pressed():
	if not item_box.IsEmpty():
		
		$CookProgress.visible = false
		$CookTimer.stop()
		
		get_node("/root/World/UI/Inventory").AddItem(item_box.item, item_box.amount)
		
		item_box.ClearBox()
		
		
func start_cooking():
	$CookTimer.start()


