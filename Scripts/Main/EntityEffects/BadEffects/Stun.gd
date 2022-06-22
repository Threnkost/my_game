extends EntityEffect
class_name Stun

const TEXTURE = preload("res://Assets/2D/icons/effects/png/skill_icons5.png")

var _texture_rect

func init(id):
	return .init(id)


func apply():
	
	_texture_rect = GameData.ui.add_effect_texture(TEXTURE)
	
	
func end():
	_texture_rect.queue_free()
	
	.end()
