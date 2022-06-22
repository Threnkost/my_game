extends Node
class_name ItemBox

signal item_changed(item, amount)
signal cleaned()


var item : Item = null
var amount := 0


func IsEmpty(): #Kutunun dolu olup olmadığını sorgular.
	return amount <= 0 || item == null


func PutItem(target_item, target_amount := 1): #Kutuya eşya koyar
	item   = target_item
	amount = target_amount
	
	emit_signal("item_changed", item, amount)
	
	
func IncreaseAmount(target_amount):
	amount += target_amount
	emit_signal("item_changed", item, amount)


func DecreaseAmount(target_amount):
	amount -= target_amount
	emit_signal("item_changed", item, amount)


func ClearBox(): #Kutuyu boşaltır
	item   = null
	amount = 0

	emit_signal("cleaned")


func CompareTo(target_item):
	return (item and target_item) and item.item_model == target_item.item_model
	
