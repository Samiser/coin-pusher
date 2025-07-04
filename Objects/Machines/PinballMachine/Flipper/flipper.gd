extends Node3D

@onready var flipper_body := $AnimatedRigidBody3D
var flip_speed := 24
var tween : Tween

func _flip(release:bool) -> void:
	
	if(tween):
		tween.kill()
		
	var flip_range := -32
	if(release):
		flip_range *= -1
	
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(flipper_body, "rotation_degrees:z", flip_range, 0.1)

# might want to use a tween for this https://docs.godotengine.org/en/stable/classes/class_tween.html
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flip"):
		_flip(false)
	if Input.is_action_just_released("flip"):
		_flip(true)
