extends Sprite

const PROJECTILE_RES = preload("res://Scenes/Gunn/Bullet.tscn")

const PISTOL_RES = preload("res://Resources/Items/pistol.tres")

enum {
	RIGHT,
	LEFT
}

var dir = RIGHT

func _ready():
	
	$Range.position = Vector2(PISTOL_RES.SID["fire_range"], 0)


func _physics_process(delta):
	
	look_at(get_global_mouse_position())
#	if rotation_degrees >= 360:
#		rotation_degrees -= 360
#	elif rotation_degrees <= 360:
#		rotation_degrees += 360
#
#	if rotation_degrees >= -90 and rotation_degrees <= 90:
#		get_node("/root/World/YSort/MainPlayer").direction = 1
#
#	if rotation_degrees >= -270 and rotation_degrees <= -90:
#		get_node("/root/World/YSort/MainPlayer").direction = -1

	$RotationDegrees.text = str(int(rotation_degrees))

	if Input.is_action_just_pressed("left_click"):
		var instance = PROJECTILE_RES.instance()
		get_node("/root/World/Projectiles").add_child(instance)
		
		var vel = Vector2(PISTOL_RES.SID["fire_speed"], 0)
		
		instance.fire(global_position, vel.rotated(rotation), PISTOL_RES.SID["fire_range"], PISTOL_RES.SID["fire_damage"])


func turn_right():
	flip_v = false
	dir = RIGHT
	
	
func turn_left():
	flip_v = true
	dir = LEFT
