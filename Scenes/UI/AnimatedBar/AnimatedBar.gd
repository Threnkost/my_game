extends TextureProgress

export (bool) var display_on_start = true

var bar_value setget set_bar_value
var is_visible := true setget ,is_visible


func _ready():
	modulate = Color(1,1,1,1) if display_on_start else Color(1,1,1,0)
	is_visible = display_on_start


func set_bar_value(new_value):
	var previous_value = bar_value
	bar_value          = new_value
	
	
	$Tween.interpolate_property(self, "value", previous_value, bar_value, 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	

func get_bar_value():
	return bar_value


func fade_away(duration):
	if not is_visible:
		return
	
	is_visible = false
	
	$Tween.remove_all()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	

func display(duration = 0.1):
	if is_visible:
		return
	
	is_visible = true
	
	$Tween.remove_all()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()


func is_visible():
	return is_visible
