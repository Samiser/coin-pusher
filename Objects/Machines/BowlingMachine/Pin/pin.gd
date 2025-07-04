extends Node3D
class_name Pin

@onready var coin_detector_area := $CoinDetectorArea
@onready var sprite := $Sprite3D

var is_hit := false
var animating := false

signal hit(pin: Pin)

func _hit() -> void:
	sprite.modulate = Color.WHITE
	is_hit = true
	emit_signal("hit", self)

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
	if body.is_in_group("coin"):
		_hit()

func _ready() -> void:
	coin_detector_area.connect("body_entered", _on_body_entered)
