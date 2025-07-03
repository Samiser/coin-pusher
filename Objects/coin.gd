extends RigidBody3D

func _process(delta: float) -> void:
	if global_position.y < -12:
		queue_free()
