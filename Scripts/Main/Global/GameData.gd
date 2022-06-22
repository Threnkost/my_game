extends Node

signal achivement_unlocked(achivement_id)


const UI_MOUSE_CURSOR = preload("res://Assets/Png/mouse_cursor2-export.png")
const GAMEPLAY_MOUSE_CURSOR = preload("res://Assets/Png/mouse_cursor_var2-export.png")

const PLAYER_SCENE = preload("res://Scenes/MainPlayer3D.tscn")

onready var inventory
onready var player
onready var camera
onready var world
onready var ui

onready var skill_res := {}
onready var valid_items := {}

onready var achivements := {}
onready var unlocked_achivements := {}

var skill_path_key : String = "NULL"

	
func _ready():
	inventory = get_node("/root/World/UI/Inventory")
	
	player = PLAYER_SCENE.instance()
	camera = player.get_node("Camera")
	world  = get_node("/root/World")
	
	ui     = get_node("/root/World/UI/UI")

	load_valid_items("res://Resources/Items/")


func get_skill_data(character_name:String, skill_name:String) -> SkillData:
	
	return load("res://Resources/Skills/Evolution/" + character_name + "/" + skill_name + ".tres") as SkillData


func load_valid_items(path : String):
	var dir = Directory.new()

	print()
	if dir.open(path) == OK:
		dir.list_dir_begin()

		var file_name = dir.get_next()
		while file_name != "":
			file_name = dir.get_next()
			if not dir.current_is_dir() and file_name != "":
				var item_path = path + "/" + file_name
				var item_res  = load(item_path) as ItemModel
				valid_items[item_res.ID] = item_res

		dir.list_dir_end()
		print("Loaded items : ", valid_items)
	print()


func get_item_model(item_id:String) -> ItemModel:
	if valid_items.has(item_id):
		return valid_items[item_id]
	return valid_items["air"]


func unlock_achivement(achivement_id:String):
	if unlocked_achivements.has(achivement_id):
		print("You already unlocked achivement : ", achivement_id)
	else:
		pass
