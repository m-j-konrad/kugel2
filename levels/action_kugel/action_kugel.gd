extends Spatial


var new_enemy_speed: float = 4.0

onready var EnemyNode = preload("res://actors/enemy/enemy_non_collide.tscn")
onready var enemies = $Enemies


func _ready():
	$Hint.show_hint(tr("Hint2"))


func _on_Timer_timeout():
	var e = EnemyNode.instance()
	new_enemy_speed += 0.8
	enemies.add_child(e)
	e.global_translation = Vector3(-60, 2.88, rand_range(-28, 28))
	e.color=Color.blueviolet
	e.axis_lock_motion_y = true
	e.speed = new_enemy_speed
	e.speed_up = false
	e.scale = Vector3(0.6, 0.6, 0.6)
	
	$Timer.wait_time *= 1.2

