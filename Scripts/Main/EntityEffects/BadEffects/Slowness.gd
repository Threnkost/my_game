extends EntityEffect
class_name Slowness

const TEXTURE = preload("res://Assets/2D/icons/effects/png/skill_icons27.png")

var _texture_rect
var value_to_decrease


func apply():
	
	_texture_rect = Global.ui.add_effect_texture(TEXTURE)
	
	
	var target_speed = target.get_movement_speed()
	value_to_decrease = target_speed * value
	
	target.set_movement_speed(target_speed - value_to_decrease)
	
	
func end():
	target.set_movement_speed(target.get_movement_speed() + value_to_decrease)
	_texture_rect.queue_free()
	
	.end()

	
