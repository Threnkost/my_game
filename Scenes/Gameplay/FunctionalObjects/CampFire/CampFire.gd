extends StaticBody2D


var player_in := false
var mouse_in  := false

#USELESS FOR NOW.
#I WILL NEED THIS WHEN I NEED TO INTEGRATE CAMP FIRE TO SERVER.
#var cooking_cells := {
#	0:{"food":null, "amount":0},
#	1:{"food":null, "amount":0},
#	2:{"food":null, "amount":0}
#}


func _ready():
	pass
	
	
func interact():
	if $CookPanel.visible:
		$CookPanel.close()
	else:
		$CookPanel.open()


func _on_DetectBox_body_entered(body):
	player_in = true


func _on_DetectBox_body_exited(body):
	player_in = false


func _on_CampFire_mouse_entered():
	mouse_in = true


func _on_CampFire_mouse_exited():
	mouse_in = false


func _input(event):
	if Input.is_action_just_pressed("left_click") and player_in and mouse_in:
		interact()
