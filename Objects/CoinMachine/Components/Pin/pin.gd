extends Node3D
class_name Pin

@onready var coin_detector_area := $CoinDetectorArea
@onready var sprite := $Sprite3D

var is_hit := false
var animating := false

signal hit(pin: Pin)

func activate() -> void:
	sprite.modulate = Color.WHITE
	is_hit = true
	emit_signal("hit", self)

func deactivate() -> void:
	is_hit = false
	sprite.modulate = Color.DARK_GRAY

func flash_and_reset() -> void:
	animating = true
	var tween := get_tree().create_tween()
	tween.set_loops(5)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)
	tween.tween_property(sprite, "modulate", Color.DARK_GRAY, 0.2)
	await tween.finished
	animating = false
	is_hit = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("coin") and !animating:
		activate()

func _ready() -> void:
	deactivate()
	
	if is_in_group("unhittable"):
		return
		
	coin_detector_area.connect("body_entered", _on_body_entered)
