extends Panel


func _unhandled_input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("display_attributes"):
			
			if !visible:
				visible = true
				$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
				$Tween.start()
			else:
				$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
				$Tween.start()
				yield($Tween, "tween_all_completed")
				visible = false


func _process(delta):
	if visible:
		$Container/Amount/PowerAmount.text = str(GameData.player.get_attribute("Power").get_total_amount())
		$Container/Amount/DefenseAmount.text = str(GameData.player.get_attribute("Defense").get_total_amount())
