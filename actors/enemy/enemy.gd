extends KinematicBody


export var gravity: float = 2.0
export var speed: float = 5.0
export var max_speed: float = 40.0
export var color: Color = Color.red
export var is_autonom:bool = true

export var speed_up: bool = true
export var speed_up_time: int = 15
export var speed_up_value: float = 1.0

var movement = Vector3.ZERO

onready var timer = $SpeedTimer
onready var material = SpatialMaterial.new()

func _ready():
	material.albedo_color = color
	material.metallic = 0.4
	material.metallic_specular = 0.4
	material.roughness = 0.3
	$CollisionShape/Mesh.set_surface_material(0, material)
	
	if speed_up:
		timer.start(speed_up_time)
	if is_autonom:
		movement = Tools.random_vector_direction_xz(speed)


func _physics_process(delta):
	movement.y = -gravity
	movement.x = -speed if movement.x < 0.0 else speed
	movement.z = -speed if movement.z < 0.0 else speed
	
	$CollisionShape/Mesh.rotate_y(speed / 100.0)
	material.albedo_color = color.darkened(speed / 20 if speed/20 < 1.0 else 1.0)
	
	var collision_info = move_and_collide(movement * delta)
	if collision_info:
		movement = movement.bounce(collision_info.normal)


func _on_SpeedTimer_timeout():
	if speed_up and speed < max_speed:
		speed += speed_up_value
		timer.start(speed_up_time)
	else:
		timer.stop()

