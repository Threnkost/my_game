extends Area2D

const SKILL_DATA = preload("res://Resources/Skills/Evolution/Raven/BlackWind.tres")

var _initial_pos
var _point
var _speed
var _angle
var _max_range
var _lerp_vector : Vector2


func start(initial_pos:Vector2, point:Vector2, speed:int, max_range:int) -> void:
	global_position = initial_pos

	_initial_pos = initial_pos
	_max_range = max_range

	_speed = speed
	_point = initial_pos.direction_to(point)

	rotation_degrees = rad2deg(initial_pos.angle_to(point))*PI


func _physics_process(delta):
	
	if global_position.distance_to(_initial_pos) >= _max_range:
		queue_free()
	else:
		global_position += _point * _speed


func _on_BlackWind_body_entered(body):
	if body is Entity:
		var damage = SKILL_DATA.data["damage"][SKILL_DATA.level-1]
		
		body.take_damage(damage)
