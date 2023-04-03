# TO DO:
#
# - highscore with date and time?
#
#
# SETTINGS OPTIONS:
# - graphic: resolution, details, ...
# - battery-life-saver


extends Node

func _ready():
	UserData.version = 8
	
	# some debug infos. Will be stored in user dir log file
	print("-V:" + str(UserData.version) + " -L:" + str(OS.get_locale_language()) +
		" -OS:" + OS.get_name() + " -Model:" + OS.get_model_name() +
		" -ScrSize:" + str(OS.get_screen_size()) + " -DPI: " + str(OS.get_screen_dpi()))
