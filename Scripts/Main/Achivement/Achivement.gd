extends Resource
class_name Achivement

enum difficulties {
	EASY,
	NORMAL,
	HARD,
	LEGEND
}

export(String)       var name
export(Texture)      var icon
export(difficulties) var difficulty = difficulties.NORMAL


