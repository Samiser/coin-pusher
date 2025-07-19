extends CanvasLayer

@onready var coin_balance_label := $CoinBalanceLabel
@onready var coin_multi_label := $CoinMultiLabel
@onready var drop_button := $VBoxContainer/DropButton
@onready var swap_button := $SwapBoards
@onready var add_button := $AddButton
@onready var up_button := $UpButton
@onready var down_button := $DownButton
@onready var remove_button := $RemoveButton
@onready var shop := $Panel/Shop
@onready var debug_menu := $DebugPanel/DebugMenu
@onready var multi_particles := $multi_particles
@onready var coin_particles := $coin_particle
@onready var board_container := $VBoxContainer/board_container

var frame_scene: PackedScene = preload("res://UI/board_frame.tscn")

signal drop_triggered
signal swap_boards
signal add_board
signal remove_board
signal move_up
signal move_down
signal purchase(item_name: String, cost: int)
signal debug_menu_button(option: String)
signal focus_board(index: int)

var coin_count := 0.0

func add_display_board() -> void:
	var board_frame_button := frame_scene.instantiate()
	board_container.add_child(board_frame_button)
	var index := board_container.get_child_count() - 1
	board_frame_button.pressed.connect(func() -> void:
		focus_board.emit(index)
		)
	
func remove_display_board() -> void:
	if board_container.get_child_count() > 0:
		board_container.get_child(0).queue_free()


func set_balance(value: int) -> void:
	coin_balance_label.set_text(str(value))
	coin_count += float(value)

func _process(delta: float) -> void:
	coin_count -= delta * 2.0
	coin_particles.amount = max(1, int(coin_count))

func set_multi(value: int) -> void:
	coin_multi_label.set_text(str(value) + "x")
	multi_particles.emitting = true

func _ready() -> void:
	board_container.get_child(0).pressed.connect(func() -> void:
		focus_board.emit(0)
		)
	drop_button.connect("pressed", func() -> void:
		emit_signal("drop_triggered")
	)
	
	swap_button.connect("pressed", func() -> void:
		emit_signal("swap_boards")
	)
	
	add_button.connect("pressed", func() -> void:
		emit_signal("add_board")
		add_display_board()
	)
	
	remove_button.connect("pressed", func() -> void:
		emit_signal("remove_board")
		remove_display_board()
	)
	
	up_button.connect("pressed", func() -> void:
		emit_signal("move_up")
	)
	
	down_button.connect("pressed", func() -> void:
		emit_signal("move_down")
	)
	
	shop.connect("purchase", func(item_name: String, cost: int) -> void:
		emit_signal("purchase", item_name, cost)
	)
	
	debug_menu.connect("debug_menu_button", func(option: String) -> void:
		emit_signal("debug_menu_button", option)
	)
