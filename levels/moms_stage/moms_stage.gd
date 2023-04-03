extends Spatial


var new_enemy_speed: float = 4.0

onready var EnemyNode = preload("res://actors/enemy/enemy.tscn")
onready var enemies = $Enemies


func _ready():
	$Hint.show_hint(tr("Hint3"))


func _on_Timer_timeout():
	var e = EnemyNode.instance()
	new_enemy_speed += 0.8
	enemies.add_child(e)
	e.global_translation = Vector3(-60, 1.8, rand_range(-28, 28))
	e.speed = new_enemy_speed
	e.speed_up = false
	e.scale = Vector3(0.7, 0.7, 0.7)
	
	$Timer.wait_time *= 1.2

