extends Control


func _ready():
	$Sound.play()
	$AnimationPlayer.play("game_over")


func _on_AnimationPlayer_animation_finished(_anim_name):
	Tools.highscore()

