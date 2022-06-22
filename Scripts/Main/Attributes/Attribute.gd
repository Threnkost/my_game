extends Node
class_name Attribute


signal value_updated(new_value)


export (float) var base_value setget set_base_value


var modifiers := []


func get_total_amount():
	var i = base_value
	for modifier in modifiers:
		i += modifier
	
	return i


func add_modifier(modifier:float):
	modifiers.append(modifier)


func remove_modifier(modifier:float):
	modifiers.erase(modifier)


func set_base_value(new_value:float):
	base_value = new_value
