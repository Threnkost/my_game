extends Position2D

const FLY_DURATION = 0.25
const DURATION     = 0.75


func display(_text, _duration, _initial_pos:Vector2, color:= Color(1,1,1,1)):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var target_pos = Vector2(rng.randi_range(-20, 20), -25)
	global_position = _initial_pos
	
	$Timer.wait_time = DURATION#_duration
	$Timer.start()
	$Label.text = "-" + _text
	
	
	$Tween.interpolate_property(self, "position", Vector2(0,0), target_pos, FLY_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	#$Tween.interpolate_property(self, "rect_position", Vector2(0,0), _offset, FLY_DURATION, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "scale", Vector2(0,0), Vector2(1, 1), FLY_DURATION, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.start()


func _on_Timer_timeout():
	queue_free()
