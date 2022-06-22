extends StaticBody2D


var IsMouseIn = false
var IsPlayerIn = false


func _on_PlayerDetecter_body_entered(body):
	$Mouse.visible = true
	IsPlayerIn = true


func _on_PlayerDetecter_body_exited(body):
	$Mouse.visible = false
	IsPlayerIn = false


func _on_CraftingTable_mouse_entered():
	IsMouseIn = true


func _on_CraftingTable_mouse_exited():
	IsMouseIn = false


func _input(event):
	if IsMouseIn && IsPlayerIn:
		if Input.is_action_just_pressed("right_click"):
			print("Opening crafting table...")
			get_node("/root/World/UI/CraftingTablePanel").visible = true
