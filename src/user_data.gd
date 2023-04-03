# contains user specific data we need to save
extends Node


# internet connetion available?
var internet_available: bool = true

# current version number
var version: int = 4

# settings
const USER_SETTINGS_PATH := "user://user_data_v3.kug"

var settings = {
		"unique_player_name" : "",
		"display_name" : "",
		"last_selected_level" : 3,
		"volume_master" : 1.0,
		"volume_music" : 0.6,
		"volume_sound" : 1.0,
		"show_hints" : true,
		"low_graphics" : false,
		"score1" : 0,
		"score2" : 0,
		"score3" : 0,
		"score4" : 0,
		"score5" : 0,
		"language" : "en",
}

# show the debug label on user interface?
var debug_label = false
var debug_content: String = ""
# game data
var game_score: int = 0


func _ready():
	match OS.get_locale_language():
		"en":
			settings.language = OS.get_locale_language()
		"de":
			settings.language = OS.get_locale_language()
		"fr":
			settings.language = OS.get_locale_language()
		"es":
			settings.language = OS.get_locale_language()
		_:
			settings.language = "en"
	
	print(settings.language)

func save_settings():
	if !UserData.settings.unique_player_name == "":
		var file := File.new()
		# warning-ignore:return_value_discarded
		file.open(USER_SETTINGS_PATH, File.WRITE)
		file.store_var(settings)


func load_settings():
	var file := File.new()
	if not file.file_exists(USER_SETTINGS_PATH):
		Tools.create_user()
	else:
		# warning-ignore:return_value_discarded
		file.open(USER_SETTINGS_PATH, File.READ)
		settings = file.get_var()
		TranslationServer.set_locale(settings.language)


 
