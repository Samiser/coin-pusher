extends Node3D
class_name CoinMachine
## Base class for all other coin machines
##
## To enable the shared functionality of this script each coin machine should have:
## - A coin_detector Area3D
## - A spawn_coin function

@onready var coin_detector: Area3D = $CoinDetector
@onready var coin_rain_marker := $CoinRainMarker
var coin_scene: PackedScene = preload("res://Objects/Coin/coin.tscn")

signal coin_collected(value: int)

func spawn_coin() -> void:
	push_error("spawn_coin() not implemented in %s" % name)

func coin_rain() -> void:
	for i in range(50):
		var coin := coin_scene.instantiate()
		add_child(coin)
		coin.global_position = coin_rain_marker.global_position
		await get_tree().create_timer(0.05).timeout

func _coin_detected(coin: Coin) -> void:
	emit_signal("coin_collected", coin.value)
	if coin.is_in_group("rain"):
		coin_rain()

func _ready() -> void:
	if not coin_detector:
		push_error("Missing 'CoinDetector' Area3D in %s" % name)
		return

	coin_detector.connect("body_entered", _coin_detected)
