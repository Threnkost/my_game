extends KinematicBody

export (String) var item_id

var _item
var _amount := 0
var _collectable := true


#func _ready():
#	_item = Item.new(item_id)
#	_amount = 1
#
#	$Item.texture = _item.item_model.TEXTURE	


func initiate(item_id, amount):
	_item = Item.new(item_id)
	_amount = amount
	
	
	$Item.texture = _item.item_model.TEXTURE
	

var scattering_vector : Vector3
func scatter():
	
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()
	
	var scatter_strength = rng.randi_range(1, 5)
	
	scattering_vector   = Vector3.ZERO
	scattering_vector.x = rng.randf_range(-1.0, 1.0)
	scattering_vector.z = rng.randf_range(-1.0, 1.0)
	
	scattering_vector   = scattering_vector.normalized() * scatter_strength
	


func _physics_process(delta):
	scattering_vector = lerp(scattering_vector, Vector3.ZERO, 0.2)
	move_and_slide(scattering_vector)

	
func disable():
	if _collectable:
		_collectable = false
		$AnimationPlayer.play("collecting")


func pick():
	disable()
	
	get_node("/root/World/UI/Inventory").AddItem(_item, _amount)


func _on_VisibilityNotifier_screen_entered():
	visible = true


func _on_VisibilityNotifier_screen_exited():
	visible = false


func _on_PlayerDetector_body_entered(body):
	pick()
