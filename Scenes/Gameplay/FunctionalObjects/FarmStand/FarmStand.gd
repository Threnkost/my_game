extends StaticBody

signal tick(cell_id, time_left)
signal grown(cell_id)


var cells := {}
var player_in := false


func _ready():
	var seed1 = Item.new("simple_seed")
	
	var cell_data = {
		"seed":seed1,
		"plant_time":OS.get_system_time_msecs()
	}
	
	for i in range(0,2):
		cells[i] = cell_data.duplicate()
		print(cells[i])
	
	
func _physics_process(delta):
	for i in cells.keys():
		if cells[i]["seed"]:
			var time_left = (OS.get_system_time_msecs() - cells[i]["plant_time"])/1000
			emit_signal("tick", i, time_left)
		if cells[i]["seed"] and cells[i]["plant_time"] + cells[i]["seed"].item_model.SID["growth_time"]*1000 <= OS.get_system_time_msecs():
			emit_signal("grown", i)


func _input(event):
	if 1 == 2:
	#if Input.is_action_just_pressed("left_click") and player_in:
		var screen_pos = get_viewport().get_global_transform_with_canvas()[2]
		var offset_y = -32
		screen_pos.x = int(screen_pos.x) ; screen_pos.y = int(screen_pos.y)
		
		$CanvasLayer/FarmStandPanel.rect_position = Vector2(screen_pos.x, screen_pos.y + offset_y)
		$CanvasLayer/FarmStandPanel.visible = true if not $CanvasLayer/FarmStandPanel.visible else false
		
		$CanvasLayer/FarmStandPanel.init(cells)


func harvest(cell_id):
	var product = Item.new(cells[cell_id]["seed"].item_model.SID["product"])
	var amount  = cells[cell_id]["seed"].item_model.SID["amount"]
	
	cells[cell_id]["seed"]       = null
	cells[cell_id]["plant_time"] = 0 

	Global.inventory.AddItem(product, amount)


func _on_PlayerDetection_body_entered(body):
	player_in = true


func _on_PlayerDetection_body_exited(body):
	player_in = false
