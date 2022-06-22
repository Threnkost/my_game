extends Entity

export (bool) var immortal = false


func _ready():
	max_health = 100
	health     = max_health

	$HealthBar.max_value = max_health
	$HealthBar.value     = health
	$HealthBar.bar_value = health


func take_damage(attacker, raw_damage:int) -> void:
	health -= raw_damage
	
	var damage_text = DAMAGE_TEXT.instance()
	add_child(damage_text)
	damage_text.display(str(raw_damage), 1, global_position)
	
	$HealthBar.display(0.1)
	$HealthBar.set_bar_value(health)
	$Timers/HealthBarDisplayTimer.start()
	
	if health <= 0 && immortal:
		health = max_health
		$HealthBar.set_bar_value(health)
	else:
		die()


func _on_HealthBarDisplayTimer_timeout():
	$HealthBar.fade_away(0.5)
