extends Node


signal dropped_item_taken(item_id)

signal on_mine()
signal player_strikes(attacker, victim)
signal left_clicked_on_game_screen(position)
signal skill_path_chosen(path_key)


func _ready():
	connect("dropped_item_taken", GameConnection, "_on_Drop_collected")
