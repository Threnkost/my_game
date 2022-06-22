extends StaticBody2D

const ITEM_DROP = preload("res://Scenes/Gameplay/ItemDrop.tscn")

export (Array, Resource) var reserves

var player_in := false
var mouse_in  := false


func _ready():
	pass


func _input(event):
	if event is InputEventMouseButton and player_in and mouse_in:
		if Input.is_action_just_pressed("left_click"):
			mine()


func mine():
	$AnimationPlayer.play("on_mine")
	Global.player.change_state("MINING")
	
	yield($AnimationPlayer, "animation_finished")
	
	Global.player.change_state("IDLE")
	
	for i in reserves:

		var drop_instance = ITEM_DROP.instance()
		
		drop_instance.initiate(i.ID, 1)
		drop_instance.global_transform.origin = global_transform.origin
		
		get_node("/root/World/GameObjects/Objects").add_child(drop_instance)
		drop_instance.scatter()
	
	queue_free()


func _on_Detector_mouse_entered():
	mouse_in = true

	$AnimationPlayer.play("hover")


func _on_Detector_mouse_exited():
	mouse_in = false
	
	$AnimationPlayer.play("idle")


func _on_PlayerDetector_body_entered(body):
	player_in = true


func _on_PlayerDetector_body_exited(body):
	player_in = false


func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
