extends AgentBehavior


"""
YETENEK 2: Ani Darbe
Raven, önündeki düşmanlara hızlı bir darbe yaparak hasar verir.
Hasar: +10/15/20/25/35 + Sahip Olunan Gücün %10/20/30/40/50'si
Yardımcı Pasif 1: Raven, düşmana ilave %10 hasar verir ve onu kanatır.
Yardımcı Pasif 2: Raven, düşmana hasar verince kalkan kazanır.
"""

const EFFECT_INDICATOR_RECT = preload("res://Scenes/UI/EffectIndicatorRect/EffectIndicatorRect.tscn")

const SKILL_1_CHARACTER_DIALOGUES := ["Haha!", "Hihi", "Take it!"]
const SKILL_ULTI_CHARACTER_DIALOGUES := ["Let's start!", "I'm coming.."]


const INVISIBLE_TRANSIT_DURATION = 0.25
const INVISIBLE_TRANSIT_COLOR    = Color(1,1,1,0.5)
const INVISIBLE_TRANSIT_TRANS    = Tween.TRANS_LINEAR


var _ulti_speed_increment := 0

var _effect_rects := []

var _leaping_vector : Vector2
var _is_leaping := false

var _is_hardened_shield_active := false
var _is_powered_attack_active  := true
var _is_ulti_active            := false


onready var SKILL_1_DATA    :SkillData = preload("res://Resources/Skills/Evolution/Raven/BlackWind.tres")
onready var SKILL_2_DATA    :SkillData = preload("res://Resources/Skills/Evolution/Raven/QuickImpact.tres")
onready var SKILL_ULTI_DATA :SkillData = preload("res://Resources/Skills/Evolution/Raven/Invisible.tres")


var damaged_enemies_by_dashing := []

func init(player_ref):
	.init(player_ref)
	
	$ImpactHitbox/VFX.visible = false
	$Sword/CollisionPolygon2D.disabled = true
	
	_player_ref.connect("taken_damage", self, "_on_Player_took_damage")
	
	GameEvents.connect("left_clicked_on_game_screen", self, "_on_Left_clicked_on_game_screen")
	
	$Shield.modulate = Color(1,1,1,0)
	
	add_state("DASHING")
	add_state("USING_SKILL_HARD_IMPACT")
	add_state("ATTACKING_WITH_SWORD")


func use_skill_1() -> void:
	if SKILL_1_DATA.level < 1:
		return
	
	end_skill_ulti()
	change_state("USING_SKILL_HARD_IMPACT")

	
func use_skill_2() -> void:

	
	if _is_powered_attack_active:
		_is_powered_attack_active = false
		
	else:
		_is_powered_attack_active = true
	
	
func use_skill_ulti() -> void:
	if current_state_key != "IDLE" and current_state_key != "MOVING":
		return
	
	if _is_ulti_active:
		return

	if SKILL_ULTI_DATA.level == 0:
		return

	var invisible_duration = SKILL_ULTI_DATA.data["invisible_duration"][SKILL_ULTI_DATA.level-1]
	
	get_node("Timers/UltiDurationTimer").wait_time = invisible_duration
	get_node("Timers/UltiDurationTimer").start()
	
	_is_ulti_active       = true
	
	var EFFECT_RECT_SCENE = load("res://Scenes/UI/EffectIndicatorRect/EffectIndicatorRect.tscn")
	var effect_rect_1 = EFFECT_RECT_SCENE.instance()
	var effect_rect_2 = EFFECT_RECT_SCENE.instance()


	effect_rect_1.start(SKILL_ULTI_DATA.texture, invisible_duration)
	effect_rect_2.start(load("res://Assets/2D/icons/effects/png/skill_icons30.png"), invisible_duration)

	_effect_rects.append(effect_rect_1)
	_effect_rects.append(effect_rect_2)

	_ulti_speed_increment = SKILL_ULTI_DATA.data["speed_increment"][SKILL_ULTI_DATA.level-1]
	self._player_ref.is_invisible = true
	self._player_ref.movement_speed += _ulti_speed_increment
	
	$Tween.interpolate_property($Body, "modulate", Color(1,1,1,1), INVISIBLE_TRANSIT_COLOR, INVISIBLE_TRANSIT_DURATION, INVISIBLE_TRANSIT_TRANS, Tween.EASE_OUT)
	$Tween.start()
	
	
func _on_Ulti_timeout():
	end_skill_ulti()


func _on_Left_clicked_on_game_screen(global_position): #LEAPING
	
	if _is_ulti_active:
		get_node("Timers/UltiDurationTimer").stop()
		end_skill_ulti()
		
		_leaping_vector = (_player_ref.global_position as Vector2).direction_to(global_position)
		_is_leaping = true

	elif _is_powered_attack_active && (current_state_key == "IDLE" or "MOVING"):
		change_state("ATTACKING_WITH_SWORD")
		end_skill_ulti()


func _physics_process(delta):
	
	$Sword.visible = _is_powered_attack_active
	
	#ULTI LEAPING
	if not _leaping_vector.is_equal_approx(Vector2.ZERO):
		
		_leaping_vector = lerp(_leaping_vector, Vector2.ZERO, 0.2)

		_player_ref.move_and_slide(_leaping_vector * SKILL_ULTI_DATA.data["leaping_speed"])
		
		change_state("DASHING")
		
	elif _is_leaping:
		_is_leaping = false
		change_state("IDLE")
		
		damaged_enemies_by_dashing.clear()
		#_player_ref.current_state = _player_ref.states.IDLE


