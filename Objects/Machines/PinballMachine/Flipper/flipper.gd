extends Node3D

@onready var flipper_body := $AnimatedRigidBody3D
var flip_speed := 24
var flipping := false
var tween : Tween

func _flip() -> void:
	flipping = true
	
	if(tween):
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.tween_property(flipper_body, "rotation_degrees:z", -32, 0.2).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(flipper_body, "rotation_degrees:z", 24, 0.2).set_trans(Tween.TRANS_SPRING)
	#tween.tween_callback(flipper_body.queue_free)
	
	flipping = false

# might want to use a tween for this https://docs.godotengine.org/en/stable/classes/class_tween.html
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flip") && !flipping:
		_flip()
