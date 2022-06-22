extends Resource
class_name Agent


export (String)  var name
export (Texture) var portrait

export (float) var movement_speed = 1.0

export (int) var health = 100
export (float) var health_regen_rate = 1.0

export (Dictionary)      var stats
export (PackedScene) var behavior_scene
