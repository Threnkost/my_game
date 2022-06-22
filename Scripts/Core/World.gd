extends Node2D

signal map_is_ready()


var PLAYER_INSTANCE = load("res://Scenes/PeerPlayer.tscn")

const DROP_SCENE = preload("res://Scenes/Gameplay/ItemDrop.tscn")


const INTERPOLATION_OFFSET = 100

onready var game_objects = $GameObjects


#var world_state_buffer = []
#var last_world_state = 0
#
#var is_map_loaded := false
#var last_player_position := Vector2.ZERO

#export (PackedScene) var main_player

export(NodePath) onready var initial_level = get_node(initial_level) as LevelScene
var levels := {}
var current_level : LevelScene


func _ready():
	for level in $Levels.get_children():
		levels[level.name] = level
		if initial_level != level:
			$Levels.remove_child(level)
	
	current_level = initial_level
	initial_level.start()


func switch_level(level_name:String):
	if levels.has(level_name) and current_level.name != level_name:
		current_level.end()
		current_level = levels[level_name]
		levels[level_name].start()

#
#
#func SpawnNewPlayer(player_id, pos):
#	if player_id != get_tree().get_network_unique_id():
#
#		if not $YSort.has_node(str(player_id)):
#			var new_player = PLAYER_INSTANCE.instance()
#			new_player.global_position = pos
#			new_player.name = str(player_id)
#
#			new_player.Initiate(player_id)
#
#			$YSort.add_child(new_player)
#
#
#func SpawnNewEntity(entity_uid, pos, node_name):
#
#	if not $YSort.has_node(entity_uid):
#		var path = "res://Scenes/Entities/" + node_name + ".tscn"
#		var entity_instance = load(path).instance()
#		entity_instance.global_position = pos
#		entity_instance.name = entity_uid
#		entity_instance.create(Entity.new())
#
#		print(entity_instance.name)
#
#		$YSort.add_child(entity_instance)
#
#
#func UpdateWorldState(world_state):
#
#	if last_world_state < world_state["T"]:
#		last_world_state = world_state["T"]
#
#		world_state_buffer.append(world_state)
#
#
#func _physics_process(delta):
#	if not is_map_loaded:
#		return
#	if not GameConnection.is_online():
#		#set_physics_process(false)
#		return
#
#	var render_time = OS.get_system_time_msecs() - INTERPOLATION_OFFSET
#	if world_state_buffer.size() > 1:
#		while world_state_buffer.size() > 2 and render_time > world_state_buffer[1]["T"]:
#			world_state_buffer.remove(0)
#
#		var interpolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"])
#		for player in world_state_buffer[1].keys():
#			if str(player) == "T":
#				continue
#
#			if str(player) == "Entities":
#				continue
#
#			if str(player) == "Drops":
#				continue
#
#			if player == get_tree().get_network_unique_id():
#				continue
#
#			if $YSort.has_node(str(player)):
#				var new_pos = lerp(world_state_buffer[0][player]["P"], world_state_buffer[1][player]["P"], interpolation_factor)
#
#				$YSort.get_node(str(player)).MoveTo(new_pos)
#				$YSort.get_node(str(player)).SetDirection(world_state_buffer[1][player]["D"])
#
#			else:
#				SpawnNewPlayer(player, world_state_buffer[1][player]["P"])
#
#		for entity in world_state_buffer[1]["Entities"].keys():
#			if $YSort.has_node(entity):
#
#				var entity_node = $YSort.get_node(entity)
#
#				entity_node.entity_base.health = max(world_state_buffer[1]["Entities"][entity]["SED"]["health"], 0)
#
#				if world_state_buffer[1]["Entities"][entity]["ST"] == "dead":
#					entity_node.die()
#
#
#			elif world_state_buffer[1]["Entities"][entity]["ST"] != "dead":
#				SpawnNewEntity(entity, world_state_buffer[1]["Entities"][entity]["P"], world_state_buffer[1]["Entities"][entity]["N"])
#
#				#print(entity)
#
#
#		for drop in world_state_buffer[1]["Drops"].keys():
#
#			if $YSort/Drops.has_node(drop):
#
#				var drop_node = get_node("YSort/Drops/" + drop)
#
#				if world_state_buffer[1]["Drops"][drop]["IC"]:
#					drop_node.disable()
#
#			elif not world_state_buffer[1]["Drops"][drop]["IC"]:
#
#				var new_drop = DROP_SCENE.instance()
#				new_drop.initiate(world_state_buffer[1]["Drops"][drop]["I"], world_state_buffer[1]["Drops"][drop]["A"])
#				new_drop.name = drop
#				new_drop.get_node("ID").text = drop
#
#				$YSort/Drops.add_child(new_drop)
#
#				new_drop.global_position = world_state_buffer[1]["Drops"][drop]["P"]
#
##Optimize it later!
#
#func load_world_map(tile_map := {}, tree_map := {}):
##	var tiles := {
##		"grass_1":0,
##		"grass_2":1,
##		"grass_3":2,
##		"grass_4":3
##	}
##
##	for tile in tile_map.keys():
##		for coord in tile_map[tile]:
##			$TileMap.set_cellv(coord, tiles[tile])
#
#	emit_signal("map_is_ready")
#
##	if tree_map.empty():
##		return
##
##	for tree in tree_map["tree1"].keys():
##		var coord = tree_map["tree1"][tree]
##		var tree_model = load("res://Scenes/Gameplay/World/Tree.tscn").instance()
##		$YSort/Trees.add_child(tree_model)
##		tree_model.global_position = coord
##		print(tree)
#
#
#
#func _on_World_map_is_ready():
#	print("Map is loaded!")
#	is_map_loaded = true
#	var player_instance = main_player.instance()
##
##	player_instance.global_transform.origin.y += 0.25
#
#	game_objects.get_node("Entities/Players").add_child(player_instance)
#
#	#player_instance.global_ = last_player_position

