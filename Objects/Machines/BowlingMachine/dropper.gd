extends AnimatableBody3D

@export var frequency := 0.3
@export var amplitude := 90
var axis := Vector3.FORWARD
var time_passed := 0.0

func _physics_process(delta: float) -> void:
	time_passed += delta
	var offset := amplitude * sin(time_passed * frequency * TAU)
	rotation_degrees = axis * offset
	
