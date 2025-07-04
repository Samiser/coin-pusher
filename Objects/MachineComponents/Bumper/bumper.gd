extends Node3D

@onready var collision_shape := $Area3D
@onready var animated_body : AnimatableBody3D = $AnimatedBody3D

var material : StandardMaterial3D
var tween : Tween

signal bumped

func _ready() -> void:
	collision_shape.connect("body_entered", _coin_hit)
	
	var mesh := $AnimatedBody3D/MeshInstance3D
	material = mesh.get_surface_override_material(0).duplicate()
	material.albedo_color = Color.DARK_RED
	mesh.set_surface_override_material(0, material)
	
func _coin_hit(body:Node3D) -> void:
	if !body.is_in_group("coin"):
		return
	
	emit_signal("bumped")
	
	if(tween):
		tween.kill()
		
	tween = get_tree().create_tween()
	tween.set_loops(10)
	tween.tween_property(material, "albedo_color", Color.RED, 0.02).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(material, "albedo_color", Color.DARK_RED, 0.02)
	
	await tween.finished
