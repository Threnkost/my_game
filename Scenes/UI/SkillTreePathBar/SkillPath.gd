extends Control

export (Array, Resource) var skills


var is_locked := false
var mouse_in  := false
var sliders   := []


func _ready():
	GameEvents.connect("skill_path_chosen", self, "_on_SkillPath_chosen")
	
	$SkillPath/Title.text = name
	
	sliders.append($SkillPath/Skills/Skill1/Slider)
	sliders.append($SkillPath/Skills/Skill2/Slider)
	sliders.append($SkillPath/Skills/Skill3/Slider)
	sliders.append($SkillPath/Skills/Skill4/Slider)
	sliders.append($SkillPath/Skills/Skill5/Slider)
	sliders.append($SkillPath/Skills/Skill6/Slider)
	
	for texture_rect in $SkillPath/Skills.get_children():
		texture_rect.texture = skills[texture_rect.get_index()].texture
	
	for i in sliders:
		i.max_value = 5
		i.editable  = false
		i.visible   = false

	for i in range(skills.size()):
		$SkillPath/Skills.get_child(i).get_node("Label").text = str("0/" + str(skills[i].max_level))


func _on_SkillPath_chosen(path_key:String):
	
	if path_key == name:
		$Button.disabled = true
		
		for i in sliders:
			i.editable = true
			i.visible  = true

	else:
		lock()


func _on_SkillPath_mouse_entered():
	mouse_in = true


func _on_SkillPath_mouse_exited():
	mouse_in = false


func lock():
	is_locked = true
	modulate = Color("464343")
	
	$Button.disabled = true


func _on_Button_pressed():
	GameEvents.emit_signal("skill_path_chosen", name)


func _on_Skill_level_updated(index:int, new_level:int):
	(skills[index] as SkillData).level = new_level
	$SkillPath/Skills.get_child(index).get_node("Label").text = str(skills[index].level) + "/" + str(skills[index].max_level)


func _on_Slider1_value_changed(value):
	_on_Skill_level_updated(0, value)


func _on_Slider3_value_changed(value):
	_on_Skill_level_updated(2, value)


func _on_Slider4_value_changed(value):
	_on_Skill_level_updated(3, value)


func _on_Slider5_value_changed(value):
	_on_Skill_level_updated(4, value)


func _on_Slider6_value_changed(value):
	_on_Skill_level_updated(5, value)


func _on_Slider2_value_changed(value):
	_on_Skill_level_updated(1, value)
