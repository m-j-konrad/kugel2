extends KinematicBody


export var speed = 2.0

onready var pivot = $Pivot
onready var mesh = $Pivot/MeshInstance
onready var tween = $Tween


func _ready():
	pivot.set_disable_scale(true)


func _physics_process(_delta):
	var forward = Vector3.FORWARD
	if Input.is_action_pressed("ui_up"):
		roll(forward)
	if Input.is_action_pressed("ui_down"):
		roll(-forward)
	if Input.is_action_pressed("ui_right"):
		roll(forward.cross(Vector3.UP))
	if Input.is_action_pressed("ui_left"):
		roll(-forward.cross(Vector3.UP))


func roll(dir):
	# Do nothing if we're currently rolling.
	if tween.is_active():
		return
	
	# Cast a ray before moving to check for obstacles
	var space = get_world().direct_space_state
	var collision = space.intersect_ray(mesh.global_transform.origin,
			mesh.global_transform.origin + dir * 2.5, [self])
	if collision:
		return
	
	## Step 1: Offset the pivot
	pivot.translate(dir)
	mesh.global_translate(-dir)
	## Step 2: Animate the rotation
	var axis = dir.cross(Vector3.DOWN)
	tween.interpolate_property(
		pivot, "transform:basis",null, pivot.transform.basis.rotated(axis, PI/2),
		1/speed, Tween.TRANS_QUAD, Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_all_completed")

	## Step3: Finalize movement and reverse the offset
	transform.origin += dir * 2
	var b = mesh.global_transform.basis  ## Save the rotation
	pivot.transform = Transform.IDENTITY
	mesh.transform.origin = Vector3(0, 1, 0)
	mesh.global_transform.basis = b  ## Apply the rotation



func _on_Tween_tween_step(_object, _key, _elapsed, _value):
	pivot.transform = pivot.transform.orthonormalized()
