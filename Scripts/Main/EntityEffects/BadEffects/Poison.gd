extends EntityEffect
class_name Poison

const TEXTURE = preload("res://Assets/2D/icons/effects/png/skill_icons36.png")

const DAMAGE_TICK = 0.5

var _damage_timer : Timer


func _ready():
	_damage_timer = Timer.new()
	_damage_timer.wait_time = DAMAGE_TICK
	add_child(_damage_timer)
	
	_damage_timer.connect("timeout", self, "_on_tick")
	_damage_timer.start()


func apply():
	pass
	
	
func end():
	
	.end()


func _on_tick():
	target.take_damage(null, value)
