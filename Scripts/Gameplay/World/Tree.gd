extends StaticBody2D

const COLOR_NORMAL = Color(1, 1, 1, 1)
const COLOR_WHEN_PLAYER_BEHIND_TREE = Color(1, 1, 1, 0.6)
const DURATION_OF_ANIM_PLAYER_BEHIND_TREE = 0.25


enum {
	IDLE,
	GETTING_HIT,
	FALLEN
}


var current_state = IDLE
var health    := 3
var mouse_in  := false
var screen_in := false
var player


func _ready():
	pass
	#$TreeSprite.position = Vector2(0, 0)


func _on_Tree_mouse_entered():
	mouse_in = true
	
	print("Mouse in")


func _on_Tree_mouse_exited():
	mouse_in = false


func _physics_process(delta):
	match current_state:
		IDLE:
			$AnimationPlayer.play("idle")
			
		GETTING_HIT:
			$AnimationPlayer.play("getting_damage")


func _input(event):
	if Input.is_action_just_pressed("left_click") and mouse_in and player:

		if player.get_node("Hand").equipped_tool and "_axe" in player.get_node("Hand").equipped_tool.item_model.ID:
		
			player.change_state("TreeChoppingState", {"target_tree":self})
		else:
			print("Eline bir balta al!")


func _on_Hitbox_body_entered(body):
	player = body


func _on_Hitbox_body_exited(body):
	player = null


func damage():
	health -= 1 + (Global.skill_res["woodpecker"].level)
	if health <= 0:
		fall()


func fall():
	var amount = 5
	amount += Global.skill_res["wood_looting"].level
	
	#GameConnection.drop_item("log", amount, global_position)
	
	queue_free()


func _on_VisibilityNotifier_screen_entered():
	visible = true
	screen_in = true


func _on_VisibilityNotifier_screen_exited():
	visible = false
	screen_in = false


func _on_Detector2_body_entered(body):
	$Tween.interpolate_property($Sprite, "modulate", Color(1, 1, 1, 1), COLOR_WHEN_PLAYER_BEHIND_TREE, DURATION_OF_ANIM_PLAYER_BEHIND_TREE, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()


func _on_Detector2_body_exited(body):
	$Tween.interpolate_property($Sprite, "modulate", COLOR_WHEN_PLAYER_BEHIND_TREE, Color(1, 1, 1, 1), DURATION_OF_ANIM_PLAYER_BEHIND_TREE, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()



func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
