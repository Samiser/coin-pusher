extends Node3D

@onready var flipper_body := $AnimatedRigidBody3D
@onready var collision_shape := $AnimatedRigidBody3D/Area3D
@onready var flipper_stream := $flipper_stream
var flip_speed := 24
var tween : Tween
@export var invert := false

func _ready() -> void:
	collision_shape.connect("body_entered", _coin_hit)
	
	var flip_range := 32
	if invert: 
		flip_range *= -1
		
	flipper_body.rotation_degrees.z = flip_range

func _flip(release:bool) -> void:
	flipper_stream.play()
	if(tween):
		tween.kill()
		
	var flip_range := -32
	if(release):
		flip_range *= -1
	
	if(invert):
		flip_range *= -1
	
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(flipper_body, "rotation_degrees:z", flip_range, 0.1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flip"):
		_flip(false)
	if Input.is_action_just_released("flip"):
		_flip(true)
		
func _coin_hit(body:Node3D) -> void:
	if !body.is_in_group("coin"):
		return
	
	_flip(false)
	await get_tree().create_timer(0.4).timeout
	_flip(true)
