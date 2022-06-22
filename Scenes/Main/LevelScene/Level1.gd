extends LevelScene


func start():
	entities.add_child(GameData.player)
	

func pause():
	.pause()
	
	
func end():
	entities.remove_child(GameData.player)
