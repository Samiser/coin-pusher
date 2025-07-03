extends AnimatableBody3D

var start_position: Vector3
var frequency := 0.3
var amplitude := 0.1
var axis := Vector3.FORWARD
var time_passed := 0.0

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	time_passed += delta
	var offset := amplitude * sin(time_passed * frequency * TAU)
	global_position = start_position + axis * offset
	
