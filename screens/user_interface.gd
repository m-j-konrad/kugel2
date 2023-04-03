extends Control


func _ready():
	$lblDebug.visible = UserData.debug_label
	$PauseMenu.visible = false


func _physics_process(_delta):
	if visible:
		$lblScore.text = str(UserData.game_score)
		if $lblDebug.visible:
			$lblDebug.text = UserData.debug_content


func _on_btnSettings_pressed():
	$PauseMenu/Settings.visible = true


func _on_btnGoOn_pressed():
	$PauseMenu.visible = false
	get_tree().paused = false


func _on_btnQuit_pressed():
	get_tree().quit(0)

