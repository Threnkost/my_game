extends EntityEffect
class_name ShieldRegenerationBoost

const EFFECT_RECT = preload("res://Scenes/UI/EffectIndicatorRect/EffectIndicatorRect.tscn")
const TEXTURE = preload("res://Assets/2D/icons/effects/png/skill_icons22.png")


func apply():
	var effect_rect = EFFECT_RECT.instance()
	effect_rect.start(TEXTURE, timer.wait_time)
	
	target.shield_regeneration_amount += value
	
	
func end():
	target.shield_regeneration_amount -= value
	
	.end()
