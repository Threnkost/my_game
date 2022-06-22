extends EntityEffect
class_name SpeedBoost


const TEXTURE = preload("res://Assets/2D/icons/effects/png/skill_icons30.png")
var _texture_rect


func apply():
	_texture_rect = Global.ui.add_effect_texture(TEXTURE)
	
	target.movement_speed += value
	
	
func end():
	target.movement_speed -= value
	
	_texture_rect.queue_free()
	.end()
