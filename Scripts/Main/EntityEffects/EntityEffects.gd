extends Node
class_name EntityEffect

onready var timer

var id       := "entity_effect"

var target = null
var value  := 0.0
var source : Entity


func _ready():
	add_child(timer)
	
	timer.connect("timeout", self, "_on_timeout")
	timer.start()


func init(_id:String):
	id = _id
	timer = Timer.new()
	
	return self


func affect(_source:Entity, _target:Entity, _duration:float, _value:float=0.0) -> void:
	target = _target
	value  = _value
	source = _source
	
	timer.one_shot  = true
	timer.wait_time = _duration
	
	target.add_child(self)

	print(id, " effect started.")
	
	apply()


#DEPRECATED
func apply() -> void:
	pass


func end() -> void:
	
	print(id, " effect ended.")
	
	timer.queue_free()
	queue_free()


func _on_timeout():
	end()
