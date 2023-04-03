extends Node


# ramdomizes direction of vector diagonal x,z
func random_vector_direction_xz(value: float) -> Vector3:
	# TODO: optimize code
	var rand_movement: float = rand_range(0,1)
	var movement = Vector3.ZERO
	movement.x = -value if rand_movement < 0.5 else value
	rand_movement = rand_range(0,1)
	movement.z = -value if rand_movement < 0.5 else value
	return movement


# quit the game
func quit_game():
	if OS.get_name() == "HTML5":
		JavaScript.eval("window.location.href='https://xn--derkleinebr-u8a.de'")
	else:
		get_tree().quit()


# return to main
func back_to_main():
	if get_tree().change_scene("res://screens/_main_.tscn") != OK: Tools.quit_game()


# go to welcome screen
func welcome():
	if get_tree().change_scene("res://screens/welcome.tscn") != OK: Tools.quit_game()


# run game over screen
func game_over():
	if get_tree().change_scene("res://screens/game_over.tscn") != OK: Tools.quit_game()


# run highscore screen
func highscore():
	if get_tree().change_scene("res://screens/highscore.tscn") != OK: Tools.quit_game()


# run user creation screen
func create_user():
	if get_tree().change_scene("res://screens/create_user.tscn") != OK: Tools.quit_game()


# run level selection screen
func choose_level():
	if get_tree().change_scene("res://screens/level_selection.tscn") != OK: Tools.quit_game()


# fills strings with leading spaces to a specific length
func fill_string(txt: String, length: int) -> String:
	while txt.length() < length:
		txt = " " + txt
	return txt


func level_name(lvl: int) -> String:
	match lvl:
		1: return tr("Level1")
		2: return tr("Level2")
		3: return tr("Level3")
		4: return tr("Level4")
		5: return tr("Level5")
	return " - "	


func set_bus_volume(bus_index: int,value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear2db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)


func pause_game():
	get_tree().paused = true


func resume_game():
	get_tree().paused = false

