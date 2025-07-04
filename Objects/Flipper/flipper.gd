extends Node3D

@onready var flipper_body := $AnimatedRigidBody3D
var flip_speed := 24
var flipping := false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flip") && !flipping:
		flipping = true;

	if flipping:
		flipper_body.rotate_z(-flip_speed * delta)
		if(flipper_body.rotation_degrees.z < -20):
			flipping = false
	else:
		if(flipper_body.rotation_degrees.z < 45):
			flipper_body.rotate_z(flip_speed * delta)
