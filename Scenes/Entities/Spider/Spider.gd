extends Entity

enum {
	IDLE,
	SURPRISED,
	CHASING,
	ATTACKING,
	DYING
}

const FLASH_MATERIAL = preload("res://Shaders/Flash.material")

const ATTACK_RANGE = 20
const ATTACK_STATE_COOLDOWN = 1500#ms

export(int) var speed
export(int) var power

onready var anim_player : AnimationPlayer = $AnimationPlayer

var current_state = CHASING
var target

var last_attack_time := 0


func _ready():
	max_health = 120
	health = 120
	
	$HealthBar.max_value = max_health
	$HealthBar.value = health


func _physics_process(delta):
	update_state()


func update_state():
	match current_state:
		IDLE:
			anim_player.play("idle")
	
		CHASING:
			if not target:
				current_state = IDLE
				return
				
			if target.is_invisible:
				return
				
			if position.distance_to(target.position) >= ATTACK_RANGE:
					
				anim_player.play("idle")
					
				if GameData.player.is_invisible:
					return
				
				var velocity = position.direction_to(target.position)
			
				move_and_slide(velocity * speed)
				
			elif last_attack_time + ATTACK_STATE_COOLDOWN <= OS.get_system_time_msecs():
				current_state = ATTACKING
				last_attack_time = OS.get_system_time_msecs()
				
			else:
				anim_player.play("idle")
				
				
		ATTACKING:
			if target.is_invisible:
				return
			anim_player.play("attacking")


func _on_AnimationPlayer_animation_finished(anim_name):

	if anim_name == "attacking":
		hit(target, power)
		current_state = CHASING


func _on_TargetDetector_body_entered(body):
	target = body
	current_state = CHASING


func hit(victim, power) -> void:
	victim.take_damage(self, power)


func take_damage(attacker, raw_damage) -> void:
	health -= raw_damage
	$HealthBar.set_bar_value(health)
	$DamageAnimationPlayer.play("take_damage")

	display_text_damage(raw_damage)
	
	if health <= 0:
		die()


func die():
	current_state = DYING
	queue_free()


func flash():
	$Body.material = FLASH_MATERIAL
	

func unflash():
	$Body.material = null
