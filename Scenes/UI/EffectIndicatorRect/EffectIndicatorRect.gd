extends TextureRect

var _ticks    := 0.0
var _duration := 0.0


func start(icon:Texture, duration:float):
	_duration = duration
	texture   = icon

	GameData.ui.get_node("Effects").add_child(self)

	$AnimatedBar.max_value = duration
	$AnimatedBar.value     = duration


	$Timer.start()


func _on_Timer_timeout():
	_ticks += $Timer.wait_time

	$AnimatedBar.set_bar_value(_duration - _ticks)

	if _ticks >= _duration:
		$Timer.stop()
		
		print("queue free")
		queue_free()
