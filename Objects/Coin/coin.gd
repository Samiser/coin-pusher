extends RigidBody3D
class_name Coin

@onready var mesh := $MeshInstance3D

var value := 1
var spawn_time := 0
var spawn_height := 1
var id := 0

func _set_color(new_color: Color) -> void:
	var material: StandardMaterial3D = mesh.get_surface_override_material(0).duplicate()
	material.albedo_color = new_color
	mesh.set_surface_override_material(0, material)

func _get_random_color() -> Color:
	var hue := randf()
	var saturation := 0.5
	var val := 1.0
	return Color.from_hsv(hue, saturation, val)

func _ready() -> void:
	spawn_time = Time.get_ticks_msec()
	#var color := _get_random_color()
	var color := Color.PALE_GOLDENROD
	if is_in_group("rain"):
		color = Color.AQUA
	if is_in_group("bomb"):
		color = Color.RED
	_set_color(color)
