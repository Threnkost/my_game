extends Entity


#-50, 0.75

signal player_health_changed(health, max_health)
signal player_satiety_changed(satiety, max_satiety)
signal player_shield_changed(shield, max_shield)


export (Resource) var agent = agent as Agent
var character_behavior:AgentBehavior

export(Color) var damage_text_color

enum states {
	NOTHING = -1,
	IDLE,
	MOVING,
	SKILL_CASTING
}

var movement_speed := 1.0 setget set_movement_speed
var direction := 1

var max_satiety := 100 setget set_max_satiety
var satiety     := 100 setget set_satiety

var max_shield := 100 setget set_max_shield
var shield     := 100 setget set_shield

var shield_permeability        := 0.25
var shield_regeneration_amount := 1.0
var health_regen_rate := 2.0


var is_invisible := false


func _ready():
	set_character(agent)
	health = max_health	
	
	connect("player_health_changed", get_node("/root/World/UI/UI"), "_on_Player_health_changed")
	connect("player_satiety_changed", get_node("/root/World/UI/UI"), "_on_Player_satiety_changed")
	connect("player_shield_changed", get_node("/root/World/UI/UI"), "_on_Player_shield_changed")


	emit_signal("player_health_changed", health, max_health)
	emit_signal("player_satiety_changed", satiety, max_satiety)
	emit_signal("player_shield_changed", shield, max_shield)

	get_node("/root/World/UI/UI").set_portrait(agent.portrait)
	get_node("/root/World/UI/UI").set_agent_name(agent.name)
	
	add_attribute("Power", 15.0)
	add_attribute("Defense", 20.0)



func set_character(character : Agent) -> void:
#	if agent == character:
#		return

	if character_behavior:
		character_behavior.queue_free()

	agent = character

	max_health        = agent.health
	health_regen_rate = agent.health_regen_rate
	movement_speed    = agent.movement_speed

	var behavior_scene_instance = character.behavior_scene.instance()
	add_child(behavior_scene_instance)

	character_behavior = behavior_scene_instance
	character_behavior.init(self)


func _physics_process(delta):
	
	character_behavior.update_state()

#	if GameConnection.is_online():
#		var player_data = { #OYUNCUNUN SÜREKLİ GÜNCELLENEN VERİLERİ BU ŞEKİLDE GÖNDERİLECEK.
#			"T": OS.get_system_time_msecs(), 
#			"P": Vector2(int(global_position.x), int(global_position.y)),
#			"D": direction
#		}
#		GameConnection.SendPlayerData(player_data)


func take_damage(attacker, raw_damage):
	if shield > 0:
		var damage = int(raw_damage * shield_permeability)
		var shield_damage = raw_damage * (1 - shield_permeability)
		
		print("Shield Damage : ",shield_damage)
		
		set_health(health - damage)
		set_shield(shield - shield_damage)
	
	else:
		set_health(health - raw_damage)
	display_text_damage(raw_damage, 1.0, damage_text_color)
	emit_signal("taken_damage", attacker, raw_damage)

	
#SETTERS
	
func set_health(new_health):
	health = new_health
	if health > max_health:
		health = max_health
	emit_signal("player_health_changed", health, max_health)
	
	
func set_max_health(new_max_health):
	max_health = new_max_health
	emit_signal("player_health_changed", health, max_health)


func set_satiety(new_satiety):
	satiety = new_satiety
	emit_signal("player_satiety_changed", satiety, max_satiety)
	
	
func set_max_satiety(new_max_satiety):
	max_satiety = new_max_satiety
	emit_signal("player_satiety_changed", satiety, max_satiety)


func set_movement_speed(_value:float):
	movement_speed = _value
	if movement_speed < 0:
		movement_speed = 0.0


func set_shield(_value:int):
	shield = _value
	
	if shield > max_shield:
		shield = max_shield
	
	emit_signal("player_shield_changed", shield, max_shield)
	
	
func set_max_shield(_value:int):
	max_shield = _value
	emit_signal("player_shield_changed", shield, max_shield)


#GETTERS

func can_move() -> bool:
	var can_move = true
	
	for i in $EntityEffects.get_children():
		
		if i is Stun:
			can_move = false
	
	return can_move


func get_movement_speed():
	return movement_speed


func _on_ShieldRegenerationTimer_timeout():
	set_shield(shield + shield_regeneration_amount)


func _on_HealthRegenTimer_timeout():
	if health < (max_health/2):
		set_health(health + health_regen_rate)


func get_job_level(job_name : String) -> int:
	if $Jobs.has_node(job_name):
		return $Jobs.get_node(job_name).level
	return 0


func speak(text:String, duration:float):
	
	$SpeakBox.text = text
	$SpeakBox/Timer.wait_time = duration
	$SpeakBox/Timer.start()
	

func _on_Speaking_timeout():
	$SpeakBox.text = ""
