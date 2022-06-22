extends CanvasModulate


enum seasons {
	WINTER,
	SUMMER,
	SPRING
}


enum day_states {
	DAY,
	NIGHT
}


enum weather_states {
	SUNNY,
	RAINY,
	STORMY
}


export (Color) var night_color = Color(1, 1, 1, 1)
export (Color) var day_color   = Color(1, 1, 1, 1)

export (seasons)    var current_season    = seasons.SPRING
export (day_states) var current_day_state = day_states.DAY setget set_day
export (weather_states) var current_weather_state = weather_states.SUNNY

export (bool) var auto_day_cycle := true
export (int, 1, 10000) var day_cycle_time := 60

export (float) var DAY_CHANGE_ANIM_DURATION := 1.0


func _ready():
	if auto_day_cycle:
		get_node("DayCycle").wait_time = day_cycle_time
		get_node("DayCycle").start()
	
	set_day(current_day_state)


func set_day(_new_day):
	current_day_state = _new_day
	
	match current_day_state:
		
		day_states.DAY:
			
			$Tween.interpolate_property(self, "color", color, day_color, DAY_CHANGE_ANIM_DURATION, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()
			
		day_states.NIGHT:
			
			$Tween.interpolate_property(self, "color", color, night_color, DAY_CHANGE_ANIM_DURATION, Tween.TRANS_SINE, Tween.EASE_OUT)
			$Tween.start()


func _on_DayCycle_timeout():
	
	print("day cycle!")
	
	match current_day_state:
		
		day_states.DAY:
			set_day(day_states.NIGHT)
			
		day_states.NIGHT:
			set_day(day_states.DAY)
