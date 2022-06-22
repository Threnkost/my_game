extends Control

const DISPLAY_DURATION = .2
const DISPLAY_TRANS    = Tween.TRANS_SINE
const DISPLAY_EASE     = Tween.EASE_OUT

onready var _tween = $Tween


func open():
	Input.set_custom_mouse_cursor(GameData.UI_MOUSE_CURSOR)
	
	visible = true
	_tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), DISPLAY_DURATION, DISPLAY_TRANS, DISPLAY_EASE)
	_tween.start()
	

func close():
	Input.set_custom_mouse_cursor(GameData.GAMEPLAY_MOUSE_CURSOR)	
	
	_tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), DISPLAY_DURATION, DISPLAY_TRANS, DISPLAY_EASE)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	visible = false
