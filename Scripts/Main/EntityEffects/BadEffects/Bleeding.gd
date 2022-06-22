extends EntityEffect
class_name Bleeding


const TEXTURE = preload("res://Assets/2D/icons/effects/png/skill_icons17.png")

const DAMAGE_TICK = 1.0

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
	if target.has_method("hit"):
		target.take_damage(GameData.player, value)
