extends Area2D


var _initial_pos
var _final_pos
var _velocity
var _radius
var _damage

var is_fired := false


func fire(from, velocity, radius, damage):

	_initial_pos = from
	_velocity    = velocity
	_radius      = radius
	_damage      = damage

	is_fired = true
	
	global_position = from


func _physics_process(delta):
	if is_fired:
		
		global_position += _velocity * delta
		
		if global_position.distance_to(_initial_pos) >= _radius:
			queue_free()


func _on_Bullet_body_entered(body):
	print("Shot!")
#
#	if body.get_parent().is_in_group("Enemy") && body.get_parent().has_method("hit"):
#		body.hit(_damage)
#		queue_free()


func _on_Bullet_area_entered(body):
	
	if body.get_parent().is_in_group("Enemy") && body.get_parent().has_method("hit"):
		body.get_parent().hit(_damage)
		queue_free()

