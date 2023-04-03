extends Control


func _ready():
	$btnPlay.visible = false
	$btnSettings.visible = false
	$btnQuit.visible = false
	# show a very nice animation :-)
	$AnimationPlayer.play("welcome")


func _on_AnimationPlayer_animation_finished(_anim_name):
	$CheckInternetConnection.test_internet()


func _on_CheckInternetConnection_done():
	$CheckForUpdate.check_for_update()


func _on_btnPlay_pressed():
	Tools.choose_level()


func _on_btnSettings_pressed():
	$Settings.visible = true


func _on_CheckForUpdate_done():
	$btnPlay.visible = true
	$btnSettings.visible = true
	$btnQuit.visible = true
	UserData.load_settings()


func _on_btnQuit_pressed():
	get_tree().quit()
