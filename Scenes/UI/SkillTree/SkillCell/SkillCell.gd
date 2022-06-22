extends TextureButton


export (Resource) var skill_res = skill_res as SkillData

var category : String


func _ready():
	category = get_parent().get_parent().name

	skill_res = skill_res as SkillData
	assert(skill_res and skill_res is SkillData, "[SKILL:%s] Skill res is invalid." % [name])
	
	get_node("Level").text = str("%s/%s" % [skill_res.level, skill_res.max_level])
	
	GameData.skill_res[skill_res.skill_id] = skill_res
	
	skill_res.connect("level_changed", self, "_on_Skill_level_changed")
	
	connect("pressed", self, "_on_Mouse_click")
	
	texture_normal = skill_res.texture
	
	$LevelSlider.max_value = skill_res.max_level
	$LevelSlider.value     = skill_res.level
	

func _on_Skill_level_changed(new_level):
	get_node("Level").text = str("%s/%s" % [skill_res.level, skill_res.max_level])
	

func _on_LevelSlider_value_changed(value):
	skill_res.level = value
