extends AnimatableBody3D

var start_position: Vector3
@export var frequency := 0.3
@export var amplitude := 0.12
var axis := Vector3.FORWARD
var time_passed := 0.0

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	time_passed += delta
	var offset := amplitude * sin(time_passed * frequency * TAU)
	global_position = start_position + axis * offset
	
