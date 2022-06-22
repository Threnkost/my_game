extends Node

enum {
	WINDOW_NORMAL_MODE,
	WINDOW_BORDERLESS_MODE,
	WINDOW_FULLSCREEN_MODE
}

enum {
	HIGH,
	NORMAL,
	LOW,
	OFF
}


const DEFAULT_RESOLUTION = Vector2(384, 216)

var VALID_RESOLUTIONS := {
	0:Vector2(384*4, 216*4),
	1:Vector2(384*3, 216*3),
	2:Vector2(384*2, 216*2),
	3:Vector2(384*1, 216*1),
	4:Vector2(384*5, 216*5)
}


const PREFIX = "[GAME SETTINGS]"

#VIDEO SETTINGS
var window_mode:int = WINDOW_NORMAL_MODE setget set_window_mode
var default_window_size:Vector2
var preferred_window_size:Vector2
var vsync : bool = true
var hidpi : bool = true

var graphics_quality : int = HIGH
var shader_quality   : int = HIGH

#LOCALIZATION
var locale : String = "en" setget set_game_locale


func _ready():
	set_game_locale("en")
	
	default_window_size   = Vector2(ProjectSettings.get("display/window/size/test_width"), ProjectSettings.get("display/window/size/test_height"))
	preferred_window_size = VALID_RESOLUTIONS[0]


func set_game_locale(_locale:String):
	locale = _locale
	
	TranslationServer.set_locale(locale)


func set_window_mode(_mode:int) -> void:
	
	window_mode = _mode
	
	match window_mode:
		
		WINDOW_NORMAL_MODE:
			OS.set_window_fullscreen(false)
			OS.set_borderless_window(false)
			
			OS.set_window_size(preferred_window_size)
			
		WINDOW_FULLSCREEN_MODE:
			OS.set_window_fullscreen(true)
			OS.set_borderless_window(false)
			
		WINDOW_BORDERLESS_MODE:
			OS.set_borderless_window(true)
			OS.set_window_fullscreen(false)
			
			OS.set_window_size(preferred_window_size)


func set_window_size(size:Vector2):
	
	preferred_window_size = size
	
	OS.set_window_size(preferred_window_size)
