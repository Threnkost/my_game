extends KinematicBody

const KNOCKBACK_STRENGTH = 2.5

var knockback_vector := Vector3.ZERO

func _physics_process(delta):
	knockback_vector = lerp(knockback_vector, Vector3.ZERO, 0.2)
	move_and_slide(knockback_vector)
	

func _on_Area_body_entered(body):
	knockback_vector = body.global_transform.origin.direction_to(global_transform.origin)
	knockback_vector = knockback_vector * KNOCKBACK_STRENGTH
	
	print(knockback_vector)
	
