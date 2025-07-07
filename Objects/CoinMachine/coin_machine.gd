@tool
extends Node3D
class_name CoinMachine

@onready var coin_detector: Area3D = $CoinDetector
@onready var coin_rain_marker := $CoinRainMarker
@onready var coin_parent := $Coins
@onready var drop_location_marker := $DropLocation
@onready var boards := $Boards
@onready var killzone := $Killzone

var coin_scene: PackedScene = preload("res://Objects/Coin/coin.tscn")

var coins_in_play := 0

signal coin_collected(value: int)
signal add_combo (value:int)

func _get_drop_location() -> Vector3:
	return drop_location_marker.global_position

func coin_rain() -> void:
	for i in range(10):
		var coin := spawn_coin([])
		coin_parent.add_child(coin)
		coin.global_position = coin_rain_marker.global_position
		coin.linear_velocity = Vector3(randf_range(-0.7, 0.7), 0., randf_range(-0.7, 0.7))
		coin.rotation = Vector3(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))
		await get_tree().create_timer(0.05).timeout

func coin_explode() -> void:
	var coins := $Coins.get_children()
	for coin in coins:
		if coin is RigidBody3D:
			coin.apply_impulse(Vector3.UP * randf_range(0.01, 0.1), Vector3.ZERO)

func spawn_coin(add_groups: Array) -> Coin:
	var coin := coin_scene.instantiate()
	
	for group:String in add_groups:
		coin.add_to_group(group)
	
	coin_parent.add_child(coin)
	
	coin.rotation_degrees = Vector3(90, 0, 0)
	coin.position = _get_drop_location()
	
	coins_in_play += 1
	print(coins_in_play)
	return coin
	
func spawn_ability_coin(coin_type: String) -> void:
	print("spawning ", coin_type, " coin.")
	var special_coin := spawn_coin([coin_type])
	special_coin.global_position = coin_rain_marker.global_position

func _coin_detected(coin: Coin) -> void:
	print("coin detected")
	emit_signal("coin_collected", coin.value)
	if coin.is_in_group("rain"):
		coin_rain()
	if coin.is_in_group("bomb"):
		coin_explode()
	
	coins_in_play -= 1
	
	coin.queue_free()	# prevents coin from setting off this function again
						# was happening with da bomb coin :(

func _process(delta: float) -> void:
	for i: int in boards.get_child_count():
		var boards_array := boards.get_children()
		boards_array[i].global_position = Vector3(0, 1 + i * 2, -0.53)
		if  i > 0 and boards_array[i].is_in_group("bottom"):
			boards_array[i].remove_from_group("bottom")
		elif i == 0:
			boards_array[i].add_to_group("bottom")
		 

func _ready() -> void:
	if not coin_detector:
		push_error("Missing 'CoinDetector' Area3D in %s" % name)
		return
	
	coins_in_play = coin_parent.get_child_count()
	
	coin_detector.connect("body_entered", _coin_detected)
	killzone.connect("body_entered", func(body: PhysicsBody3D) -> void:
		if body.is_in_group("coin"): body.queue_free()
		coins_in_play -= 1)
	
	for board in boards.get_children():
		board.connect("add_combo", func(value: int) -> void: emit_signal("add_combo", value))
