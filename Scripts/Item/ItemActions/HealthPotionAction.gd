extends ItemAction


func Interact(user):
	var heal_amount = load("res://Resources/Items/health_potion.tres").SID["heal_amount"]
	print("Healed : ", heal_amount)
