extends State

export (float) var move_speed = 10

var movement_vector = Vector3.ZERO

func init(args := {}):
	movement_vector = Vector3.ZERO
	
	
func repeat():
	movement_vector = Vector3.ZERO
	
	if DeveloperSettings.is_dev_menu_open:
		return
	
	if Input.is_action_pressed("move_right"):
		movement_vector.x = 1
		
	if Input.is_action_pressed("move_left"):
		movement_vector.x = -1
		
	if Input.is_action_pressed("move_up"):
		movement_vector.z = -1
		
	if Input.is_action_pressed("move_down"):
		movement_vector.z = 1
	
	if movement_vector.x == 1:
		owner.direction = 1
	elif movement_vector.x == -1:
		owner.direction = -1
	
	#GameConnection.SendSelfPosition(owner.global_position)
	#GameConnection.SendSelfDirection(owner.direction)
	
	(owner as KinematicBody).move_and_slide(movement_vector * move_speed)


func end():
	pass
