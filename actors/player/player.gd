extends KinematicBody


export var gravity: float = 10.0
export var speed: float = 500.0
export var keyboard_speed: float = 1.0
export var slowdown_step: float = 0.03
export var fly_force: float = 500.0
export var death_zone_falling: float = -10.0

var movement = Vector3.ZERO

export var camera_speed: float = 0.02
export var camera_max_distance: float = 200.0
export var camera_distance: float = 4.0
export var camera_height: float = 2.0

export var cam_t = Vector3(0, 32, -20)
export var cam_r = Vector3(-60, 180, 0)
export var cam_border_topleft = Vector3.ZERO
export var cam_border_bottomright = Vector3.ZERO
onready var camera = $CameraTarget/Camera

var last_cam_pos = Vector3.ZERO


func _ready():
	camera.translation = cam_t
	last_cam_pos = cam_t
	camera.rotation_degrees = cam_r


func _physics_process(delta):
	if UserData.debug_label:
		# prints player and camera positions on screen for debug purposes
		UserData.debug_content = "Player:\n Pos: ("+str(global_translation)+")\nCam: "+str(camera.global_translation)+")"
	
	camera.translation = lerp(camera.translation, cam_t, 0.05)

	if not cam_border_topleft == Vector3.ZERO:
		if camera.global_translation.x < cam_border_topleft.x:
			camera.global_translation.x = cam_border_topleft.x
		if camera.global_translation.x > cam_border_bottomright.x:
			camera.global_translation.x = cam_border_bottomright.x
		if camera.global_translation.z < cam_border_topleft.z:
			camera.global_translation.z = cam_border_topleft.z
		if camera.global_translation.z > cam_border_bottomright.z:
			camera.global_translation.z = cam_border_bottomright.z
	
#	var cam_target = $CameraTarget.get_global_transform_interpolated().origin
#	var cam_pos = camera.get_global_transform_interpolated().origin
#	var cam_up = Vector3(0, 1, 0)
#	var cam_offset = cam_pos + cam_target
#	cam_offset = cam_offset.normalized() * camera_distance
#	cam_offset.y = camera_height
#	cam_pos = cam_target + cam_offset
#	look_at_from_position(cam_pos, cam_target, cam_up)
#	camera_target.global_translation += cam_t#lerp(camera_target.global_transform.origin, global_transform.origin, camera_speed)
#	camera.translation.z = lerp(camera.translation.z, camera.translation.z, camera_speed)

	
	if Input.is_action_pressed("ui_cancel"):
		$UserInterface/PauseMenu.visible = true
		get_tree().paused = true
	
	if Input.get_accelerometer() == Vector3.ZERO: # only use keyboard input when no accelerometer is available
		if Input.is_action_pressed("ui_left"):
			movement.x = -speed * delta * keyboard_speed
		if Input.is_action_pressed("ui_right"):
			movement.x = speed * delta * keyboard_speed
		if Input.is_action_pressed("ui_up"):
			movement.z = -speed * delta * keyboard_speed
		if Input.is_action_pressed("ui_down"):
			movement.z = speed * delta * keyboard_speed				
	else:
		# round accel. input to two decimals
		movement.x = stepify(Input.get_accelerometer().x, 0.01) * speed * delta
		movement.z = stepify(Input.get_accelerometer().y, 0.01) * -speed * delta 
	
	movement.x = lerp(movement.x, 0.0, slowdown_step)
	movement.z = lerp(movement.z, 0.0, slowdown_step)
	movement.y = -gravity
	$CollisionShape/Mesh.rotate_x(-movement.z * 0.01)
	$CollisionShape/Mesh.rotate_z(movement.x * 0.01)
	
	movement = move_and_slide(movement)
	
	# felt down?
	if global_transform.origin.y < death_zone_falling:
		Tools.game_over()


func _on_Area_body_entered(body):
	# just handle enemy collisions. Bonus collisions are handles in bonus codes
	if body.is_in_group("enemies"):
		Tools.game_over()

