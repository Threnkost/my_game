extends Resource
class_name SkillData

signal level_changed(new_level)

export (String) var skill_id
export (Texture) var texture
export (int, 0, 99) var level setget set_level
export (int, 1, 99) var max_level
export (int) var cooldown
export (Dictionary) var data

var last_usage_time:int = 0


func set_level(new_level):
	level = new_level
	
	emit_signal("level_changed", level)


func get_cooldown():
	return cooldown * 1000
