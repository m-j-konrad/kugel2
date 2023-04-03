# TODO: create all by code!

extends Spatial


var max_level: int = 4

var target = UserData.settings.last_selected_level
var camera_target_location = Vector3.ZERO


func _ready():
	# very important: don't take the last score with you when start a new game!! ;-)
	UserData.game_score = 0
	
	$Control/btnSelect.text = tr("LevelSelection_btnSelect")
	
	camera_target_location = $Camera.global_translation


func _physics_process(delta):
	$LevelSelect1.rotate_y(0.2*delta)
	$LevelSelect2.rotate_y(0.2*delta)
	$LevelSelect3.rotate_y(0.2*delta)
	$LevelSelect4.rotate_y(0.2*delta)
	$LevelSelect5.rotate_y(0.2*delta)
	
	if Input.is_action_just_pressed("ui_accept"): _on_btnSelect_pressed()
	if Input.is_action_just_pressed("ui_left"):
		$SoundChangeSelection.play()
		target -= 1
	if Input.is_action_just_pressed("ui_right"):
		$SoundChangeSelection.play()
		target += 1
	if target > max_level: target = 1
	if target < 1: target = max_level
	
	match target:
		1:
			camera_target_location.x = $LevelSelect1.global_translation.x
			camera_target_location.z = $LevelSelect1.global_translation.z + 30
			$Control/lblLevelName.text = tr("Level1")
		2:
			camera_target_location.x = $LevelSelect2.global_translation.x
			camera_target_location.z = $LevelSelect2.global_translation.z + 30
			$Control/lblLevelName.text = tr("Level2")
		3:
			camera_target_location.x = $LevelSelect3.global_translation.x
			camera_target_location.z = $LevelSelect3.global_translation.z + 30
			$Control/lblLevelName.text = tr("Level3")
		4:
			camera_target_location.x = $LevelSelect4.global_translation.x
			camera_target_location.z = $LevelSelect4.global_translation.z + 30
			$Control/lblLevelName.text = tr("Level4")
		5:
			camera_target_location.x = $LevelSelect5.global_translation.x
			camera_target_location.z = $LevelSelect5.global_translation.z + 30
			$Control/lblLevelName.text = tr("Level5")
	
	$Camera.global_translation = lerp($Camera.global_translation, camera_target_location, 0.04)


func _on_btnSelect_pressed():
	$SoundSelect.play()
	$AnimationPlayer.play("push_back")


func _on_AnimationPlayer_animation_finished(_anim_name):
	UserData.settings.last_selected_level = target
	UserData.save_settings()
	match(target):
		1: if get_tree().change_scene("res://levels/first_created/first_created.tscn") != OK: Tools.quit_game()
		2: if get_tree().change_scene("res://levels/action_kugel/action_kugel.tscn") != OK: Tools.quit_game()
		3: if get_tree().change_scene("res://levels/moms_stage/moms_stage.tscn") != OK: Tools.quit_game()
		4: if get_tree().change_scene("res://levels/turas/turas_01.tscn") != OK: Tools.quit_game()
		5: if get_tree().change_scene("res://levels/pac-kugel/pac-kugel.tscn") != OK: Tools.quit_game()


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton:
		 _on_btnSelect_pressed()

