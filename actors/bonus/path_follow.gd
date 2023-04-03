extends PathFollow


export var speed = 5

func _physics_process(delta):
	offset += speed * delta
