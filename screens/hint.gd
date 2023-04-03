extends Control


func _ready():
	visible = false


func _on_btnOkay_pressed():
	visible = false
	get_tree().paused = false


func show_hint(hint: String):
	if UserData.settings.show_hints:
		$Label.text = hint
		visible = true
		get_tree().paused = true

