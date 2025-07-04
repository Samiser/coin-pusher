extends Node3D

@onready var drop_locations := $DropLocations
@onready var coin_detector: Area3D = $CoinDetector

signal coin_collected(value: int)

func _ready() -> void:
	coin_detector.connect("body_entered", _coin_detected)

func get_random_drop_location() -> Vector3:
	return drop_locations.get_children().pick_random().global_position

func _coin_detected(body:Node3D) -> void:
	emit_signal("coin_collected", 1)
