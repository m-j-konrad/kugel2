extends Control


onready var ed_pname = $editPlayerName as LineEdit

func _ready():
	randomize()
	UserData.settings.unique_player_name = OS.get_unique_id() + str(rand_range(1000,9999))


func _on_btnOkay_pressed():
	if not ed_pname.text == "":
		UserData.settings.display_name = ed_pname.text
		# save the user data
		UserData.save_settings()
		Tools.welcome()


func _on_editPlayerName_gui_input(_event):
	# if ENTER was pressed, simulate okay button press
	if Input.is_key_pressed(KEY_ENTER):
		_on_btnOkay_pressed()

