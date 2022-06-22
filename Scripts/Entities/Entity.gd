extends KinematicBody2D
class_name Entity

signal taken_damage(attacker, damage)


enum {
	ALIVE,
	DEAD
}

const DAMAGE_TEXT = preload("res://Scenes/Main/DamageText/DamageText.tscn")

var applied_effects := []

var max_health :int
var health     :int

var attribute_container : Node

var life_state = ALIVE


func _ready():
	attribute_container = Node.new()
	attribute_container.name = "AttributeContainer"
	add_child(attribute_container)


func take_damage(attacker:Entity, raw_damage : int) -> void:
	pass


func hit(victim, raw_damage : int) -> void:
	pass


func display_text_damage(raw_damage, duration:=1.0, color:Color= Color(1,1,1,1)):
	var damage_text = DAMAGE_TEXT.instance()
	add_child(damage_text)
	damage_text.display(str(raw_damage), duration, global_position, color)


func die() -> void:
	pass


func speak(text:String, duration:float) -> void:
	pass
	

func add_attribute(_name:String, _base:float = 0.0):
	if not attribute_container.has_node(_name):
		var new_attribute  = Attribute.new()
		new_attribute.name = _name
		new_attribute.base_value = _base
	
		attribute_container.add_child(new_attribute)


func remove_attribute(_name:String):
	if attribute_container.has_node(_name):
		attribute_container.get_node(_name).queue_free()


func get_attribute(_name:String) -> Attribute:
	if attribute_container.has_node(_name):
		return attribute_container.get_node(_name) as Attribute
	return null


func is_stunned() -> bool:
	return false


func is_alive() -> bool:
	return life_state == ALIVE


func can_move() -> bool:
	return true
