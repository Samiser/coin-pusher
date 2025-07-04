extends Node3D

@onready var collision_shape := $Area3D
@onready var animated_body : AnimatableBody3D = $AnimatedBody3D
var material : StandardMaterial3D
var tween : Tween
var start_pos : Vector3
var shake_amount := 0.02
var shake_speed := 0.5

func _ready() -> void:
	collision_shape.connect("body_entered", _coin_hit)
	
	start_pos = animated_body.position
	
	var mesh := $AnimatedBody3D/MeshInstance3D
	material = mesh.get_surface_override_material(0).duplicate()
	material.albedo_color = Color.RED
	mesh.set_surface_override_material(0, material)
	
func _coin_hit(body:Node3D) -> void:
	if !body.is_in_group("coin"):
		return
		
	print("wah hit a damn coin")
	
	if(tween):
		tween.kill()
		
	tween = get_tree().create_tween()
	tween.set_loops(10)
	tween.tween_property(material, "albedo_color", Color.RED, 0.02).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(material, "albedo_color", Color.DARK_RED, 0.02)

	var offset := func() -> Vector3: return start_pos + Vector3(randi_range(-1, 1), randi_range(-1, 1), 0).normalized() * shake_amount
	tween.tween_property(animated_body, "position", offset.call(), shake_speed).set_trans(Tween.TRANS_SPRING)
	
	await tween.finished
	animated_body.position = start_pos
