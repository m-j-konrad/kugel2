extends Control


func _ready():
	# first the settings screen isn't visible
	visible = false
	# load data from file
	UserData.load_settings()
	
	$C/VolumeMaster/sliderMaster.value = UserData.settings.volume_master
	$C/VolumeMusic/sliderMusic.value = UserData.settings.volume_music
	$C/VolumeSound/sliderSound.value = UserData.settings.volume_sound
	$C/DisplayName/editDisplayName.text = UserData.settings.display_name
	$C/Language/btnLanguage.text = UserData.settings.language
	$C/Graphics/lblToggleGraphics.text = "Settings_LowGraphics" if UserData.settings.low_graphics else "Settings_HighGraphics"
	$C/Hints/lblToggleHints.text = "Settings_Show" if UserData.settings.show_hints else "Settings_Hide"


func _on_btnCancel_pressed():
	$Music.stop()
	visible = false


func _on_btnOkay_pressed():
	# save data to file
	UserData.save_settings()
	
	$Music.stop()
	# hide screen
	visible = false


func _on_btnShowHints_pressed():
	UserData.settings.show_hints = !UserData.settings.show_hints
	$C/Hints/lblToggleHints.text = "Settings_Show" if UserData.settings.show_hints else "Settings_Hide"


func _on_btnGraphics_pressed():
	UserData.settings.low_graphics = !UserData.settings.low_graphics
	$C/Graphics/lblToggleGraphics.text = "Settings_LowGraphics" if UserData.settings.low_graphics else "Settings_HighGraphics"


func _on_sliderMaster_value_changed(value):
	UserData.settings.volume_master = value
	Tools.set_bus_volume(0, value)


func _on_sliderMusic_value_changed(value):
	UserData.settings.volume_music = value
	Tools.set_bus_volume(1, value)


func _on_sliderSound_value_changed(value):
	UserData.settings.volume_sound = value
	Tools.set_bus_volume(2, value)
	$Sound.play()


func _on_Settings_visibility_changed():
	if visible:
		$Music.play()
	else:
		$Music.stop()


func _on_editDisplayName_text_changed(new_text):
	UserData.settings.display_name = new_text


func _on_listLanguage_item_selected(index):
	match index:
		0:
			UserData.settings.language = "en"
		1:
			UserData.settings.language = "de"
		2:
			UserData.settings.language = "fr"
		3:
			UserData.settings.language = "es"
	
	$C/Language/btnLanguage.text = UserData.settings.language
	TranslationServer.set_locale(UserData.settings.language)
	$C/Language/listLanguage.visible = false
	$C/VolumeMaster.visible = true
	$C/VolumeMusic.visible = true
	$C/VolumeSound.visible = true
	$C/Graphics.visible = true
	$C/Hints.visible = true
	$C/Language/btnLanguage.visible = true


func _on_btnLanguage_pressed():
	$C/Language/btnLanguage.visible = false
	$C/VolumeMaster.visible = false
	$C/VolumeMusic.visible = false
	$C/VolumeSound.visible = false
	$C/Graphics.visible = false
	$C/Hints.visible = false
	$C/Language/listLanguage.visible = true

