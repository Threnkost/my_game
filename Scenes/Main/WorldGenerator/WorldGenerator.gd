extends Node

#1371511360
const TREE = preload("res://Scenes/Gameplay/World/Tree3D.tscn")
const MINE = preload("res://Scenes/2D/Mine/Mine.tscn")
#const CHUNK_GRID = preload("res://chunk.png")

enum {
	VOID    = -1,
	OCEAN   = 0,
	FOREST  = 1,
	DESERT  = 2
}

enum assets {
	TREE,
	MINE,
	ROCK,
}


const CELL_SIZE = 24

export(NodePath) var grid_map_path
export(Vector2) var map_size = Vector2(64, 64)
export(int)     var octaves = 3
export(int)     var period  = 64
export(bool)    var random = true
export(int)     var CHUNK_SIZE = 16
export(Array, Resource) var VALID_BIOMES


onready var world_map = $WorldMap as TileMap

var open_simplex_noise :OpenSimplexNoise = OpenSimplexNoise.new()

var chunks                 := [] #[[]
var map_data    :Array      = []
var tree_data   :Array      = [] #[TYPE, X, Y]
var mine_data   :Array      = [] #[TYPE, X, Y]

var grid_map:TileMap

var map_width
var map_height

func _ready():
	
	map_width = range(-map_size.x/2, map_size.x/2)
	map_height = range(-map_size.y/2, map_size.x/2)
	
	grid_map = get_node(grid_map_path)

	adjust_noise(random, octaves, period)
	generate_world()
	render_world()


func adjust_noise(random, _octaves, _period) -> void:
	
	open_simplex_noise.octaves = _octaves
	open_simplex_noise.period  = _period


func generate_world() -> void:
	clear_world()
	chunks.clear()
	
	var rng = RandomNumberGenerator.new(); rng.randomize()
	
	randomize()
	open_simplex_noise.seed = 1371511360#randi()

	for y in map_size.y:
		map_data.append([])
		for x in map_size.x:
			var rand = min(floor(abs(open_simplex_noise.get_noise_2d(x, y)*5)), 1)
			
			if rand == 0:
				map_data[y].append(0)
			elif rand == 1:
				map_data[y].append(1)
	
			
	for y in map_size.y / CHUNK_SIZE:
		chunks.append([])
		for x in map_size.x / CHUNK_SIZE:
			var chunk_y = y
			var chunk_x = x
			
			var random_biome = VALID_BIOMES[randi() % (VALID_BIOMES.size())]
			
			chunks[chunk_y].append(random_biome.name)


	for y in map_size.y:
		for x in map_size.x:
			var chunk_pos = Vector2.ZERO
			chunk_pos.x   = int(x / CHUNK_SIZE)
			chunk_pos.y   = int(y / CHUNK_SIZE)
				
			#print(chunk_pos)
			
			if map_data[y][x] == 6:
					
				if chunks[chunk_pos.y][chunk_pos.x] == "Forest":
					map_data[y][x] = 1
					
				elif chunks[chunk_pos.y][chunk_pos.x] == "Desert":
					map_data[y][x] = 2
	
	for y in map_size.y:
		for x in map_size.x:
			var cell = map_data[y][x]

			if cell == FOREST:
				var _valid_assets := [
					assets.TREE, 
					assets.MINE]

				var chance = randf()
				var index  = _valid_assets[rng.randi_range(0, _valid_assets.size()-1)]

				var right_cell = map_data[y][x+1] if x < map_size.x-1 else VOID
				var left_cell  = map_data[y][x-1] if x > map_size.x+1 else VOID
				var up_cell    = map_data[y-1][x] if y > map_size.y+1 else VOID
				var down_cell  = map_data[y+1][x] if y < map_size.y-1 else VOID


				match index:
					assets.TREE:
						if chance <= VALID_BIOMES[0].TREE_FORMATION_CHANCE:
							if not (right_cell == OCEAN or left_cell == OCEAN or up_cell == OCEAN or down_cell == OCEAN):
								tree_data.append([assets.TREE, x, y])

					assets.MINE:
						if chance <= VALID_BIOMES[0].ROCK_FORMATION_CHANCE:
							if not (right_cell == OCEAN or left_cell == OCEAN or up_cell == OCEAN or down_cell == OCEAN):
								mine_data.append([assets.ROCK, x, y])

#
#			elif cell == DESERT:
#				var _valid_assets := [ 
#					assets.MINE,
#					assets.GOLD_VEIN]
#
#				var chance = randf()
#				var index  = _valid_assets[rng.randi_range(0, _valid_assets.size()-1)]
#
##				var right_cell = map_data[y][x+1] if x < map_size.x-1 else VOID
##				var left_cell  = map_data[y][x-1] if x > map_size.x+1 else VOID
##				var up_cell    = map_data[y-1][x] if y > map_size.y+1 else VOID
##				var down_cell  = map_data[y+1][x] if y < map_size.y-1 else VOID
#
#				match index:
#
#					assets.MINE:
#						if chance <= ROCK_FORMATION_IN_DESERT_CHANCE:
#							mine_data.append([assets.ROCK, x, y])
#
#					assets.GOLD_VEIN:
#						if chance <= GOLD_VEIN_FORMATION_IN_DESERT_CHANCE:
#							mine_data.append([assets.GOLD_VEIN, x, y])
##						else:
##							mine_data.append([assets.ROCK, x, y])


func clear_world():
	map_data.clear()
	tree_data.clear()
	mine_data.clear()


func trim_world():
	pass	
				

func save_world():
	pass


func render_world():
	pass
	for y in map_size.y:
		for x in map_size.x:
			var tile = map_data[y][x]
			grid_map.set_cell(x, y, tile)

	for i in tree_data:
		var tree = TREE.instance()
		var x    = i[1]
		var y    = i[2]

		get_node("/root/World/GameObjects/Trees").add_child(tree)
		tree.global_position = Vector2(x*CELL_SIZE, y*CELL_SIZE)
		tree.visible = false

		print("Added tree : ", tree.name)

	for i in mine_data:
		var mine = MINE.instance()
		var x = i[1]
		var y = i[2]
		
		get_node("/root/World/GameObjects/Mines").add_child(mine)
		mine.global_position = Vector2(x*CELL_SIZE, y*CELL_SIZE)
		mine.visible = false
