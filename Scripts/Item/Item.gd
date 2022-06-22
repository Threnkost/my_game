extends Node
class_name Item

var item_model
var item_action


func _init(model_title : String):
	item_model = load("res://Resources/Items/" + model_title + ".tres")
	
	if item_model.ITEM_ACTION != null:
		item_action = item_model.ITEM_ACTION.new()


func IsSame(item : Item) -> bool:
	return item and item_model == item.item_model


func Interact(user):
	if item_action != null:
		item_action.Interact(user)


func Debug():
	print("Item Action : ", item_action)
