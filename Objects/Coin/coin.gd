extends RigidBody3D
class_name Coin

@onready var mesh := $MeshInstance3D

var value := 1

func _set_color(new_color: Color) -> void:
	var material: StandardMaterial3D = mesh.get_surface_override_material(0).duplicate()
	material.albedo_color = new_color
	mesh.set_surface_override_material(0, material)

func _process(_delta: float) -> void:
	if global_position.y < -12:
		queue_free()

func _get_random_color() -> Color:
	var hue := randf()
	var saturation := 0.5
	var val := 1.0
	return Color.from_hsv(hue, saturation, val)

func _ready() -> void:
	var color := _get_random_color()
	_set_color(color)
