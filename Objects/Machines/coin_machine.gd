extends Node3D
class_name CoinMachine

@onready var coin_detector: Area3D = $CoinDetector
var coin_scene: PackedScene = preload("res://Objects/Coin/coin.tscn")

signal coin_collected(value: int)

func spawn_coin() -> void:
	push_error("spawn_coin() not implemented in %s" % name)

func _coin_detected(coin: Coin) -> void:
	emit_signal("coin_collected", coin.value)

func _ready() -> void:
	if not coin_detector:
		push_error("Missing 'CoinDetector' Area3D in %s" % name)
		return

	coin_detector.connect("body_entered", _coin_detected)
