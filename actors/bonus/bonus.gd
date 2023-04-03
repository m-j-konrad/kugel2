extends KinematicBody

class_name Bonus

export var bonus_value: int = 10
export var is_autonom:bool = true
export var gravity: float = 10.0
export var speed: float = 5.0

var movement = Vector3.ZERO

var last_spawn_point = Vector3.ZERO
var new_spawn_point = Vector3.ZERO

export (Array, Vector3) var spawn_points # spawn points available


func _ready():
	randomize()
	
	if is_autonom:
		movement = Tools.random_vector_direction_xz(speed)	
	go_to_spawn_point()


func _physics_process(delta):
	movement.y = 0 # don't know why - Y gets crazy values otherwise...
	movement.x = -speed if movement.x < 0.0 else speed
	movement.z = -speed if movement.z < 0.0 else speed

	var collision_info = move_and_collide(movement * delta)
	if collision_info:
		movement = movement.bounce(collision_info.normal)


func _on_DeathZone_body_entered(_body):
	$Sound.play()
	go_to_spawn_point()
	UserData.game_score += bonus_value


func go_to_spawn_point():
	# pick random spawnpoint from list
	while new_spawn_point == last_spawn_point:
		new_spawn_point = spawn_points[randi() % spawn_points.size()]
	
	self.global_translation = new_spawn_point
	last_spawn_point = new_spawn_point

