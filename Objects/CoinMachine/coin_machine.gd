@tool
extends Node3D
class_name CoinMachine

@onready var coin_detector: Area3D = $CoinDetector
@onready var coin_rain_marker := $CoinRainMarker
@onready var coin_parent := $Coins
@onready var drop_location_marker := $Dropper/DropLocation
@onready var dropper := $Dropper
@onready var boards := $Boards
@onready var killzone := $Killzone
@onready var pusher_visible_area := $VisibleOnScreenEnabler3D

signal focus_changed

var focused_board: Node3D

var coin_scene: PackedScene = preload("res://Objects/Coin/coin.tscn")

var board_scenes: Dictionary[String, PackedScene] = {
	"pinball": preload("res://Objects/CoinMachine/Boards/PinballBoard/pinball_board.tscn"),
	"bowling": preload("res://Objects/CoinMachine/Boards/BowlingBoard/bowling_board.tscn"),
	"pin": preload("res://Objects/CoinMachine/Boards/PinBoard/pin_board.tscn")
}

var coins_in_play := 0
var coins_dropped := 0

signal coin_collected(value: int)
signal add_combo(value: int)
signal move_camera_to_board(board: Node3D)
signal pusher_visible(is_visible: bool)

func _get_drop_location() -> Vector3:
	return drop_location_marker.global_position

func _focus_board(board: Node3D) -> void:
	move_camera_to_board.emit(board)
	focused_board = board
	focus_changed.emit(boards.get_children().find(focused_board))

func focus_on(board_index: int) -> void:
	_focus_board(boards.get_child(board_index))

func get_random_board() -> String:
	return board_scenes.keys().pick_random()

func _change_focus(change: int) -> void:
	var board_array := boards.get_children()
	var focused_index := board_array.find(focused_board)
	var new_index := (focused_index + change) % board_array.size()
	focus_on(new_index)

func focus_up() -> void:
	_change_focus(1)

func focus_down() -> void:
	_change_focus(-1)

func add_board(board_name: String) -> BoardData: # return index
	if board_name in board_scenes:
		var new_board := board_scenes[board_name].instantiate()
		boards.add_child(new_board)
		dropper.position.y += 2
		_arrange_boards()
		_focus_board(boards.get_children()[-1])
		new_board.connect("add_combo", func(value: int) -> void: emit_signal("add_combo", value))
		return BoardData.new(boards.get_children().find(new_board), board_name, new_board.board_icon)
	return null

func remove_board() -> void:
	if boards.get_child_count() > 1:
		var board_array := boards.get_children()
		if focused_board == board_array[-1]:
			_focus_board(board_array[-2])
		board_array[-1].queue_free()
		dropper.position.y -= 2

func change_board(index: int, new_board: String) -> void:
	if not new_board in board_scenes:
		push_error("Board ", new_board, " not in board_scenes!")
		return
	
	var new_board_node := board_scenes[new_board].instantiate()
	var old_board_node := boards.get_child(index)
	new_board_node.connect("add_combo", func(value: int) -> void: emit_signal("add_combo", value))
	old_board_node.add_sibling(new_board_node)
	_arrange_boards()
	old_board_node.queue_free()
	_focus_board(new_board_node)

func swap_boards(first_idx: int, second_idx: int) -> void:
	if first_idx == second_idx:
		return

	var children := boards.get_children()
	var count := children.size()

	if first_idx < 0 or first_idx >= count or second_idx < 0 or second_idx >= count:
		push_error("Index out of bounds.")
		return

	var first_node := children[first_idx]
	var second_node := children[second_idx]

	if first_idx < second_idx:
		boards.move_child(second_node, first_idx)
		boards.move_child(first_node, second_idx)
	else:
		boards.move_child(first_node, second_idx)
		boards.move_child(second_node, first_idx)

func coin_rain() -> void:
	for i in range(10):
		var coin := spawn_coin([])
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
	coin.spawn_height = coin.position.y
	coin.id = coins_dropped
	
	coins_dropped += 1
	coins_in_play += 1

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

func _arrange_boards() -> void:
	var boards_array := boards.get_children()
	for i: int in boards.get_child_count():
		var board := boards_array[i]
		board.global_position = Vector3(0, 1 + i * 2, -0.53)
		
		if i == 0:
			if not board.is_in_group("bottom"):
				board.add_to_group("bottom")
		elif board.is_in_group("bottom"):
			boards_array[i].remove_from_group("bottom")

func _process(_delta: float) -> void:
	_arrange_boards()

func _ready() -> void:
	if not coin_detector:
		push_error("Missing 'CoinDetector' Area3D in %s" % name)
		return
	
	coins_in_play = coin_parent.get_child_count()
	
	coin_detector.connect("body_entered", _coin_detected)
	pusher_visible_area.screen_exited.connect(func() -> void: _pusher_visible(false))
	pusher_visible_area.screen_entered.connect(func() -> void: _pusher_visible(true))
	killzone.connect("body_entered", func(body: PhysicsBody3D) -> void:
		if body.is_in_group("coin"):
			body.queue_free()
		coins_in_play -= 1
	)

func _pusher_visible(is_visible: bool) -> void:
	pusher_visible.emit(is_visible)
	print(is_visible)
