extends Node
class_name Job

const DEFAULT_REQUESTED_EXPERIENCE = 100

signal level_up(previous_level, new_level)
signal experience_changed(new_experience, new_req_experience)

export (int, 0, 99) var level = 0
export (int) var experience   = 0 setget set_experience
export (int) var requested_experience = DEFAULT_REQUESTED_EXPERIENCE
export (PoolStringArray) var connect_to 

func _ready():
	connect("level_up", self, "_on_level_up")

	for i in connect_to:
		var node = get_node(i)
		connect("level_up", node, "_on_" + name + "_level_up")
		connect("experience_changed", node, "_on_" + name + "_experience_changed")
		
	emit_signal("level_up", 0, level)
	emit_signal("experience_changed", experience, requested_experience)


func set_experience(_exp):
	experience = _exp
	
	emit_signal("experience_changed", experience, requested_experience)

	if experience < requested_experience:
		return

	while experience >= requested_experience:
		experience -= requested_experience
		level += 1
		emit_signal("level_up", level - 1, level)


func _on_level_up(previous_level, new_level):
	requested_experience = DEFAULT_REQUESTED_EXPERIENCE + pow(level, 3)
	emit_signal("experience_changed", experience, requested_experience)
	print(name, " leveled up to : ", new_level)
