extends Spatial


enum {
	IDLE,
	CHOPPING
}

var state = IDLE


func _physics_process(delta):
	
	match state:
		
		IDLE:
			$AnimationPlayer.play("idle")
			
		CHOPPING:
			$AnimationPlayer.play("tree_chopping")


func turn_right():
	pass
	#$AxeTexture.position.x = abs($AxeTexture.position.x)
	$AxeTexture.flip_h     = false


func turn_left():
	pass
#	$AxeTexture.position.x = -abs($AxeTexture.position.x)
	$AxeTexture.flip_h    = true
