extends Node2D
class_name AgentBehavior


var valid_states := {}

var current_state_index:int  = -1
var current_state_key:String = "NULL"

var _player_ref


func init(player_ref):
	_player_ref = player_ref
	
	add_state("IDLE")
	add_state("MOVING")
	add_state("STUNNED")
	
	change_state("IDLE")
	
	print(valid_states)


func use_skill_1():
	pass
	

func use_skill_2():
	pass
	
	
func use_skill_ulti():
	pass


func update_state():
	
	match current_state_key:
		
		"IDLE":
			
			var input_vector = Vector2.ZERO
			
			input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			input_vector.y = Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
			
			if input_vector != Vector2.ZERO and _player_ref.can_move():
				change_state("MOVING")

			
		"MOVING":
			
			var vel_vector = Vector2.ZERO
			var is_moving := false
			
			if not _player_ref.can_move():
				change_state("IDLE")
				return
			
			
			if Input.is_action_pressed("move_right"):
				vel_vector.x = 1
				_player_ref.direction    = 1
				is_moving = true
				
			if Input.is_action_pressed("move_left"):
				vel_vector.x = -1
				_player_ref.direction    = -1
				is_moving = true
				
			if Input.is_action_pressed("move_up"):
				vel_vector.y = -1
				is_moving = true
				
			if Input.is_action_pressed("move_down"):
				vel_vector.y = 1
				is_moving = true

			if is_moving:
				_player_ref.move_and_slide(vel_vector * _player_ref.movement_speed)
				
			else:
				change_state("IDLE")


func add_state(key:String):
	
	if not valid_states.has(key.to_upper()):
		valid_states[key.to_upper()] = valid_states.size()
	
	
func change_state(key:String):
	
	if valid_states.has(key.to_upper()) and current_state_index != valid_states[key.to_upper()]:
		current_state_index = valid_states[key.to_upper()]
		current_state_key   = key.to_upper()
