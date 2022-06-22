extends Resource
class_name ItemModel

export (String) var ID
export (Texture) var TEXTURE

export (String, "ITEM", 
	"EQUIPMENT", 
	"MATERIAL", 
	"CONSUMABLE",
	"FOOD"
	) var TYPE = "ITEM"

export (int) var MAX_STACK = 25
export (GDScript) var ITEM_ACTION
export (Dictionary) var SID = {} #Specific Item Data