func update_state():
	.update_state()
	
	$DashHitbox/CollisionShape.disabled = true
	
	if current_state_key != "ATTACKING_WITH_SWORD":
		if $Sword.visible:
			$Sword/SwordSprite/SwordAnimationPlayer.play("idle")
	
	match current_state_key:
		
		"IDLE":
			$AnimationPlayer.play("idle")
			
		"MOVING":
			$AnimationPlayer.play("idle")
		
		"DASHING":
			$AnimationPlayer.play("dash_attack")
			
			$DashHitbox/CollisionShape.disabled = false
			
		"USING_SKILL_HARD_IMPACT":
			$AnimationPlayer.play("raven_skill_impact_S")
			
		"ATTACKING_WITH_SWORD":
			$Sword/SwordSprite/SwordAnimationPlayer.play("attack_S")


func _on_DashHitbox_body_entered(body):

	if current_state_key == "DASHING" and not damaged_enemies_by_dashing.has(body):
		var damage = SKILL_ULTI_DATA.data["dash_damage"]
		body.take_damage(_player_ref, damage)
		
		damaged_enemies_by_dashing.append(body)


func _on_RavenShieldTimer_timeout():
	end_skill_hardened_shield()


func _on_Player_took_damage(attacker, damage):

	if attacker is Entity:
		
		if _is_hardened_shield_active: #REFLECTS THE DAMAGE WHILE HARDENED SHIELD SKILL IS ACTIVE.

			var cellular_shield_data = GameData.get_skill_data("Raven", "cellular_shield")
			var reflection_rate = cellular_shield_data.data["reflection_rate"][cellular_shield_data.level]
			var amount_to_damage = (1 + damage) * reflection_rate
			
			attacker.take_damage(_player_ref, amount_to_damage)


func apply_skill_hardened_shield():
	_player_ref.get_node("Timers/ShieldRegenerationTimer").stop()

	$Tween.interpolate_property($Shield, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

	$Timers/RavenShieldTimer.start()
	_is_hardened_shield_active = true

	var effect_rect = EFFECT_INDICATOR_RECT.instance()
	effect_rect.start(load("res://Assets/2D/icons/effects/png/skill_icons21.png"), $"Timers/RavenShieldTimer".wait_time)


func end_skill_hardened_shield():
	_is_hardened_shield_active = false
	_player_ref.get_node("Timers/ShieldRegenerationTimer").start()
	$Tween.interpolate_property($Shield, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()


func end_skill_ulti():
	if not _is_ulti_active:
		return
		
	self._player_ref.is_invisible = false
	self._player_ref.movement_speed -= _ulti_speed_increment
	_is_ulti_active = false
	
	$Tween.interpolate_property($Body, "modulate", INVISIBLE_TRANSIT_COLOR, Color(1,1,1,1), INVISIBLE_TRANSIT_DURATION, INVISIBLE_TRANSIT_TRANS, Tween.EASE_OUT)
	$Tween.start()
	
	for i in _effect_rects:
		i.queue_free()
	
	_effect_rects.clear()


func _on_ImpactHitbox_body_entered(body):
	if body is Entity:
		
		var impact_damage = (SKILL_2_DATA.data["base_damage"][SKILL_2_DATA.level] + 
			_player_ref.get_attribute("Power").get_total_amount() * SKILL_2_DATA.data["power_rate"][SKILL_2_DATA.level])
		
		var cellular_shield_data = GameData.get_skill_data("Raven", "cellular_shield")
		var dark_poison_data     = GameData.get_skill_data("Raven", "dark_poison")

		var current_time = OS.get_system_time_msecs()

		if cellular_shield_data.level >= 1 && current_time >= cellular_shield_data.last_usage_time + cellular_shield_data.get_cooldown():
			cellular_shield_data.last_usage_time = current_time
			apply_skill_hardened_shield()
			
			_player_ref.shield += cellular_shield_data.data["shield_theft"][cellular_shield_data.level] * impact_damage
			
		if dark_poison_data.level >= 1 && current_time >= dark_poison_data.last_usage_time + dark_poison_data.get_cooldown():
			dark_poison_data.last_usage_time = current_time

			var poison = Poison.new().init(str(OS.get_system_time_msecs()))
			poison.affect(_player_ref, body, 5.0, dark_poison_data.data["damage_per_second"][dark_poison_data.level])

		body.take_damage(GameData.player, impact_damage)


func _on_AnimationPlayer_animation_finished(anim_name):
	pass


func _on_Sword_body_entered(body):
	if body is Entity:
		
		var soul_breaker_skill_data = GameData.get_skill_data("Raven", "soul_breaker")
		var level = soul_breaker_skill_data.level
		
		var damage = soul_breaker_skill_data.data["base_damage"][level] + soul_breaker_skill_data.data["power_rate"][level] * _player_ref.get_attribute("Power").get_total_amount()
		
		body.take_damage(_player_ref, damage)
